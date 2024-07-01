clc
clear all

% Best
kp = 6;
ki = 0;
Tsc_ini = [1, 0, 0, 1;
           0, 1, 0, 0;
           0, 0, 1, 0.025;
           0, 0, 0, 1];
Tsc_fin = [0, 1, 0, 0;
           -1, 0, 0, -1;
           0, 0, 1, 0.025;
           0, 0, 0, 1];

% % Overshoot
% kp = 6;
% ki = 12;
% Tsc_ini = [1, 0, 0, 1;
%            0, 1, 0, 0;
%            0, 0, 1, 0.025;
%            0, 0, 0, 1];
% Tsc_fin = [0, 1, 0, 0;
%            -1, 0, 0, -1;
%            0, 0, 1, 0.025;
%            0, 0, 0, 1];

% % newTask
% kp = 5;
% ki = 0.05;
% Tsc_ini = [0, -1, 0, 1;
%            1, 0, 0, 1.0;
%            0, 0, 1, 0.025;
%            0, 0, 0, 1];
% Tsc_fin = [1, 0, 0, 2;
%            0, 1, 0, 0;
%            0, 0, 1, 0.025;
%            0, 0, 0, 1];

Kp = kp * eye(6);
Ki = ki * eye(6);

% Initial configuration of robot
robot_config = [0.6, -0.2, 0.2, 0, 0, 0.2, -1.6, 0, 0, 0, 0, 0, 0];

Wrapper(Tsc_ini, Tsc_fin, Kp, Ki, robot_config);
