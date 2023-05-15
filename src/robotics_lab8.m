% Depth Resolution = 640 x 480
% Color Resolution = 1920 x 1080
% Horizontal 69
% Vertical 54
% Horizontal Color 68
% Vertical Color 41.5
% Diagonal Color 75
I = [
    1408.9 0 950.7;
    0, 140
    
    ]
Rx_180 = [1 0 0; 0 cos(pi) -sin(pi); 0 sin(pi) cos(pi)];
h = 0.584; % 0.57
T = [Rx_180 [0;0;h]];
d = 60;
f_h = d/(2*tan(deg2rad(68)/2));
f_v = d/(2*tan(deg2rad(41.5)/2));
K = [
    479.4813 1 313.6514 ;
    0 479.4813 244.2748 ;
    0 0 1 
    ];
Z = 820;
K = [
    1399.1 1 944.4568 ;
    0 1399.1 533.8895;
    0 0 1 
    ];
T_ = [
    1 0 0 -20;
    0 cos(pi) -sin(pi) 0;
    0 sin(pi) cos(pi) 688;
    ];
X = inv(K * T_) * [u;v;1]*Z;
M(end+1,:) = [0 0 0 1];
% a = [770.820*(282-100); 770.820*(205+30); 770.820];
% % b = T(1:3,1:3)*a + T(1:3,4)
% % v = R(1:3,1:3)*a + R(1:3,4)
% v = inv(K)*a
% b = [2 ; 2 ; 770.820];
% v1 = T_(1:3,1:3)*b + T_(1:3,4)
% x = v(1)/10
% y = v(2)/10
% z = (v1(3) + 770.820)/10
% fg = findJointAngles(x, y, z-8,-pi/2);
% setPosition(fg(2,:), 0)
% -18, -1, 0
zv = 749.962
a = [zv*(194); zv*(416); zv];
% b = T(1:3,1:3)*a + T(1:3,4)
% v = R(1:3,1:3)*a + R(1:3,4)
v = inv(M)*[a; 1]
b = [2 ; 2 ; zv];
v1 = T_(1:3,1:3)*b + T_(1:3,4)
x = v(1)/10
y = v(2)/10
z = (v1(3) + zv)/10
fg = findJointAngles(x, y, z-8,-pi/2);
setPosition(fg(2,:), 0)
% 18, 7, 0

