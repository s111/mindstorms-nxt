function draw(str)
    global motors;
    
    if motors.a.ReadFromNXT.Position > 0
        error('Pen must be in the up position before using this function');
    end
    
    
    for k=1:length(str)
        if str(k) == ' '
            drive(50);
        else
            eval(['draw' str(k)]);
            drive(12);
        end
    end
end