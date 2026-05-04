% show_robot.m
% Display the Dobot Magician Lite and save a PNG to figs/.

close all; clc;

thisDir  = fileparts(mfilename('fullpath'));             
partsDir = fullfile(thisDir, '..', 'robot parts');       
figDir   = fullfile(thisDir, 'figs');                    
if ~exist(figDir,'dir'); mkdir(figDir); end

% Import the URDF

urdfPath = fullfile(partsDir, 'modelrobot.urdf');
if ~isfile(urdfPath)
    error('URDF not found at: %s', urdfPath);
end
dobot = importrobot(urdfPath);

% Show the robot
f = figure('Color','w');                 % open a new figure window
show(dobot);
title('Dobot Magician Lite');           
xlabel('X-axis'); ylabel('Y-axis'); zlabel('Z-axis');
view(135, 20);                           
axis equal; grid on;

% Save image 
outPath = fullfile(figDir, 'robot_model.png');
exportgraphics(f, outPath, 'Resolution', 200);

%  Details in Command Window 
showdetails(dobot);
fprintf('Saved figure to: %s\n', outPath);
