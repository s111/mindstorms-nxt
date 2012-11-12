%NXTINIT script
%   Setup paths, connect to the NXT and initialize joystick

% Add the paths to files which this script depend upon
SetPaths('RWTHMindstormsNXT', 'joymex2');

% Connect to the NXT
handleNXT = nxtConnect();
COM_SetDefaultNXT(handleNXT);

% Initialize motors
motorB = NXTMotor('B', 'SmoothStart', true);
motorC = NXTMotor('C', 'SmoothStart', true);

% Add them to a struct for readability
motors = struct('b', motorB, 'c', motorC);

% Initialize joystick
joymex2('open', 0);

% Tell matlab that this script has been run
initialized = true;