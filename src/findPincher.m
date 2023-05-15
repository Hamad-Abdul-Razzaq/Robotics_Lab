function [x, y, z, R, theta, phi] = findPincher(jointAngles)
    T =  [
        0.5000*cos(jointAngles(1) + jointAngles(2) + jointAngles(3) + jointAngles(4)) + 0.5000*cos(jointAngles(2) - jointAngles(1) + jointAngles(3) + jointAngles(4)), - 0.5000*sin(jointAngles(2) - jointAngles(1) + jointAngles(3) + jointAngles(4)) - 0.5000*sin(jointAngles(1) + jointAngles(2) + jointAngles(3) + jointAngles(4)),  sin(jointAngles(1)), 5.4000*cos(jointAngles(1) - jointAngles(2)) + 5.4000*cos(jointAngles(1) + jointAngles(2) + jointAngles(3)) + 5.4000*cos(jointAngles(2) - jointAngles(1) + jointAngles(3)) + 3.8000*cos(jointAngles(1) + jointAngles(2) + jointAngles(3) + jointAngles(4)) + 5.4000*cos(jointAngles(1) + jointAngles(2)) + 3.8000*cos(jointAngles(2) - jointAngles(1) + jointAngles(3) + jointAngles(4));
        0.5000*sin(jointAngles(1) + jointAngles(2) + jointAngles(3) + jointAngles(4)) - 0.5000*sin(jointAngles(2) - jointAngles(1) + jointAngles(3) + jointAngles(4)),   0.5000*cos(jointAngles(1) + jointAngles(2) + jointAngles(3) + jointAngles(4)) - 0.5000*cos(jointAngles(2) - jointAngles(1) + jointAngles(3) + jointAngles(4)), -cos(jointAngles(1)), 5.4000*sin(jointAngles(1) - jointAngles(2)) - 3.8000*sin(jointAngles(2) - jointAngles(1) + jointAngles(3) + jointAngles(4)) + 5.4000*sin(jointAngles(1) + jointAngles(2) + jointAngles(3)) - 5.4000*sin(jointAngles(2) - jointAngles(1) + jointAngles(3)) + 3.8000*sin(jointAngles(1) + jointAngles(2) + jointAngles(3) + jointAngles(4)) + 5.4000*sin(jointAngles(1) + jointAngles(2));
        sin(jointAngles(2) + jointAngles(3) + jointAngles(4)),                                                                        cos(jointAngles(2) + jointAngles(3) + jointAngles(4)),    6.1232e-17,                                                                                                                                                  7.6000*sin(jointAngles(2) + jointAngles(3) + jointAngles(4)) + 10.8000*sin(jointAngles(2) + jointAngles(3)) + 10.8000*sin(jointAngles(2)) + 5.4000;
        0,                                                                                                       0,             0,                                                                                                                                                                                                                                                         1
        ];
    x = T(1,4);
    y = T(2,4);
    z = T(3, 4);
    R = T(1:3,1:3);
    theta = jointAngles(1);
    phi = sum(jointAngles(2:4));
end