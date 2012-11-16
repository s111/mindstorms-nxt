function drive(d)
%DRIVE
%   drives x distance

    % Make the motors struct usable in this function
    global motors;

    % Reset the motor postions
    motors.b.ResetPosition();
    motors.c.ResetPosition();
    
    % Find out which direction we wanna drive in
    k = sign(d);
    
    % Set the motor powers
    motors.b.Power = k*10;
    motors.c.Power = k*10;

    % Tell the nxt to drive at this power
    motors.b.SendToNXT();
    motors.c.SendToNXT();

    % Wait until we have gone long enough
    while abs(motors.b.ReadFromNXT.Position) <= 2*abs(d)
    end

    % Stop the motors
    motors.b.Stop('brake');
    motors.c.Stop('brake');
end