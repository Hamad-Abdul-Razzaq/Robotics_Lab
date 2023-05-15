function q = findJointAngles(x,y,z,phi)
q = zeros(4,4);
a4 = 7.6; d1 = 5.4; a2 = 10.8; a3 = 10.8;
x13 = sqrt(x^2 + y^2) - a4*cos(phi);
y13 =  z - d1 - a4*sin(phi);
r = sqrt(x13^2 + y13^2);
alpha = acos((a2^2 + (r^2-a3^2))/(2*a2*r));
beta = acos((- a2^2 - a3^2 + x13^2 + y13^2)/(2*a2*a3));

% Solution Set 1
theta1 = atan2(y,x); % Theta 1 (1)
theta3 = beta; 
gamma = atan2(z - d1 -a4*sin(phi),( sqrt(x^2 + y^2)) -a4*cos(phi));
theta2 = gamma - atan2(a3*sin(theta3), a2 + a3*cos(theta3));
theta4 = phi - theta2 - theta3;
q(1,:) = [theta1, theta2, theta3, theta4];
% Solution Set 2
theta1 = atan2(y,x); % Theta 1 (1)
theta3 = -beta; 
gamma = atan(y13/x13);
theta2 = (gamma - atan2(a3*sin(theta3), a2 + a3*cos(theta3)));
theta4 = phi - theta2 - theta3;
q(2,:) = [theta1, theta2, theta3, theta4];
% Solution Set 3
theta1 = atan2(y,x) + pi; % Theta 1 (2)
theta3 = -beta;
gamma = atan(y13/x13);
theta2 = pi - (gamma + atan2(a3*sin(theta3), a2 + a3*cos(theta3)));
theta4 = phi - theta2 - theta3;
q(3,:) = [theta1, theta2, theta3, theta4];
% Solution Set 4
theta1 = atan2(y,x) + pi; % Theta 1 (2)
theta3 = beta;
gamma = atan(y13/x13);
theta2 = pi - (gamma + atan2(a3*sin(theta3), a2 + a3*cos(theta3)));
theta4 = phi - theta2 - theta3;
q(4,:) = [theta1, theta2, theta3, theta4];

end