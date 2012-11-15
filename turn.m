function turn(d)
%TURN
%   turn x degrees

    global motors;

    motors.b.ResetPosition();
    motors.c.ResetPosition();

    k = sign(d);
    
    motors.b.Power = -1*k*20;
    motors.c.Power = k*20;

    motors.b.SendToNXT();
    motors.c.SendToNXT();

    while abs(motors.b.ReadFromNXT.Position) <= 2.5 * abs(d)
    end

    motors.b.Stop('brake');
    motors.c.Stop('brake');
end