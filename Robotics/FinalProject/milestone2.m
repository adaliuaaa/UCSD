clc
clear all

% Initialize current state
current_state = zeros(1, 12); 
% speed = [0, 0, 0, 0, 0, 10, 10, 10, 10];       % Sample controls 1
speed = [0, 0, 0, 0, 0, -10, 10, -10, 10];   % Sample controls 2
% speed = [0, 0, 0, 0, 0, -10, 10, 10, -10];   % Sample controls 3
timestep = 0.01;
max_omg = 15;

trajectory = []; 

% Iterations
for i = 1:100
    next_state = NextState(current_state, speed, timestep, max_omg);
    current_state = next_state;
    current_traj = [current_state, 0];
    trajectory(i, :) = current_traj;
end
% chassis phi, chassis x, chassis y, J1, J2, J3, J4, J5, W1, W2, W3, W4, gripper state

% Save the trajectory to a CSV file
csvwrite('Next_State.csv', trajectory);