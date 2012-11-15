%AUTODRIVE script
% Script for steering the NXT

% If the project hasn't been initialized, initialize it
if ~exist('INITIALIZED', 'var')
	nxtInit;
end

% Initialized the light sensor
OpenLight(SENSOR_3, 'active');

% Make a struct to hold the values read from the light sensor
sLight = struct('center', GetLight(SENSOR_3), 'last', 0, 'current', 0, ...
                'all', 0, 'all_filtered', 0, 'last_filter', 'start');
sLight.last = sLight.center;
sLight.all = [sLight.center sLight.center sLight.center];

% Make a struct to keep track of time
sTime = struct('start', tic(), 'last', 0, 'new', 0, 'dt', 0);

% Make a struct to keep track of the integral
sInt = struct('current', 0, 'total', 0, 'totalAbs', 0);

% Run while-loop as long as running equals true
running = true;

% Set to true if you wanna filter the light values
USE_FILTER = true;

% The base power of the motors
VEL = 5;

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
	
    sLight.all_filtered = [sLight.all_filtered sLight.current];
    
	% The time in seconds since sTime.start
	sTime.new = toc(sTime.start);
	sTime.dt = sTime.new - sTime.last;
	sTime.last = sTime.new;
    
    % Distance from center
    dist = (sLight.current - sLight.center);
	
	% Add the current integral. dt*distance from center
    sInt.current = dist*sTime.dt;
    sInt.total = sInt.total + sInt.current;
    sInt.totalAbs = sInt.totalAbs + abs(sInt.current);
    
    % Calculate the derivative for driving without seeing the nxt
    deriv = dist - sLight.last;
    
    % Update last light reading
    sLight.last = dist;
    
    % Variables that needs to be calibrated in order to get best possible
    % automatic driving
    cSwing = 0.15;
    cDist = 1.05*cSwing;
    cInt = 2*cDist*sTime.dt/cSwing;
    cDeriv = cDist*cSwing/(3*sTime.dt);
    
    % Combine distance from center, integral and the derivative to
    % calculate a correction to the distance from the center
    correction = cDist*sLight.last + cInt*sInt.total + cDeriv*deriv;
    
    motors.b.Power = max(min(VEL + int8(correction), 100), -100);
    motors.c.Power = max(min(VEL - int8(correction), 100), -100);

% Old method using only the integral to drive
%
%     k = 0;
%     l = 0;
%     
%     if sInt.current*10 < -8
%         k = 20;
%     elseif sInt.current*10 > 10
%         l = 20;
%     end
    
% set the motor power based on the distance from the center
%     motors.b.Power = max(min(VEL + int8(sInt.current*10), 100), -100);
%     motors.b.Power = motors.b.Power + l;
%     motors.c.Power = max(min(VEL - int8(sInt.current*10), 100), -100);
%     motors.c.Power = motors.c.Power + k;
	
	% Tell the nxt to set the power to the values set above
	motors.b.SendToNXT();
	motors.c.SendToNXT();
end

% calculate the score
score = sInt.totalAbs + sTime.last;

% Stop the motors in case you decide to jump out of the while loop while
% the motors are still running
motors.b.Stop();
motors.c.Stop();

plot(sLight.all_filtered);
hold on;
plot(0:length(sLight.all_filtered), sLight.center, '-r');

% Close light sensor
CloseSensor(SENSOR_3);