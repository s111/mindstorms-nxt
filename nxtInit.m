%NXTINIT script
%   Setup paths, connect to the NXT and initialize joystick

% Add the paths to files which this script depend upon
setPaths('RWTHMindstormsNXT', 'joymex2');

% Connect to the NXT
handle_nxt = COM_OpenNXT('bluetooth.ini');
COM_SetDefaultNXT(handle_nxt);

% Initialize motors
motor_b = NXTMotor('B', 'SmoothStart', true);
motor_c = NXTMotor('C', 'SmoothStart', true);

% Add them to a struct for readability
motors = struct('b', motor_b, 'c', motor_c);

% Initialize joystick
joymex2('open', 0);

% Tell matlab that this script has been run
INITIALIZED = true;