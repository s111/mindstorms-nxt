%AUTODRIVE script
% Script for steering the NXT

% If the project hasn't been initialized, initialize it
if ~exist(initialized, 'var')
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

% Make a struct to keep track of the integral
sInt = struct('current', 0, 'total', 0);

% Run while-loop as long as running equals true
running = true;

% Set to true if you wanna filter the light values
USE_FILTER = false;

% The base power of the motors
VEL = 15;

% Take input from joystick to control the NXT and calculate the integral
while running
	% Get input from joystick
	joystick = joyStruct(joymex2('query', 0));
	
	% if button 6 is held down, break out of the while loop
	running = ~joystick.buttons(6);

	% Get the current light reading
	sLight.current = GetLight(SENSOR_3);
    
    % Store the current light value
    sLight.all = [sLight.all sLlight.current];
    
    if USE_FILTER
        if strcmp(sLight.last_filter, 'start')
            sLight.current = sLight.all(end)*0.6 ...
                           + sLight.all(end - 1)*0.3 ...
                           + sLight.all(end - 2)*0.3;
        else
            sLight.current = sLight.current*0.6 + sLight.last_filter*0.4;
        end
    end
	
	% The time in seconds since sTime.start
	sTime.new = toc(sTime.start);
	sTime.dt = sTime.new - sTime.last;
	sTime.last = sTime.new;
	
	% Add the current integral. dt*distance from center
    sInt.current = sTime.dt*(sLight.current - sLight.center);
    sInt.total = sInt.total + abs(sInt.current);
    
    % Calculate the derivative
    %deriv = (sLight.current - sLight.last)/sTime.dt;
    
    % Update last light reading
    sLight.last = sLight.current;
    
    % set the motor power based on the distance from the center
    motors.B.Power = max(min(VEL + int8(sInt.current*10), 100), -100);
    motors.C.Power = max(min(VEL - int8(sInt.current*10), 100), -100);
	
	% Tell the nxt to set the power to the values set above
	motors.B.SendToNXT();
	motors.C.SendToNXT();
end

% calculate the score
score = sInt.total + sTime.last;

% Stop the motors in case you decide to jump out of the while loop while
% the motors are still running
motors.B.Stop();
motors.C.Stop();