function errorCode = setPosition(jointAngles, grip_val)
    global arb;
    new_theta = zeros(1,4); % Array for JointAngles Mapped to [-pi, pi]
    errorCode = 0; % 0 -> No error yet
    offset = [-pi/2 -pi/2 0 0];
    for i=1:4 
        % Mapping each jointangle to [-pi,pi]
        new_theta(i) = jointAngles(i) + offset(i);
        new_theta(i) = mod(new_theta(i)+pi, 2*pi) - pi; 
        % Condition for invalid input angle
        if ~(new_theta(i) < 5*pi/6 && new_theta(i) > -5*pi/6)
            disp(strcat('Angle ', num2str(i), ' Out of range'));
            % Error code = i -> ith Joint is out of range
            errorCode = i;
        end
    end
    % Passing the Joint Angles to Robot is no Error Occured
    if errorCode == 0
        % Mapping DH angles to Servo Angles
        map_theta = zeros(1,5);
        map_theta(1) = new_theta(1);
        map_theta(2) = new_theta(2);
        map_theta(3) = new_theta(3);
        map_theta(4) = new_theta(4);
        % Connecting to Robot and passing the theta information
        % to Robot for execution with a certain speed (64 for every joint
        % in this case
%         arb = Arbotix('port', 'COM4', 'nservos', 5);
        map_theta(5) = grip_val;
        arb.setpos(map_theta, [64, 64, 64, 64, 64]);
        
    end
    
end