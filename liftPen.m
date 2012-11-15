function liftPen()
    global motors;
    
    if motors.a.ReadFromNXT.Position >= 0
        d = -1;
    else
        d = 1;
    end
    
    motors.a.ResetPosition();
    motors.a.Power = d*40;
    motors.a.TachoLimit = 30;
    motors.a.SendToNXT();
    motors.a.WaitFor();
    motors.a.Stop('brake');
end
