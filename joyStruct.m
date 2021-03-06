function nStruct = joyStruct(jStruct)
%JOYSTRUCT
%   Cleans up struct returned by joymex2

    % This function is designed for use with the
    % Logitech Extreme 3D Pro Gaming joystick
    % Return error if you for some reason fail to understand this
    if length(jStruct.axes) < 4
        error('Joystick doesn''t have enough axes');
    end

    % Change the struct returned by joymex2 into
    % a more describing one and change the axis from [-32768, 32768]
    % to [-1, 1]
    nStruct = struct('axes', struct('stickX', ...
                                    double(jStruct.axes(1))/32768, ...
                                    'stickY', ...
                                    double(jStruct.axes(2))/32768, ...
                                    'throttle', ...
                                    double(jStruct.axes(3))/32768, ...
                                    'rudder', ....
                                    double(jStruct.axes(4))/32768), ...
                     'buttons', jStruct.buttons, ...
                     'hats', jStruct.hats);
end