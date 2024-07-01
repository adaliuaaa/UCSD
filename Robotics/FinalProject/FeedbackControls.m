% Inputs: 
%   - X (aka Tse): The current actual end-effector configuration. 
%   - Xd (aka Tse_d): The current end-effector reference configuration. 
%   - Xd_next: The end-effector reference configuration at the next timestep in the reference trajectory delta t later.
%   - Kp: The P gain matrix
%   - Ki: The I gain matrix
%   - timestep: A timestep delta t between reference trajectory configurations
%
% Outputs:
%   - commanded_V: The commanded end-effector twist expressed in the end-effector frame {e}
%   - The commanded wheel speeds, u and the commanded arm joint speeds theta_dot

function [command_V, X_err, err] = FeedbackControls(X, Xd, Xd_next, Kp, Ki, err, timestep, robot_config)
    r = 0.0475;
    l = 0.47 / 2;
    w = 0.3 / 2;

    Tb0 = [1, 0, 0, 0.1662;
            0, 1, 0, 0;
            0, 0, 1, 0.0026;
            0, 0, 0, 1];
    M0e = [1, 0, 0, 0.033;
            0, 1, 0, 0;
            0, 0, 1, 0.6546;
            0, 0, 0, 1];
    Blist = [0, 0, 1, 0, 0.033, 0;
              0, -1, 0, -0.5076, 0, 0;
              0, -1, 0, -0.3526, 0, 0;
              0, -1, 0, -0.2176, 0, 0;
              0, 0, 1, 0, 0, 0].';

    thetalist = robot_config(4:8)';

    % F_6 = [0; 0; F; 0] is 6*m matrix
    F = r / 4 * [-1 / (l + w), 1 / (l + w), 1 / (l + w), -1 / (l + w);
                 1, 1, 1, 1;
                -1, 1, -1, 1];
            
    F_6 = [0, 0, 0, 0;
           0, 0, 0, 0;
           F;
           0, 0, 0, 0];

    Vd = se3ToVec((1 / timestep) * MatrixLog6(TransInv(Xd) * Xd_next));
    Ad_xxd = Adjoint(TransInv(X) * Xd);
    Ad_xxd_Vd = Ad_xxd * Vd;
    X_err = se3ToVec(MatrixLog6(TransInv(X) * Xd));
%     V = Ad_xxd_Vd + Kp * X_err + Ki * (X_err * timestep) ;
    V = Ad_xxd_Vd + Kp * X_err + Ki * (err + X_err * timestep) ;
    err = err + X_err * timestep;  
    % integral
    
    J_arm = JacobianBody(Blist, thetalist);
    T0e = FKinBody(M0e, Blist, thetalist);
    J_base = Adjoint(TransInv(T0e) * TransInv(Tb0)) * F_6;
    Je = [J_base, J_arm];
    Je_inv = pinv(Je,1e-3);
    command_V = Je_inv * V;
    u = command_V(1:4);
    theta_dot = command_V(5:9);

%     disp(Vd)
%     disp(Ad_xxd_Vd)
%     disp(V)
%     disp(X_err)
%     disp(Je)
%     disp(command_V)
%     disp(u)
%     disp(theta_dot)

end
