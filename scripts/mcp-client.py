"""Diagnostic stdio client for the OFFICIAL MATLAB MCP binary; stdlib only.

Examples: --binary PATH --list
          --binary PATH --tool evaluate_matlab_code --arguments-file args.json
Timeout is UNKNOWN execution state, never permission to resubmit a solve.
"""
import argparse
import json
import os
from pathlib import Path
import queue
import subprocess
import sys
import threading
import time


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--binary', required=True)
    parser.add_argument('--list', action='store_true')
    parser.add_argument('--tool')
    parser.add_argument('--arguments-file')
    parser.add_argument('--output', required=True)
    parser.add_argument('--timeout', type=float, default=90)
    args = parser.parse_args()
    if not args.list and not args.tool:
        parser.error('Specify --list or --tool')
    output = Path(args.output).resolve()
    output.parent.mkdir(parents=True, exist_ok=True)
    inbox = queue.Queue()
    stderr_path = output.with_suffix('.stderr.log')
    with stderr_path.open('w', encoding='utf-8') as stderr:
        process = subprocess.Popen(
            [args.binary, '--matlab-session-mode=existing', '--disable-telemetry=true'],
            stdin=subprocess.PIPE, stdout=subprocess.PIPE, stderr=stderr,
            text=True, encoding='utf-8', bufsize=1,
            creationflags=subprocess.CREATE_NO_WINDOW if os.name == 'nt' else 0)

        def reader():
            for line in process.stdout:
                try:
                    inbox.put(json.loads(line))
                except json.JSONDecodeError:
                    inbox.put({'transport_line': line.rstrip()})
            inbox.put({'transport_eof': True})

        threading.Thread(target=reader, daemon=True).start()
        notifications = []

        def send(message):
            process.stdin.write(json.dumps(message) + '\n')
            process.stdin.flush()

        def request(identifier, method, params):
            send({'jsonrpc': '2.0', 'id': identifier, 'method': method, 'params': params})
            deadline = time.monotonic() + args.timeout
            while True:
                remaining = deadline - time.monotonic()
                if remaining <= 0:
                    raise TimeoutError('Tool state UNKNOWN; inspect MATLAB and logs before retrying.')
                try:
                    message = inbox.get(timeout=remaining)
                except queue.Empty as exc:
                    raise TimeoutError('Tool state UNKNOWN; inspect MATLAB and logs before retrying.') from exc
                if message.get('id') == identifier and ('result' in message or 'error' in message):
                    return message
                if message.get('transport_eof'):
                    raise RuntimeError('MCP server exited; inspect ' + str(stderr_path))
                # Respond to server requests without evaluating any code from them.
                if 'method' in message and 'id' in message:
                    if message['method'] == 'roots/list':
                        send({'jsonrpc': '2.0', 'id': message['id'], 'result': {'roots': []}})
                    else:
                        send({'jsonrpc': '2.0', 'id': message['id'], 'error': {'code': -32601, 'message': 'Unsupported client method'}})
                notifications.append(message)

        result = {}
        code = 0
        try:
            result['initialize'] = request(1, 'initialize', {
                'protocolVersion': '2024-11-05', 'capabilities': {},
                'clientInfo': {'name': 'autocomsol-diagnostic', 'version': '1.0.0'}})
            if 'error' in result['initialize']:
                raise RuntimeError(str(result['initialize']['error']))
            send({'jsonrpc': '2.0', 'method': 'notifications/initialized'})
            if args.list:
                result['response'] = request(2, 'tools/list', {})
            else:
                arguments = json.loads(Path(args.arguments_file).read_text(encoding='utf-8-sig')) if args.arguments_file else {}
                result['response'] = request(2, 'tools/call', {'name': args.tool, 'arguments': arguments})
            response = result['response']
            if 'error' in response or response.get('result', {}).get('isError', False):
                code = 1
        except Exception as exc:
            result['client_error'] = str(exc)
            result['execution_state'] = 'unknown'
            code = 2
        finally:
            result['notifications'] = notifications
            output.write_text(json.dumps(result, ensure_ascii=False, indent=2), encoding='utf-8')
            # Terminate only the MCP child owned by this diagnostic; never MATLAB/COMSOL.
            process.stdin.close()
            try:
                process.wait(timeout=5)
            except subprocess.TimeoutExpired:
                process.terminate()
                process.wait(timeout=5)
        print(json.dumps(result, ensure_ascii=False, indent=2))
        return code


if __name__ == '__main__':
    sys.exit(main())
