# AutoCOMSOL

**通过官方 MATLAB MCP Server，让 Codex 规划、执行和验证 COMSOL 仿真的 Skill。**

[English](README.md) · 简体中文

在 Codex 中描述仿真任务，确认方案后，由 Codex 编写 MATLAB 程序，驱动已经打开的 **COMSOL with MATLAB** 会话。流程涵盖错误诊断与修复、数值验证、结果提取、独立 MATLAB 后处理及可复现交付。

AutoCOMSOL 是独立集成项目，使用 MathWorks 官方 MATLAB MCP Server 和 COMSOL LiveLink for MATLAB，不是 OpenAI、MathWorks 或 COMSOL 的官方产品。

## 工作流程

```mermaid
flowchart TD
    A[在 Codex 中描述仿真需求] --> B[调研资料并制定具体方案]
    B --> C[用户确认方案]
    C --> D[官方 MATLAB MCP Server]
    D --> E[已打开的 COMSOL with MATLAB 会话]
    E --> F[LiveLink 创建并求解 COMSOL 模型]
    F --> G{执行与验证结果}
    G -->|在已确认范围内定点修复| D
    G -->|通过| H[提取数据并用 MATLAB 后处理]
    H --> I[模型、源码、数据、图表、报告和经验日志]
```

Skill 规定工作流程，MCP 提供执行连接，LiveLink 提供 COMSOL 接口。仅复制 Skill 文件夹不会自动注册 MCP 或共享 MATLAB 会话；首次配置由包内安装脚本引导完成。

## 功能

- 安装固定版本的官方 MATLAB MCP，并校验 SHA-256。
- 以 `existing` 模式连接已经共享的 MATLAB 会话。
- 注册前备份 Codex 配置，保留其他 MCP 项。
- 针对新仿真先提出具体方案，等待用户确认。
- 生成 MATLAB 源码、记录错误、定点修复并复测。
- 按任务检查数值与物理指标，明确尚未验证的部分。
- 交付带解的 `.mph`、源码、结果文件、图表、报告和文件校验清单。
- 保存简短且经过验证的错误解决记录，供后续任务检索。

## 环境要求

| 项目 | 要求 |
|---|---|
| 操作系统 | 包内自动安装器支持 Windows x64 |
| 智能体环境 | 支持本地 Skill、Shell 和 MCP 的 Codex |
| 仿真软件 | MATLAB、COMSOL Multiphysics、LiveLink for MATLAB |
| 许可 | MATLAB、LiveLink 及任务涉及物理场的有效许可 |
| 网络 | 首次安装时可访问 GitHub 官方发布文件 |
| 可选诊断客户端 | Python 3，无须额外 Python 库 |

安装器固定使用 **MATLAB MCP Server v0.14.0**，其现有会话模式要求 MATLAB R2023a 或更高版本。还必须单独核对 COMSOL 与 MATLAB 的兼容关系。例如 COMSOL 6.3 官方列出的是 MATLAB R2024a/R2024b；本项目在 R2025b 上的测试通过，不代表该组合获得官方支持。参见 [COMSOL 兼容要求](https://www.comsol.com/system-requirements/63/module)和[官方 MCP 安装说明](https://github.com/matlab/matlab-mcp-server/tree/v0.14.0)。

## 快速开始

### 1. 安装 Skill

克隆本仓库，或下载 ZIP 后解压。在 PowerShell 中进入仓库根目录，执行：

```powershell
& .\scripts\install-skill.ps1
```

脚本将 Skill 安装到 `$CODEX_HOME/skills/autocomsol`；未设置 `CODEX_HOME` 时，使用当前用户的 `.codex/skills/autocomsol`。发现内容不同的已有 Skill 时会停止，不直接覆盖。也可以手动将完整仓库文件夹复制到技能目录，并命名为 `autocomsol`。

### 2. 安装并注册官方 MCP

```powershell
& .\scripts\install-mcp.ps1 -RegisterMcp
```

安装器下载并校验官方文件，生成 `prepare_session.m`，将 `autocomsol_matlab` 注册到 Codex。已有配置会先备份；遇到冲突的 MATLAB 注册项会停止。网络访问及用户目录写入可能需要 Codex 环境授权。

安装 Skill 后，也可以直接对 Codex 说：

```text
使用 $autocomsol 完成首次安装、连接检查和自带的最小验收测试。
```

### 3. 共享正确的 MATLAB 会话

打开 **COMSOL with MATLAB**，在该 MATLAB 命令窗口运行安装器打印的完整路径：

```matlab
run('安装器输出的完整路径/prepare_session.m')
```

脚本检查 LiveLink，按需安装已下载的官方 MATLAB MCP Toolbox，并共享当前会话。Toolbox 安装完成后，每次重新启动 MATLAB，只需在目标窗口执行：

```matlab
shareMATLABSession()
```

有多个 MATLAB 窗口时，官方服务器连接最近共享的会话。这里使用的是 MCP Toolbox 的共享命令，不是 Python Engine 的 `matlab.engine.shareEngine`。

### 4. 刷新 MCP 并验收

在 Codex 中重载 MCP，或保持 MATLAB 打开、重启 Codex 后开启新聊天。输入：

```text
使用 $autocomsol。确认 autocomsol_matlab 工具可用，读取共享的
MATLAB/COMSOL 实际版本，并运行自带验收案例，报告通过项与未解决问题。
```

连接与排错细节见[安装和连接说明](references/setup.md)。

## 如何开展实际仿真

提供几何、材料、载荷或边界条件、研究类型、目标结果，以及精度和计算资源约束。例如：

```text
使用 $autocomsol 规划器件的稳态传热仿真。我会提供几何和材料参数。
请先识别缺失信息，并提出网格、求解器、结果导出和验证方案，
等待我确认后再执行。
```

确认后，方案范围内的常规代码修复可继续自动执行。若需要改变物理假设、边界条件、约定精度或计算范围，应返回更新后的方案。对不确定的 API，应查询与安装版本一致的文档。

[仿真工作流说明](references/simulation.md)定义了验证要求、重试边界、来源记录和交付规范。

## 交付内容

典型任务目录：

```text
simulation-run/
├── plan.md
├── config.json
├── src/                 # 建模、求解、提取、后处理、验证
├── models/final.mph
├── results/             # MAT/CSV、单位和解选择等元数据
├── figures/
├── report.md
├── environment.json
├── manifest.json        # 文件哈希清单
└── logs/
    ├── run.log
    └── lessons.jsonl    # 仅记录已验证的修复
```

具体文件随任务调整；自带基准的固定输入记录在 `plan.md` 中。独立后处理脚本读取导出的数据，无须保留 COMSOL 中的实时模型对象。

## 自带验收案例

[稳态导热案例](assets/smoke/plan.md)采用 0.1 m × 0.02 m 矩形、常数导热系数、左右端恒温、上下绝热。程序对照解析解，计算两级网格，保存并重载模型，导出数据并绘制 MATLAB 图表。

![合成稳态导热验收结果](docs/images/temperature-validation.png)

本机验收环境为 Windows、MATLAB MCP v0.14.0、MATLAB R2025b、COMSOL 6.3 build 290：

| 检查项 | 实测结果 |
|---|---:|
| 温度最大绝对误差 | 6.59 × 10⁻¹¹ K |
| 边界热流相对误差 | 3.48 × 10⁻¹² |
| 相对能量不平衡 | 5.33 × 10⁻¹² |
| 两级网格温度差 | 4.58 × 10⁻¹¹ K |
| 保存重载温度差 | 0 K |

交付源码复制到另一目录后，也在同一 MATLAB 服务会话中复跑通过。这些结果用于验证自动化链路；线性解析解容易被有限元准确表示，不能据此认定任意模型物理正确，也不能替代真实问题的收敛研究。完整边界见[实际验收范围](references/release-validation.md)。

## 迁移到新电脑

携带本仓库或 ZIP，在新电脑安装 Skill 并完成首次引导。脚本根据新用户环境定位 Codex 目录，不依赖开发电脑的盘符或用户名。仓库不分发 MATLAB、COMSOL 或 MCP 二进制文件。

新电脑仍需具备软件和许可、下载官方依赖、共享目标会话，并重新运行验收。复制 Skill 本身不会自动执行安装。

## 当前限制

- 自动安装目前只支持 Windows x64。
- 已测试的 COMSOL 6.3 / MATLAB R2025b 不在 COMSOL 6.3 官方列出的 MATLAB 版本组合中。
- 尚未实现可靠的长任务后台调度、保证可用的取消机制或无人值守的跨重启恢复。
- 工具超时表示执行状态未知，重试前必须检查日志与实际状态。
- 已测试 MCP 通道对部分中文控制台文本出现乱码；显式写出的 UTF-8 JSON 和错误日志可正常读取。
- 不应让多个执行方同时修改同一 MATLAB/COMSOL 会话。
- 原始验收没有覆盖第二台物理电脑，也没有在新 Codex 聊天中验证原生工具激活。

## 仓库结构

| 路径 | 内容 |
|---|---|
| [SKILL.md](SKILL.md) | 智能体工作流与执行规则 |
| [scripts/](scripts/) | Skill/MCP 安装器、诊断客户端、MATLAB 辅助程序 |
| [assets/mcp-release.json](assets/mcp-release.json) | 固定版本及官方文件哈希 |
| [assets/smoke/](assets/smoke/) | 可复现的合成验收案例 |
| [references/](references/) | 安装、仿真、验收说明与已验证经验 |
| [INSTALL.zh-CN.md](INSTALL.zh-CN.md) | 简版中文安装指南 |

MATLAB、COMSOL、LiveLink 及官方 MATLAB MCP Server 分别遵循各自许可；本仓库不授予这些产品的使用许可。
