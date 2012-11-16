function turn(d)
%TURN
%   turn x degrees

    % Make the motors struct usable in this function
    global motors;

    % Reset the motor postions
    motors.b.ResetPosition();
    motors.c.ResetPosition();

    % Find out which direction we wanna turn
    k = sign(d);
    
    % Set the motor powers
    motors.b.Power = -1*k*20;
    motors.c.Power = k*20;

    % Tell the nxt to drive at this power
    motors.b.SendToNXT();
    motors.c.SendToNXT();

    % Wait until we have turned enough
    while abs(motors.b.ReadFromNXT.Position) <= 2.5*abs(d)
    end

    % Stop the motors
    motors.b.Stop('brake');
    motors.c.Stop('brake');
end