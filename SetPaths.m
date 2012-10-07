function SetPaths(varargin)
%SETPATHS
%   Add folders from current directory to search path.

    % check that we have enough arguments ...
    narginchk(1, Inf);
    
    % folder names
    args = varargin;

    % path to folder the function is being called from
    prjPath = fileparts(mfilename('fullpath'));
    
    % loop through each path
    for arg = args
        % convert cell to string
        a = char(arg);
        
        % if you must attempt to add an integer or the likes to the path
        % ...
        if ~ischar(a)
            error('Argument must be of type string');
        end
        
        % add the folder to the end of our path
        fullPath = fullfile(prjPath, a);

        % make sure the folder exist before we add it
        if exist(fullPath, 'dir')
            addpath(fullPath);
        else
            % you are missing the folder you are trying to add ...
            error('Couldn''t add %s to path\n', fullPath);
        end
    end
end