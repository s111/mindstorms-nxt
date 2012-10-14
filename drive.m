%DRIVE script
% script for steering the nxt

% initialize nxt and joystick
%nxtInit

running = true;

% initialize motors
motorB = NXTMotor('B', 'SmoothStart', true);
motorC = NXTMotor('C', 'SmoothStart', true);

% initialize the light sensor
OpenLight(SENSOR_3, 'active');

% the center of the race track
center = GetLight(SENSOR_3);
% the last light value
lLast = center;
% the last 3 light values
uLight = [center center center];

% will contain the final area calculated
area = 0;

% stores the start time for use with toc (toc will return the time elapsed
% since tic was run
tStart = tic();
% the time in seconds since tStart when the last measurement was done
tLast = 0;

% take input from joystick and drive the NXT around as long as the var
% running = true
while running
    % read the value from the light sensor
    light = GetLight(SENSOR_3);
    
    uLight = [light uLight(1:2)];
    
    light = filterLight(uLight);
    
    % value from the light sensor seen from the center value
    cLight = light - center;
    
    % the time in seconds since tStart
    tNew = toc(tStart);
    % the time in seconds since the last measurement
    dt = tNew - tLast;
    % update the timing of the last measurement
    tLast = tNew;
    
    % update the area
    area = area + dt*cLight;
    
    % the derivative
    deriv = (light - lLast)/dt;
    
    % update the last light value
    lLast = light;

    % get data from joystick
    joystick = JoyStruct(joymex2('query',0));
    
    % reduces the turn speed, the higher ts, the greater the turn speed is
    % reduced
    ts = fix(3*(100 - joystick.axes.throttle)/200) + 1;

    % get the actual axes values and apply some deadzone
    x = AddDeadzone(joystick.axes.rudder, 5)/ts;
    y = AddDeadzone(-joystick.axes.stickY, 5);
    
    % convert x and y to diamond coordinates
    power = CartesianToDiamond([x y], 100);
    
    % set the power of the motors and make sure it stays within the
    % intervall [-100, 100]
    motorB.Power = max(min(int8(power.right), 100), -100);
    motorC.Power = max(min(int8(power.left), 100), -100);
    
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

% close the light sensor
CloseSensor(SENSOR_3);

% Disconnect from the NXT and release joystick
%nxtCleanup