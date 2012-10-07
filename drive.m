%DRIVE script
% script for steering the nxt

% initialize nxt and joystick
nxtInit

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
    ts = int8((100 - joystick.axes.throttle)/600) + 1;

    % get the actual axes values and apply some deadzone
    x = AddDeadzone(joystick.axes.rudder, 5)/ts;
    y = AddDeadzone(-joystick.axes.stickY, 5);
    
    % convert x and y to diamond coordinates
    power = CartesianToDiamond([x y], 100);
    
    % set the power of the motors and make sure it stays within the
    % intervall [-100, 100]
    motorB.Power = max(min(int8(power(2)), 100), -100);
    motorC.Power = max(min(int8(power(1)), 100), -100);
    
    % tell the nxt to set the power to the values set above
    motorB.SendToNXT();
    motorC.SendToNXT();

    % if button 6 is held down, break out of the while loop
    running = ~joystick.buttons(6);
end

% stop the motors in case you decide to jump out of the while loop while
% the motors are still running
motorB.Stop;
motorC.Stop;

% Disconnect from the NXT and release joystick
nxtCleanup