function nxtDisconnect()
%NXTDISCONNECT
%   Close connection to the NXT

        COM_CloseNXT(COM_GetDefaultNXT());
end