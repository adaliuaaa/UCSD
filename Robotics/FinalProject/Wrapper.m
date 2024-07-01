% This wrapper code gives all the previous three components to generate a reference trajectory, 
% simulate robot motion, and compute control inputs to achieve the desired motion. 
%
% Input:  
%   - Tsc_ini: The initial resting configuration of the cube frame
%   - Tsc_fin: The desired final resting configuration of the cube frame
%   - Kp: P controller gain
%   - Ki: I controller gain
%   - robot_config: The initial configuration of the youBot
%
% Output:
%   - A list of N x 13 matrices saved as a .csv file. 
%     chassis phi, chassis x, chassis y, J1, J2, J3, J4, J5, W1, W2, W3, W4, gripper state
%   - A list of (N-1) x 6 matrices saved as a .csv file (X_err).
%
% Other:
%   - Tse_ini: The initial configuration of the end-effector
%   - Tce_grp: The configuration of the end-effector relative to the cube when grasping
%   - Tce_sta: The configuration of the end_effector's standoff relative to the cube before and after grasping the cube 

function final = Wrapper(Tsc_ini,Tsc_fin,Kp,Ki,robot_config)
       
    Tb0 = [1, 0, 0, 0.1662;
           0, 1, 0, 0;
           0, 0, 1, 0.0026;
           0, 0, 0, 1];

    M0e = [1, 0, 0, 0.033;
           0, 1, 0, 0;
           0, 0, 1, 0.6546;
           0, 0, 0, 1];
          
    Tse_ini = [0, 0, 1, 0.0;
               0, 1, 0, 0;
               -1, 0, 0, 0.5;
               0, 0, 0, 1];

    Tce_grp = [-sqrt(2)/2, 0, sqrt(2)/2, 0;
               0, 1, 0, 0;
               -sqrt(2)/2, 0, -sqrt(2)/2, 0;
               0, 0, 0, 1];

    Tce_sta = [-sqrt(2)/2, 0, sqrt(2)/2, 0;
               0, 1, 0, 0;
               -sqrt(2)/2, 0, -sqrt(2)/2, 0.15;
               0, 0, 0, 1];
           
    Blist = [0, 0, 1, 0, 0.033, 0;
             0, -1, 0, -0.5076, 0, 0;
             0, -1, 0, -0.3526, 0, 0;
             0, -1, 0, -0.2176, 0, 0;
             0, 0, 1, 0, 0, 0].';

    k = 1;
    timestep = 0.01;
    max_omg = 20;
    err = 0;
    
    % Create a list of trajectory for robot and an array for X_err
    robot_traj = [];
    X_err_arr = [];
    
    % 1. Use TrajectoryGenerator to generate the trajectory
    traj = TrajectoryGenerator(Tse_ini, Tsc_ini, Tsc_fin, Tce_grp, Tce_sta, k);
    
    % 2. Append the initial configuration of robot to the robot_traj
    robot_traj = [robot_traj; robot_config];

    % 3. Looping
    n = size(traj,1);     % 20s adjust in TrajectoryGenerator (Tf)

    for i = 1:(n-1)   
        thetalist = robot_config(4:8)';
        
        Xd = [traj(i,1:3), traj(i,10);
              traj(i,4:6), traj(i,11);
              traj(i,7:9), traj(i,12);
              0, 0, 0, 1];
          
        Xd_next = [traj(i+1,1:3), traj(i+1,10);
                   traj(i+1,4:6), traj(i+1,11);
                   traj(i+1,7:9), traj(i+1,12);
                   0, 0, 0, 1];

        Tsb = [cos(robot_config(1)), -sin(robot_config(1)), 0, robot_config(2);
               sin(robot_config(1)), cos(robot_config(1)), 0, robot_config(3); 
               0, 0, 1, 0.0963;
               0, 0, 0, 1];
           
        T0e = FKinBody(M0e, Blist, thetalist);
        Tbe = Tb0 * T0e;
        X = Tsb * Tbe;

        % 4. Get the commanded Twist and error vector from FeedbackControl function
        [commanded_V, X_err, err] = FeedbackControls(X, Xd, Xd_next, Kp, Ki, err, timestep, robot_config);

        X_err_arr = [X_err_arr; X_err'];

        wheel_speed = commanded_V(1:4);
        arm_speed = commanded_V(5:9);

        % 5. Update the robot_config
        control = [arm_speed; wheel_speed]';
        robot_config = NextState(robot_config, control, timestep, max_omg);
        robot_current_traj = [robot_config, traj(i,13)];
        robot_traj = [robot_traj; robot_current_traj];
    end

    % 6. Save the X_err vector
    csvwrite('X_err.csv', X_err_arr);

    % 7. Generating .csv file for robot
    csvwrite('robot_config.csv', robot_traj);

    % 8. Plot X_err
    t = linspace(0, (n-1)/100, (n-1));
    figure;
    plot(t, X_err_arr(:,1))
    hold on
    plot(t, X_err_arr(:,2))
    hold on
    plot(t, X_err_arr(:,3))
    hold on 
    plot(t, X_err_arr(:,4))
    hold on 
    plot(t, X_err_arr(:,5))
    hold on
    plot(t, X_err_arr(:,6))
    hold on 
    title('X_err plot');
    xlabel('Time (s)');
    ylabel('Error');
    legend({'Xerr[1]', 'Xerr[2]', 'Xerr[3]', 'Xerr[4]', 'Xerr[5]', 'Xerr[6]'});
    grid on;

end