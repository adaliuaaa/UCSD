clc
clear all

robot_config = [0, 0, 0, 0, 0, 0.2, -1.6, 0];

X = [0.17, 0, 0.985, 0.387;
       0, 1, 0, 0;
       -0.985, 0, 0.17, 0.570;
       0, 0, 0, 1];
   
Xd = [0, 0, 1, 0.5;
       0, 1, 0, 0;
       -1, 0, 0, 0.5;
       0, 0, 0, 1];
   
Xd_next = [0, 0, 1, 0.6;
           0, 1, 0, 0;
           -1, 0, 0, 0.3;
           0, 0, 0, 1];
       
Kp = zeros(6);
 
Ki = zeros(6);
 
timestep = 0.01;

fbc = FeedbackControls(X, Xd, Xd_next, Kp, Ki, timestep, robot_config);


