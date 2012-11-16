%MANUALDRIVE script
% Script for steering the NXT

% If the project hasn't been initialized, initialize it
if ~exist('INITIALIZED', 'var')
	nxtInit;
end

% Initialized the light sensor
OpenLight(SENSOR_3, 'active');

% Make a struct to hold the values read from the light sensor
sLight = struct('center', GetLight(SENSOR_3), 'last', 0, 'current', 0, ...
                'all', 0, 'last_filter', 'start');
sLight.last = sLight.center;
sLight.all = [sLight.center sLight.center sLight.center];

% Make a struct to keep track of time
sTime = struct('start', tic(), 'last', 0, 'new', 0, 'dt', 0);

% Make a struct to hold the x and y values from the joystick
sJoy = struct('x', 0, 'y', 0, 'xc', 0, 'yc', 0);

% Make a struct to keep track of the integral
sInt = struct('current', 0, 'total', 0);

% Run while-loop as long as running equals true
running = true;

% Set to true if you wanna filter the light values
USE_FILTER = false;

% Take input from joystick to control the NXT and calculate the integral
while running
	% Get input from joystick
	joystick = joyStruct(joymex2('query', 0));
	
	% if button 6 is held down, break out of the while loop
	running = ~joystick.buttons(6);
    
    % Get the current light reading
	sLight.current = GetLight(SENSOR_3);
    
    % Store the current light value
    sLight.all = [sLight.all sLight.current];
    
    if USE_FILTER
        if strcmp(sLight.last_filter, 'start')
            sLight.current = sLight.all(end)*0.6 ...
                           + sLight.all(end - 1)*0.3 ...
                           + sLight.all(end - 2)*0.1;
        else
            sLight.current = sLight.current*0.4 + sLight.last_filter*0.6;
        end
    end
    
	% The time in seconds since sTime.start
	sTime.new = toc(sTime.start);
	sTime.dt = sTime.new - sTime.last;
	sTime.last = sTime.new;
	
	% Add the current integral. dt*distance from center
    sInt.current = sTime.dt*(sLight.current - sLight.center);
	sInt.total = sInt.total + abs(sInt.current);
    
    % Calculate the derivative for driving without seeing the nxt
    %deriv = (sLight.current - sLight.last)/sTime.dt;
    
    % Update last light reading
    sLight.last = sLight.current;
	
	% Reduces the turn speed, the higher ts, the greater the turn speed is
	% reduced
	% turn_speed = fix(3*(-joystick.axes.throttle + 1)/2) + 1;
    % DISABLED, set to a constant value of 4
	
	% Get the actual axes values and apply some deadzone
    sJoy.x = deadzone(joystick.axes.rudder, 0.05)/4;
    % For driving using the throttle. This disables driving backwards
    sJoy.y = deadzone(abs(joystick.axes.throttle - 1)/2, 0.05);
    % Comment out the above line and uncomment the next if you wanna drive
    % normal with the stick and rudder
    % sJoy.x = deadzone(joystick.axes.stickY)/4;
	
	% Map the coordinates returned by the joystick to a circle
	sJoy.xc = sJoy.x * sqrt(1 - 0.5*sJoy.y^2);
    sJoy.yc = sJoy.y * sqrt(1 - 0.5*sJoy.x^2);
    
    % Rotate these points by 45 degrees so that we can directly apply the
    % values to each of the motors	
	% Multiply by 100, then apply max and min values
	% This should give us powers from -100 to 100
	motors.b.Power = double(max(min(int8(((sJoy.yc - sJoy.xc)/sqrt(2))*100), 100), -100));
    motors.c.Power = double(max(min(int8(((sJoy.xc + sJoy.yc)/sqrt(2))*100), 100), -100));
	
	% Tell the nxt to set the power to the values set above
	motors.b.SendToNXT();
	motors.c.SendToNXT();
end

% calculate the score
score = sInt.total + sTime.last;

% Stop the motors in case you decide to jump out of the while loop while
% the motors are still running
motors.b.Stop();
motors.c.Stop();

% Close light sensor
CloseSensor(SENSOR_3);