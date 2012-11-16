function draw(str)
%DRAW
%   Calls the right rutines for each letter

    global motors;
    
    % The pen must be in the up position when you start to draw
    if motors.a.ReadFromNXT.Position > 0
        error('Pen must be in the up position before using this function');
    end
    
    
    % Loop through each letter in the string and call the appropriate
    % script, also add spacing between letters and words
    for k=1:length(str)
        if str(k) == ' '
            % Add a space
            drive(50);
        else
            % Draw a letter
            eval(['draw' str(k)]);
            % Add a space between letters
            % This makes the space between words a total of 62
            drive(12);
        end
    end
end