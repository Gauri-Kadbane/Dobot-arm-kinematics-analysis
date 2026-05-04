%% -----------------------------------------------------------
%  Dobot Magician Lite - Workspace Analysis
%  Author: Gauri Kadbane
%  Course: RAS 545 - Robotic Systems I
%  -----------------------------------------------------------

clear; clc; close all

%% Robot Link Parameters (in mm)
a1 = 53.5;     % Base offset height
a2 = 150;      % Link 1 length
a3 = 150;      % Link 2 length

%% Approximate Joint Limits (in radians)
lim_t1 = deg2rad([-90 90]);     % Base rotation
lim_t2 = deg2rad([-10 80]);     % Shoulder
lim_t3 = deg2rad([-110 10]);    % Elbow

%% Number of Samples
N = 4000;

% Generate random joint angles within limits
t1 = lim_t1(1) + rand(N,1) * (lim_t1(2) - lim_t1(1));
t2 = lim_t2(1) + rand(N,1) * (lim_t2(2) - lim_t2(1));
t3 = lim_t3(1) + rand(N,1) * (lim_t3(2) - lim_t3(1));

%% Forward Kinematics
% Position equations derived from symbolic H03
Px = cos(t1) .* (90 + a2.*sin(t2) + a3.*sin(t3 - t2));
Py = sin(t1) .* (90 + a2.*sin(t2) + a3.*sin(t3 - t2));
Pz = a1 - a2.*cos(t2) - a3.*cos(t3 - t2);

points = [Px Py Pz];

%% Compute Yoshikawa Manipulability Index 
mani = zeros(N,1);
for i = 1:N
    % Compute partial derivatives numerically for Jacobian
    J = [ ...
        -sin(t1(i))*(90 + a2*sin(t2(i)) + a3*sin(t3(i)-t2(i))),  cos(t1(i))*(a2*cos(t2(i)) - a3*cos(t3(i)-t2(i))),  cos(t1(i))*a3*cos(t3(i)-t2(i));
         cos(t1(i))*(90 + a2*sin(t2(i)) + a3*sin(t3(i)-t2(i))),  sin(t1(i))*(a2*cos(t2(i)) - a3*cos(t3(i)-t2(i))),  sin(t1(i))*a3*cos(t3(i)-t2(i));
         0,  a2*sin(t2(i)) + a3*sin(t3(i)-t2(i)),  -a3*sin(t3(i)-t2(i)) ];
    
    % Yoshikawa index = sqrt(det(J*J'))
    mani(i) = sqrt(abs(det(J*J')));
end

%% Visualization of Workspace
figure('Color','w','Position',[100 100 800 600]);
scatter3(Px, Py, Pz, 10, mani, 'filled')
colorbar
colormap turbo
xlabel('X (mm)')
ylabel('Y (mm)')
zlabel('Z (mm)')
title('Workspace of Dobot Magician Lite')
grid on; axis equal
view(45,25)

%% Projection views
figure('Color','w','Position',[950 100 700 600]);
subplot(2,2,1)
scatter(Px, Py, 8, 'b', 'filled'); grid on
xlabel('X (mm)'); ylabel('Y (mm)');
title('Top View (XY Plane)')

subplot(2,2,2)
scatter(Px, Pz, 8, 'r', 'filled'); grid on
xlabel('X (mm)'); ylabel('Z (mm)');
title('Front View (XZ Plane)')

subplot(2,2,3)
scatter(Py, Pz, 8, 'g', 'filled'); grid on
xlabel('Y (mm)'); ylabel('Z (mm)');
title('Side View (YZ Plane)')

sgtitle('Dobot Magician Lite Workspace Projections')

disp('Workspace analysis completed!')
