    function out = isValid(jointAngles)
        out = 0;
        if isreal(jointAngles(1)) && isreal(jointAngles(2)) && isreal(jointAngles(3)) && isreal(jointAngles(4))
            out = 1;
        end

    end