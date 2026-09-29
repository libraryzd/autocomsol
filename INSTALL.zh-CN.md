# AutoCOMSOL 安装与使用

适用：Windows x64，已安装 Codex、MATLAB、COMSOL 和 LiveLink for MATLAB，并具有任务所需许可。其他系统尚未提供自动安装脚本。

1. 将完整 `autocomsol` 文件夹放入用户 `.codex/skills`（如设置了 CODEX_HOME，则使用它的 skills 子目录）。
2. 在 Codex 中说：**使用 $autocomsol 完成首次安装和连接自检。** Skill 会执行自带安装脚本；网络访问和用户目录写入可能需要系统授权。
3. 按安装脚本给出的路径，在 **COMSOL with MATLAB** 命令窗口运行 `prepare_session.m`。此操作安装必要的官方 Toolbox 并共享当前窗口，每次重新启动 MATLAB 后需要再次共享。
4. 在 Codex 重载 MCP 或开启新聊天，继续连接自检。最小仿真测试先展示具体方案，收到你的确认后才运行；共享会话和安装授权不算方案确认。
5. 描述实际任务。Skill 先展示方案并等待确认，然后编程、修错并跑通模型；初步跑通后，提供网格、相对容差、算例验证三个独立勾选项。可以选择任意组合，也可不进行进一步验证，直接使用已跑通模型完成任务。
6. 任务结束后，规划按最终采用的方案重写，顺序为任务介绍、建模依据与必要理论、COMSOL 设置。规划与报告以提问语言输出为 Word `.docx`，公式及数学变量使用 Word 原生可编辑公式；初始方案及确认历史另行保留。

不能仅靠复制 Skill 完成外部软件注册或共享一个尚未打开的 MATLAB。这里把首次配置做成可重复的引导步骤；完成后无需每次重新安装。安装器不会写入用户 startup.m。

官方 MCP 固定为 v0.14.0，安装器下载后校验 SHA-256。迁移包不包含商业软件、不包含官方二进制，也不携带原电脑用户配置。需要联网访问官方 GitHub 发布文件。

手动安装入口（PowerShell，在 Skill 目录下）：

```powershell
& .\scripts\install-skill.ps1
& .\scripts\install-mcp.ps1 -RegisterMcp
```

如果 PowerShell 执行策略阻止运行脚本，可由你在确认脚本来源后使用一次性的 `powershell -NoProfile -ExecutionPolicy Bypass -File 脚本路径`，无需修改系统执行策略。Codex 沙箱权限仍须单独授权。

本版本的实际验收范围与限制见 `references/release-validation.md`。在新电脑上必须重新运行自检，不能用原电脑验收结果代替。

详细连接说明见 `references/setup.md`；执行与交付规则见 `references/simulation.md`。最小导热测试源码位于 `assets/smoke`。该线性解析解案例用于链路验收，不能替代真实模型的物理验证和网格收敛研究。
