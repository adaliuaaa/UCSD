% Inputs: 
%   - Tse_initial: the initial configuration of the end-effector 
%   - Tsc_initial: the initial configuration of the cube 
%   - Tsc_final: the desired final configuration of the cube
%   - Tce_grasp: the configuration of the end-effector relative to the cube while grasping
%   - Tce_standoff: the standoff configuration of the end-effector above the cube, before and after grasping, relative to the cube
%   - k: the number of trajectory reference configurations per 0.01 seconds, is an integer with a value of 1 or greater. 
%
% Outputs:
%   - Tse: 4x4 array representing the end-effector configuration:
%       [r11, r12, r13, px;
%        r21, r22, r23, py;
%        r31, r32, r33, pz;
%        0,   0,   0,   1]
%   - A csv file with the entire eight-segment reference trajectory. 
%     r11, r12, r13, r21, r22, r23, r31, r32, r33, px, py, pz, gripper state

function Traj = TrajectoryGenerator(Tse_initial, Tsc_initial, Tsc_final, Tce_grasp, Tce_standoff, k)
    Traj = [];
    
    Tse_init_standoff = Tsc_initial * Tce_standoff;
    Tse_init_grasp = Tsc_initial * Tce_grasp;
    Tse_fin_standoff = Tsc_final * Tce_standoff;
    Tse_fin_grasp = Tsc_final * Tce_grasp;
    
%   Tf: Total time of the motion in seconds from rest to rest,
%   N: The number of points N > 1 (Start and stop) in the discrete representation of the trajectory,
%   method: The time-scaling method, where 3 indicates cubic (third-order polynomial) time scaling and 5 indicates 
%           quintic (fifth-order polynomial) time scaling.

    method = 5;

    % 1. Move the gripper from its initial configuration to a ¡°standoff¡± configuration
    Tf1 = 5;
    N1 = Tf1*k/0.01;
    gripper_state = 0;
    traj1 = CartesianTrajectory(Tse_initial, Tse_init_standoff, Tf1, N1, method);
    Traj = matrix2list(Traj, traj1, N1, gripper_state);

    % 2. Move the gripper down to the grasp position
    Tf2 = 2;
    N2 = Tf2*k/0.01;
    traj2 = CartesianTrajectory(Tse_init_standoff, Tse_init_grasp, Tf2, N2, method);
    Traj = matrix2list(Traj, traj2, N2, gripper_state);

    % 3. Close the gripper
    Tf3 = 1;
    N3 = Tf3*k/0.01;
    gripper_state = 1;
    traj3 = CartesianTrajectory(Tse_init_grasp, Tse_init_grasp, Tf3, N3, method);
    Traj = matrix2list(Traj, traj3, N3, gripper_state);

    % 4. Move the gripper back up to the ¡°standoff¡± configuration
    Tf4 = 2;
    N4 = Tf4*k/0.01;
    traj4 = CartesianTrajectory(Tse_init_grasp, Tse_init_standoff, Tf4, N4, method);
    Traj = matrix2list(Traj, traj4, N4, gripper_state);

    % 5. Move the gripper to a ¡°standoff¡± configuration above the final configuration
    Tf5 = 5;
    N5 = Tf5*k/0.01;
    traj5 = CartesianTrajectory(Tse_init_standoff, Tse_fin_standoff, Tf5, N5, method);
    Traj = matrix2list(Traj, traj5, N5, gripper_state);

    % 6. Move the gripper to the final configuration of the object
    Tf6 = 2;
    N6 = Tf6*k/0.01;
    traj6 = CartesianTrajectory(Tse_fin_standoff, Tse_fin_grasp, Tf6, N6, method);
    Traj = matrix2list(Traj, traj6, N6, gripper_state);

    % 7. Open the gripper
    Tf7 = 1;
    N7 = Tf7*k/0.01;
    gripper_state = 0;
    traj7 = CartesianTrajectory(Tse_fin_grasp, Tse_fin_grasp, Tf7, N7, method);
    Traj = matrix2list(Traj, traj7, N7, gripper_state);

    % 8. Move the gripper back to the ¡±standoff¡± configuration
    Tf8 = 2;
    N8 = Tf8*k/0.01;
    traj8 = CartesianTrajectory(Tse_fin_grasp, Tse_fin_standoff, Tf8, N8, method);
    Traj = matrix2list(Traj, traj8, N8, gripper_state);
end
