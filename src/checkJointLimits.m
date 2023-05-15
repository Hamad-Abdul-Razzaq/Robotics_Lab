function out = checkJointLimits(jointAngles)
    new_theta = zeros(1,4); % Array for JointAngles Mapped to [-pi, pi]
    offset = [-pi/2 -pi/2 0 0];
    out = 1;
    for i=1:4 
        % Mapping each jointangle to [-pi,pi]
        new_theta(i) = jointAngles(i) + offset(i);
        new_theta(i) = mod(new_theta(i)+pi, 2*pi) - pi;
        % Condition for invalid input angle
        if ~(new_theta(i) < 5*pi/6 && new_theta(i) > -5*pi/6)
            out = 0;
            break;
        end
    end
end