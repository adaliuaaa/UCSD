% Inputs: 
%   - The current state of the robot (12 variables: 3 for chassis, 5 for arm, 4 for wheel angles)
%   - The joint and wheel velocities (9 variables: 5 for arm theta_dot, 4 for wheels u)
%   - The timestep size delta_t (1 parameter)
%   - The maximum joint and wheel velocity magnitude (1 parameter)
%
% Outputs:
%   - The next state (configuration) of the robot (12 variables)

function next_state = NextState(current_state, speed, timestep, max_omg)
    % new arm joint angles = (old arm joint angles) + (joint speeds) * ¦¤t
    % new wheel angles = (old wheel angles) + (wheel speeds) * ¦¤t
    % new chassis configuration is obtained from odometry (in Chapter 13.4)

    % max_omg: a positive real value indicating the maximum angular speed of the arm joints and the wheels.
    l = 0.47 / 2;  % the forward-backward distance between the wheels
    w = 0.3 / 2;  % the side-to-side distance between wheels
    r = 0.0475;  % the radius of each wheel
    
    chasis_state = current_state(1:3);
    arm_state = current_state(4:8);
    wheel_state = current_state(9:12);
    
    % Check if the arm and wheel speed is under limit
    speed_update = zeros(1, 9);
    for i = 1:length(speed)
        if speed(i) >= 0
            if speed(i) > max_omg
                speed(i) = max_omg;
                speed_update(i) = speed(i);
            else
                speed_update(i) = speed(i);
            end
        else
            if abs(speed(i)) > max_omg
                speed(i) = -max_omg;
                speed_update(i) = speed(i);
            else
                speed_update(i) = speed(i);
            end
        end
    end

    % Compute next joint angles
    theta_dot = speed(1:5);
    delta_theta = theta_dot * timestep;
    next_joint_angles = arm_state + delta_theta;

    % Compute next wheel angles
    u = speed(6:9);
    delta_u = u * timestep;
    next_wheel_angles = wheel_state + delta_u;

    % Compute next chasis configuration (odometry)
    % V_b = F * delta_u
    F = r / 4 * [-1 / (l + w), 1 / (l + w), 1 / (l + w), -1 / (l + w);
                 1, 1, 1, 1;
                -1, 1, -1, 1];
    V_b = F * delta_u';

    w_bz = V_b(1);
    v_bx = V_b(2);
    v_by = V_b(3);

    if w_bz == 0 %<= 1e-4
        delta_qb = [0; v_bx; v_by];
    else
        delta_qb = [w_bz;
                    (v_bx * sin(w_bz) + v_by * (cos(w_bz) - 1)) / w_bz;
                    (v_by * sin(w_bz) + v_bx * (1 - cos(w_bz))) / w_bz];
    end

    % delta_qb to delta_q using chasis phi
    trans = [1, 0, 0;
             0, cos(current_state(1)), -sin(current_state(1));
             0, sin(current_state(1)), cos(current_state(1))];
    delta_q = trans * delta_qb;
    next_chasis_state = chasis_state + (delta_q)';

    next_state = [next_chasis_state, next_joint_angles, next_wheel_angles];
end



