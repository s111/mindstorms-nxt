%DRIVE script
% Script for steering the NXT

% If the project hasn't been initialized, initialize it
if ~exist(initialized)
	nxtInit;
end

% Initialized the light sensor
OpenLight(SENSOR_3, 'active');

% Make a struct to hold the values read from the light sensor
light = struct('center', GetLight(SENSOR_3), 'last', 0, 'current', 0);
light.last = light.center;

% Make a struct to keep track of time
time = struct('start', tic(), 'last', 0, 'new', 0, 'dt', 0);

% Will contain the final area calculated
area = 0;

% Run while-loop as long as running equals true
running = true;

% Take input from joystick to control the NXT and calculate the integral
while running
	% Get input from joystick
	joystick = joyStruct(joymex2('query', 0));
	
	% if button 6 is held down, break out of the while loop
	running = ~joystick.buttons(6);
	
	% Reduces the turn speed, the higher ts, the greater the turn speed is reduced
	turn_speed = fix(3*(100 - joystick.axes.throttle)/200) + 1;
	
	% Get the actual axes values and apply some deadzone
	joy = struct('x', deadzone(joystick.axes.rudder, 5)/ts, ...
				 'y', deadzone(-joystick.axes.stickY, 5), ...
				 'xc', 0, 'yc', 0);
	
	% Map the coordinates returned by the joystick to a circle
	joy.xc = joy.x * sqrt(1 - 0.5*joy.y^2);
    joy.yc = joy.y * sqrt(1 - 0.5*joy.x^2);
	
	% Rotate these points by 45 degrees and multiply by 100, then apply max and min values
	% This should give us powers from -100 to 100
	motors.B.Power = double(max(min(int8(((yCircle - xCircle)/sqrt(2))*100), 100), -100));
    motors.C.Power = double(max(min(int8(((xCircle + yCircle)/sqrt(2))*100), 100), -100));
	
	% Tell the nxt to set the power to the values set above
	motors.B.SendToNXT();
	motors.C.SendToNXT();

	% Get the current light reading
	light.current = GetLight(SENSOR_3);
	
	% The time in seconds since time.start
	time.new = toc(time.start);
	time.dt = time.new - time.last;
	time.last = time.new;
	
	% Add the current integral. dt*distance from center
	area = area + dt*abs(light.current - light.center);
	
	%deriv = (light.current - light.last)/dt;
	%light.last = light.current;
end

% Stop the motors in case you decide to jump out of the while loop while
% the motors are still running
motors.B.Stop();
motors.C.Stop();