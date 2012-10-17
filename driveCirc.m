%DRIVECIRC script
% script for steering the nxt

% initialize nxt and joystick
%nxtInit

running = true;

% initialize motors
motorB = NXTMotor('B', 'SmoothStart', true);
motorC = NXTMotor('C', 'SmoothStart', true);

% take input from joystick and drive the NXT around as long as the var
% running = true
while running
    % get data from joystick
    joystick = JoyStruct(joymex2('query',0));
    
    % reduces the turn speed, the higher ts, the greater the turn speed is
    % reduced
    ts = fix(3*(100 - joystick.axes.throttle)/200) + 1;

    % get the actual axes values and apply some deadzone
    x = AddDeadzone(joystick.axes.rudder, 5)/ts;
    y = AddDeadzone(-joystick.axes.stickY, 5);
    
    % trying some exponential growth on the joystick input
    x = (-sign(x)*(-100/ts)*abs(x)^3/(100/ts)^3)/100;
    y = (-sign(y)*-100*abs(y)^3/100^3)/100;
    
    xCircle = x * sqrt(1 - 0.5*y^2);
    yCircle = y * sqrt(1 - 0.5*x^2);
    
	% rotate points by 45 degrees
    nR = (yCircle - xCircle)/sqrt(2);
    nL = (xCircle + yCircle)/sqrt(2);
    
    % make sure that nR and nL is between -100 and 100. For some reason the
    % wheels spin at a slower rate if the power is not given as a double
    nR = double(max(min(int8(nR*100), 100), -100));
    nL = double(max(min(int8(nL*100), 100), -100));
    
    motorB.Power = nR;
    motorC.Power = nL;
    
    % tell the nxt to set the power to the values set above
    motorB.SendToNXT();
    motorC.SendToNXT();

    % if button 6 is held down, break out of the while loop
    running = ~joystick.buttons(6);
end

% stop the motors in case you decide to jump out of the while loop while
% the motors are still running
pause(0.1);
motorB.Stop;
motorC.Stop;

% Disconnect from the NXT and release joystick
%nxtCleanup