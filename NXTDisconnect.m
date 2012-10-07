function NXTDisconnect()
%NXTDISCONNECT
%   Close connection to the NXT

    if exist('handle_NXT', 'var')
        % Close connection to the NXT
        COM_CloseNXT(handle_NXT);
    else
        % If you for some reason try to close the connection
        % to a NXT that isn't connected,
        % remind yourself of how dumb you are
        error('NXT not connected');
    end
end