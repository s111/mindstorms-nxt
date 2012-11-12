function handle = nxtConnect()
%NXTCONNECT
%   Open new NXT connection.
%   USB connection will be used if present. If no USB device is found,
%   the Bluetooth configuration file will be used

   handle = COM_OpenNXT('bluetooth.ini');
end