%NXTCLEANUP script
%   Disconnect from the NXT and release joystick

% Disconnect from the NXT
NXTDisconnect();

% Release joystick
clear('joymex2');