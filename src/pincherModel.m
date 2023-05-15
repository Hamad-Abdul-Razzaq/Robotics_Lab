clc; close all;
% This is a script to build the Phantom X Pincher in MATLAB based on its DH
% parameters. It is based on MATLAB example available at 
% https://www.mathworks.com/help/robotics/ug/build-manipulator-robot-using-kinematic-dh-parameters.html
% MATLAB creates a rigid body tree 


% Provide the DH parameters for the robot. The parameters are arranged in
% the order [a, alpha, d, theta], and going from link 1 to link n. The
% entry in the matrix corresponding to the joint variable is ignored. 
dhparams = [0   	pi/2	54   	pi/2;
            108	    0       0       pi/4;
            108	    0	    0	    0;
            76	    0	    0	    0];

numJoints = size(dhparams,1);

% Create a rigid body tree object.
robot = rigidBodyTree;

% Create a model of the robot using DH parameters.
% Create a cell array for the rigid body object, and another for the joint 
% objects. Iterate through the DH parameters performing this process:
% 1. Create a rigidBody object with a unique name.
% 2. Create and name a revolute rigidBodyJoint object.
% 3. Use setFixedTransform to specify the body-to-body transformation of the 
%    joint using DH parameters.
% 4. Use addBody to attach the body to the rigid body tree.
bodies = cell(numJoints,1);
joints = cell(numJoints,1);
for i = 1:numJoints
    bodies{i} = rigidBody(['body' num2str(i)]);
    joints{i} = rigidBodyJoint(['jnt' num2str(i)],"revolute");
    setFixedTransform(joints{i},dhparams(i,:),"dh");
    bodies{i}.Joint = joints{i};
    if i == 1 % Add first body to base
        addBody(robot,bodies{i},"base")
    else % Add current body to previous body by name
        addBody(robot,bodies{i},bodies{i-1}.Name)
    end
end

% Verify that your robot has been built properly by using the showdetails or
% show function. The showdetails function lists all the bodies of the robot 
% in the MATLAB® command window. The show function displays the robot with 
% a specified configuration (home by default).
showdetails(robot)
figure(Name="Phantom X Pincher")
show(robot);

%Forward Kinematics for different configurations
% Enter joint angles in the matrix below in radians
configNow = [0, pi/2, pi/2, pi/2];

% Task 4.5 verification
disp("Our Calculations:");
[x, y, z, R, theta, phi] = findPincher(configNow)

% Display robot in provided configuration
config = homeConfiguration(robot);
for i = 1:numJoints
    config(i).JointPosition = configNow(i);
end
show(robot,config);

% Determine the pose of end-effector in provided configuration
poseNow = getTransform(robot,config,"body4");

% Display position and orientation of end-effector

disp('The position of end-effector is:');
disp('');
disp(['X: ', num2str(poseNow(1,4))]);
disp('');
disp(['Y: ', num2str(poseNow(2,4))]);
disp('');
disp(['Z: ', num2str(poseNow(3,4))]);
disp(' ');
disp(['R: ']);
poseNow(1:3,1:3)
disp(' ');
disp('The orientation angle is given with respect to the x-axis of joint 2:');
disp('');
poseNow01 = getTransform(robot,config,"body1");
R14 = poseNow01(1:3,1:3)'*poseNow(1:3,1:3);
angle = rad2deg(atan2(R14(2,1),R14(1,1)));
disp(['Angle: ',num2str(angle), ' degrees.']);


% Task 4.5 Random Config

clc
% Enter joint angles in the matrix below in radians
configNow = [pi/4,pi/4,pi/4,pi/4];


% Display robot in provided configuration

for i = 1:5
    disp(strcat("Random Configuration Number: ", num2str(i)));
    config = randomConfiguration(robot);
    disp("Our Calculations:");
    config_Arr = [0, 0, 0, 0];
    config_Arr(1) = getfield(config,{1}, 'JointPosition');
    config_Arr(2) = getfield(config,{2}, 'JointPosition');
    config_Arr(3) = getfield(config,{3}, 'JointPosition');
    config_Arr(4) = getfield(config,{4}, 'JointPosition');
    [x, y, z, R, theta, phi] = findPincher(config_Arr)
    figure;
    show(robot,config);

    % Determine the pose of end-effector in provided configuration
    poseNow = getTransform(robot,config,"body4");
    
    % Display position and orientation of end-effector

    disp('The position of end-effector is:');
    disp('');
    disp(['X: ', num2str(poseNow(1,4))]);
    disp('');
    disp(['Y: ', num2str(poseNow(2,4))]);
    disp('');
    disp(['Z: ', num2str(poseNow(3,4))]);
    disp(' ');
    disp(['R: ']);
    poseNow(1:3,1:3)
    disp(' ');
    disp('The orientation angle is given with respect to the x-axis of joint 2:');
    disp('');
    poseNow01 = getTransform(robot,config,"body1");
    R14 = poseNow01(1:3,1:3)'*poseNow(1:3,1:3);
    angle = rad2deg(atan2(R14(2,1),R14(1,1)));
    disp(['Angle: ',num2str(angle), ' degrees.']);
end


%% 

N = 10;
M = 10;
arr = transpose(0:1/(N-1):1);
arr_alt = transpose(0:1/(M-1):1);
theta = [ones(1,N^3 * M); ones(1,N^3 * M); ones(1,N^3 * M); ones(1,N^3 * M)];
min_theta = [-60, -60, -150, -150] .* (pi/180);
max_theta = [240, 240, 150, 150] .* (pi/180);
x = ones(1, N^3 * M);
y = ones(1, N^3 * M);
z = ones(1, N^3 * M);
c = 1;
for i = 1:M
    for j=1:N
        for k=1:N
            for l=1:N
                theta(1,c) = min_theta(1) + (max_theta(1)-min_theta(1)) * arr_alt(i);
                theta(2,c) = min_theta(2) + (max_theta(2)-min_theta(2)) * arr(j);
                theta(3,c) = min_theta(3) + (max_theta(3)-min_theta(3)) * arr(k);
                theta(4,c) = min_theta(4) + (max_theta(4)-min_theta(4)) * arr(l);
                [x(c), y(c), z(c)] = findPincher(theta(1:4,i));
                c = c + 1;
            end
        end
    end
end


for i = 1:N^3 * M
    [x(i), y(i), z(i)] = findPincher(theta(1:4,i));
end
scatter3(x, y, z, 'filled');
figure;
[xi,yi] = meshgrid(min(x):0.01:max(x), min(y):0.01:max(y));
zi = griddata(x,y,z,xi,yi);
surf(xi,yi,zi);


 

%% Test

N = 500;
arr = transpose(0:1/(N-1):1);
theta = [ones(1,N^2); ones(1,N^2); ones(1,N^2); ones(1,N^2)];
min_theta = [-60, -60, -150, -150] .* (pi/180);
max_theta = [240, 240, 150, 150] .* (pi/180);
x = ones(1, N^2);
y = ones(1, N^2);
z = ones(1, N^2);
theta(3,:) = min_theta(3) + (max_theta(3)-min_theta(3)) * rand(N^2,1);
theta(4,:) = min_theta(4) + (max_theta(4)-min_theta(4)) * rand(N^2,1);
theta(1,:) = min_theta(1) + (max_theta(1)-min_theta(1)) * rand(N^2,1);
theta(2,:) = min_theta(2) + (max_theta(2)-min_theta(2)) * rand(N^2,1);
% a = transpose(0:1/(N-1):1);
% c = 1;
% for i=1:N
%     for j = 1:N
%     theta(1,c) = min_theta(1) + (max_theta(1)-min_theta(1)) * a(i);
%     theta(2,c) = min_theta(2) + (max_theta(2)-min_theta(2)) * a(j);    
%     c = c + 1;
%     end
% end
    



for i = 1:N^2
    [x(i), y(i), z(i)] = findPincher(theta(1:4,i));
end
figure;
scatter3(x, y, z, 10, [0 0 1], 'filled');
[X, Y, Z] = sphere(25);
figure;
hold on;
scatter3(x, y, z, 10, [0 0 1], 'filled');
s = surf(X.*((max(x) - min(x))/2 + 1) + (max(x) - min(x))/2 + min(x), Y.*((max(y) - min(y))/2 + 1) + (max(y) - min(y))/2 + min(y), (Z).*((max(z) - min(z))/2 + 2) + (max(z) - min(z))/2 + min(z));
s.FaceAlpha = 0.8;
s.FaceColor = [1 0 1];
% s.EdgeColor = 'none';
%% Task 4.9
thetas = zeros(5,4);
thetas(1,:) = [pi/2, pi/2, pi/2, pi/2];
thetas(2,:) = [-pi/4, pi/4, 0, 0];
thetas(3,:) = [-pi/4, pi/4, pi/2, -pi/2];
thetas(4,:) = [-pi/4, pi/4, -pi/2, pi/2];
thetas(5,:) = [pi/4, 5*pi/6, 0, 0];
for i=5:5
    [x, y, z, R, theta, phi] = findPincher(thetas(i,:))
    setPosition(thetas(i,:));
    pause(5);
end



