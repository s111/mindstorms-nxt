function NXTConnect()
%NXTCONNECT
%   Open new NXT connection.
%   USB connection will be used if present. If no USB device is found,
%   the Bluetooth configuration file will be used

    if ~exist('handle_NXT', 'var')
        % connect to the NXT and set the default handle
        handle_NXT = COM_OpenNXT('bluetooth.ini');
        COM_SetDefaultNXT(handle_NXT);
    else
        % if you for some reason call this while already connected
        error('NXT already connected');
    end
end