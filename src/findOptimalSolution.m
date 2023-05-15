function lst = findOptimalSolution(x, y, z, phi)
    current_angles = getCurrentPose();
%     current_angles = [-pi/3 -pi/4 pi/4 pi/4];
    current_angles(1) = current_angles(1) + pi/2;
    current_angles(2) = current_angles(2) + pi/2;
    current_angles = current_angles(:,1:4);
    IK_sol = findJointAngles(x, y, z, phi);
    IK_1 = IK_sol(1,:).*[1 1 1 1]; % Inverse Kinematic Solution 1
    IK_2 = IK_sol(2,:).*[1 1 1 1]; % Inverse Kinematic Solution 2
    IK_3 = IK_sol(3,:).*[1 1 1 1]; % Inverse Kinematic Solution 3
    IK_4 = IK_sol(4,:).*[1 1 1 1]; % Inverse Kinematic Solution 4
    IK_1 = real(IK_1);
    IK_2 = real(IK_2);
    IK_3 = real(IK_3);
    IK_4 = real(IK_4);
    for i=1:4
        current_angles(i) = mod(current_angles(i) + pi, 2*pi) - pi;
        IK_1(i) = mod(IK_1(i) + pi, 2*pi) - pi;
        IK_2(i) = mod(IK_2(i) + pi, 2*pi) - pi;
        IK_3(i) = mod(IK_3(i) + pi, 2*pi) - pi;
        IK_4(i) = mod(IK_4(i) + pi, 2*pi) - pi;
    end
    d1 = sum(abs((current_angles - IK_1)+pi)); % Delta 1
    d2 = sum(abs((current_angles - IK_2)+pi)); % Delta 2
    d3 = sum(abs((current_angles - IK_3)+pi)); % Delta 3
    d4 = 0.5*sum(abs((current_angles - IK_4)+pi)); % Delta 4
    deltas = [d1, d2, d3, d4];
    while 1
    [d,i] = min(deltas); % Extract Min
    if d == d1 && checkJointLimits(IK_1)==1 && isValid(IK_1)==1
        lst = IK_1;
        break;
    elseif d == d2 && checkJointLimits(IK_2)==1 && isValid(IK_2)==1
        lst = IK_2;
        break;
    elseif d == d3 && checkJointLimits(IK_3)==1 && isValid(IK_3)==1
        lst = IK_3;
        break;
    elseif d == d4 && checkJointLimits(IK_4)==1 && isValid(IK_4)==1
        lst = IK_4;
        break;
    else
        deltas(i) = inf;
    end
    
    end
    
end