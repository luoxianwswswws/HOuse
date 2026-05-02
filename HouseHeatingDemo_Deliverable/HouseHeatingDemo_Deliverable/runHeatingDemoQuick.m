%% runHeatingDemoQuick.m
% 一键跑通 House Heating DQN 示例
% 使用预训练 agent，不重新训练

clear; clc; close all;

%% 0. 切换到当前脚本所在文件夹
exampleDir = fileparts(mfilename("fullpath"));
cd(exampleDir);
addpath(exampleDir);

%% 1. 基本设置
mdl = "rlHouseHeatingSystem";
agentBlk = mdl + "/Smart Thermostat/RL Agent";

sampleTime = 120;          % seconds
maxStepsPerEpisode = 1000;

%% 2. 先加载预训练 agent
S = load("HeatControlDQNAgent.mat","agent");
agent = S.agent;
agent.SampleTime = sampleTime;

%% 3. 加载温度数据
D = load("temperatureMar21toApr15_2022.mat","temperatureData");
temperatureDataAll = D.temperatureData;

temperatureMarch21 = temperatureDataAll(1:60*24,:);
temperatureApril15 = temperatureDataAll(end-60*24+1:end,:);

temperatureData = temperatureDataAll(60*24+1:end-60*24,:);
outsideTemperature = temperatureData;

comfortMax = 23;
comfortMin = 18;

%% 4. 强制写入基础工作区，供 Simulink 模型读取
assignin("base","agent",agent);
assignin("base","sampleTime",sampleTime);
assignin("base","maxStepsPerEpisode",maxStepsPerEpisode);
assignin("base","temperatureData",temperatureData);
assignin("base","outsideTemperature",outsideTemperature);
assignin("base","temperatureMarch21",temperatureMarch21);
assignin("base","temperatureApril15",temperatureApril15);
assignin("base","comfortMax",comfortMax);
assignin("base","comfortMin",comfortMin);

%% 5. 打开模型
if bdIsLoaded(mdl)
    close_system(mdl,0);
end

open_system(mdl);

% 确认 RL Agent 模块使用的变量名是 agent
set_param(agentBlk,"Agent","agent");

%% 6. 创建强化学习环境
obsInfo = rlNumericSpec([6 1]);
actInfo = rlFiniteSetSpec([0 1]);

env = rlSimulinkEnv(mdl,agentBlk,obsInfo,actInfo);
env.ResetFcn = @(in) hRLHeatingSystemResetFcn(in);

assignin("base","env",env);

%% 7. 运行仿真
simOptions = rlSimulationOptions(MaxSteps=1000);

disp("开始仿真...");
experience = sim(env,agent,simOptions);
assignin("base","experience",experience);

disp("仿真完成。");