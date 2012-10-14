%NXTINIT script
%   Set up paths, connect to the NXT and initialize joystick

% Add the paths to files which this script depend upon
SetPaths('RWTHMindstormsNXT', 'joymex2', 'Diamond');

% Connect to the NXT
handleNXT = NXTConnect();
COM_SetDefaultNXT(handleNXT);

% Initialize joystick
joymex2('open', 0);