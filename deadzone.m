function n = deadzone(x, d)
%DEADZONE
%   Adds deadzone to joystick axes

    % Sets values between -d and d to 0
    if x > -d && x < d
        x = 0;
    end
    
    n = x;
end