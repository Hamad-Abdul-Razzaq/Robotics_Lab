State = 0;
global arb;
arb = Arbotix('port', 'COM4', 'nservos', 5);
temp = arb.getpos();
arb.setpos(temp, [64 64 64 64 64]);
motor_speeds = [64 64 64 64 64];
pause(2);
global grip_val;
grip_val = 0;
while 1
    if (State == 0)
        setPosition([pi/4 pi/4 pi/4 pi/4], grip_val);
        pause(3);
        x = 0; y = -21.6; z = -2; phi = -pi/2;
        Pick = [x y z phi];
        disp('Pick Position:');
        disp(Pick);
        State = 1;
    elseif (State == 1)
        disp('State:');
        disp(State);
        Pick(3) = Pick(3) + 3;
        theta_arr = findOptimalSolution(Pick(1), Pick(2), Pick(3), Pick(4));
        setPosition(theta_arr, grip_val);
        pause(2);
        State = 2;
    elseif State == 2
        disp('State:');
        disp(State);
        Pick(3) = Pick(3) - 3;
        theta_arr = findOptimalSolution(Pick(1), Pick(2), Pick(3), Pick(4));
        setPosition(theta_arr, grip_val);
        pause(2);
        State = 3;
    
    elseif State == 3
        grip_val = 1.2;
        disp('State:');
        disp(State);
        b = arb.getpos();
        b(5) = grip_val;
        arb.setpos(b, [64 64 64 64 64]);
        pause(3);
        State = 4;
    elseif State == 4
        disp('State:');
        disp(State);
        Pick(3) = Pick(3) + 6;
        theta_arr = findOptimalSolution(Pick(1), Pick(2), Pick(3), Pick(4));
        setPosition(theta_arr, grip_val);
        pause(2);
        State = 5;
    elseif State == 5
        disp('State:');
        disp(State);
        Place = [-21.6 0 0 -pi/2];
        State = 6;
    elseif State == 6
        disp('State:');
        disp(State);
        Place(3) = Place(3) + 3;
        theta_arr = findOptimalSolution(Place(1), Place(2), Place(3), Place(4));
        setPosition(theta_arr, grip_val);
        pause(2);
        State = 7;
    elseif State == 7
        disp('State:');
        disp(State);
        Place(3) = Place(3) - 5;
        theta_arr = findOptimalSolution(Place(1), Place(2), Place(3), Place(4));
        setPosition(theta_arr, 1.2);
        findPincher(theta_arr);
        pause(2);
        State = 8;
    elseif State == 8
        grip_val = 0;
        disp('State:');
        disp(State);
        b = arb.getpos();
        b(5) = grip_val;
        arb.setpos(b, [64 64 64 64 64]);
        pause(2);
        State = 9;
    elseif State == 9
        disp('State:');
        disp(State);
        Place(3) = Place(3) + 5;
        theta_arr = findOptimalSolution(Place(1), Place(2), Place(3), Place(4));
        setPosition(theta_arr, grip_val);     
        pause(1);
        State =10;
    elseif State == 10
        disp('State:');
        disp(State);
        arb.setpos([pi/4 pi/4 pi/4 pi/4 grip_val], [64 64 64 64 64]);
        break
    end
        
end