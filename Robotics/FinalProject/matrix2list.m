function Traj = matrix2list(Traj, traj, N, gripper_state)
    % This function converts the transformation matrix into N x 13 matrices list
    
    list = zeros(N, 13);
    
    for i = 1:N
        list(i, 1:3) = traj{i}(1, 1:3);
        list(i, 4:6) = traj{i}(2, 1:3);
        list(i, 7:9) = traj{i}(3, 1:3);
        list(i, 10) = traj{i}(1, 4);
        list(i, 11) = traj{i}(2, 4);
        list(i, 12) = traj{i}(3, 4);
        list(i, 13) = gripper_state;
        
        Traj = [Traj; list(i, :)];
    end
end
