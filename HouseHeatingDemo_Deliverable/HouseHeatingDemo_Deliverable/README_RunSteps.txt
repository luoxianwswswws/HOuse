House Heating DQN Demo 运行说明

一、运行环境
MATLAB R2026a
需要安装：Simulink、Reinforcement Learning Toolbox、Simscape、Simscape Electrical、Deep Learning Toolbox

二、文件说明
rlHouseHeatingSystem.slx：Simulink 房屋加热系统模型。
TrainDQNAgentWithLSTMToControlHouseHeatingSystemExample.m：官方主脚本。
hRLHeatingSystemResetFcn.m：环境重置函数，模型自动调用，不要单独运行。
hRLHeatingSystemValidateResetFcn.m：验证仿真重置函数，模型自动调用，不要单独运行。
HeatControlDQNAgent.mat：预训练好的 DQN Agent，用于快速仿真。
temperatureMar21toApr15_2022.mat：温度数据。
runHeatingDemoQuick.m：一键运行脚本，推荐优先运行。

三、运行步骤
1. 解压 HouseHeatingDemo_Deliverable.zip。
2. 打开 MATLAB。
3. 将 Current Folder 切换到解压后的文件夹。
4. 在命令行运行：

   runHeatingDemoQuick

如果要按官方方法运行，也可以打开并运行：

   TrainDQNAgentWithLSTMToControlHouseHeatingSystemExample.m

四、注意事项
不要单独运行 hRLHeatingSystemResetFcn.m 或 hRLHeatingSystemValidateResetFcn.m。
不要一开始直接点击 Simulink 模型的绿色运行按钮。
应先运行脚本，让 MATLAB 自动生成 agent、temperatureData、outsideTemperature 等变量。
如果只是快速验证模型，请保持 doTraining = false，这样会加载预训练 Agent，不会重新训练。
