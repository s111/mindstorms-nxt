function SetPaths(varargin)
%SETPATHS
%   Add folders from current directory to search path

    % Check that we have enough arguments ...
    narginchk(1, Inf);
    
    % Folder names
    args = varargin;

    % Path to folder the function is being called from
    prjPath = fileparts(mfilename('fullpath'));
    
    % Loop through each path
    for arg = args
        % Convert cell to string
        a = char(arg);
        
        % If you must attempt to add an integer or the likes to the path
        % ...
        if ~ischar(a)
            error('Argument must be of type string');
        end
        
        % Add the folder to the end of our path
        fullPath = fullfile(prjPath, a);

        % Make sure the folder exist before we add it
        if exist(fullPath, 'dir')
            addpath(fullPath);
        else
            % You are missing the folder you are trying to add ...
            error('Couldn''t add %s to path\n', fullPath);
        end
    end
end