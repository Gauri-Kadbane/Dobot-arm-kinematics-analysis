function robot = dobot_tree(P)
% Build Dobot Magician Lite as a rigidBodyTree
% P: struct with fields L2, L3, Ltool, Hs (meters)

robot = rigidBodyTree("DataFormat","row","MaxNumBodies",6);

% J1: yaw about z at base
b1 = rigidBody("link1");
j1 = rigidBodyJoint("joint1","revolute"); j1.JointAxis = [0 0 1];
setFixedTransform(j1, eye(4));
b1.Joint = j1; addBody(robot, b1, "base");

% J2: shoulder pitch about y, offset up by Hs
b2 = rigidBody("link2");
j2 = rigidBodyJoint("joint2","revolute"); j2.JointAxis = [0 1 0];
setFixedTransform(j2, trvec2tform([0 0 P.Hs]));
b2.Joint = j2; addBody(robot, b2, "link1");

% J3: elbow pitch about y, along upper arm length L2
b3 = rigidBody("link3");
j3 = rigidBodyJoint("joint3","revolute"); j3.JointAxis = [0 1 0];
setFixedTransform(j3, trvec2tform([P.L2 0 0]));
b3.Joint = j3; addBody(robot, b3, "link2");

% J4: tool roll about x, along forearm length L3
toolRoll = rigidBody("toolRoll");
j4 = rigidBodyJoint("joint4","revolute"); j4.JointAxis = [1 0 0];
setFixedTransform(j4, trvec2tform([P.L3 0 0]));
toolRoll.Joint = j4; addBody(robot, toolRoll, "link3");

% Tool/TCP offset Ltool
tool = rigidBody("tool");
setFixedTransform(tool.Joint, trvec2tform([P.Ltool 0 0]));
addBody(robot, tool, "toolRoll");
end
