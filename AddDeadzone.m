function n = AddDeadzone(x, d)
%ADDDEADZONE
%   adds deadzone to joystick axes

    % Sets values between -d and d to 0
    % TODO: Change this to percent based?
    if x > -d && x < d
        x = 0;
    end
    
    n = x;
end