clc
clear all

Tsb = [1, 0, 0, 0;
       0, 1, 0, 0;
       0, 0, 1, 0.0963;
       0, 0, 0, 1];

Tb0 = [1, 0, 0, 0.1662;
       0, 1, 0, 0;
       0, 0, 1, 0.0026;
       0, 0, 0, 1];

M0e = [1, 0, 0, 0.033;
       0, 1, 0, 0;
       0, 0, 1, 0.6546;
       0, 0, 0, 1];

% Tse_ini = Tsb * Tb0 * M0e;

Tse_ini = [0, 0, 1, 0.0;
           0, 1, 0, 0;
           -1, 0, 0, 0.5;
           0, 0, 0, 1];
       
Tsc_ini = [1, 0, 0, 1;
           0, 1, 0, 0;
           0, 0, 1, 0.025;
           0, 0, 0, 1];

Tsc_fin = [0, 1, 0, 0;
           -1, 0, 0, -1;
           0, 0, 1, 0.025;
           0, 0, 0, 1];

Tce_grp = [ -sqrt(2)/2, 0, sqrt(2)/2, 0;
            0, 1, 0, 0;
            -sqrt(2)/2, 0, -sqrt(2)/2, 0;
            0, 0, 0, 1];

Tce_sta = [ -sqrt(2)/2, 0, sqrt(2)/2, 0;
            0, 1, 0, 0;
            -sqrt(2)/2, 0, -sqrt(2)/2, 0.15;
            0, 0, 0, 1];

k = 1;

Trajectory = TrajectoryGenerator(Tse_ini, Tsc_ini, Tsc_fin, Tce_grp, Tce_sta, k);
csvwrite('TrajectoryGenerator.csv', Trajectory);
% disp(Trajectory);
