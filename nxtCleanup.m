%NXTCLEANUP script
%   Disconnect from the NXT and release joystick

% Disconnect from the NXT
nxtDisconnect();

% Release joystick and clear all variables
clear('all');