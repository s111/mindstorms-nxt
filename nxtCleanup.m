%NXTCLEANUP script
%   Disconnect from the NXT and release joystick

% Disconnect from the NXT
COM_CloseNXT(COM_GetDefaultNXT());

% Release joystick and clear all variables
clear('all');