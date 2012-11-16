function liftPen()
%LIFTPEN
%   Lifts the pen up and down
%   The pen must be set in the down position when you initially start to
%   use this function

    % Make the motors struct usable in this function
    global motors;
    
    % Find out if the pen is up or down
    % and lift it in the opposite direction
    if motors.a.ReadFromNXT.Position >= 0
        d = -1;
    else
        d = 1;
    end
    
    % Reset the position of the motors and make them move until they have
    % reach a set limit
    motors.a.ResetPosition();
    motors.a.Power = d*100;
    motors.a.TachoLimit = 40;
    motors.a.SendToNXT();
    motors.a.WaitFor();
    motors.a.Stop('brake');
end
