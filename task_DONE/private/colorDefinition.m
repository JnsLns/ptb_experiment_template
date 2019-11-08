%%% Convert color strings in color-definition fields of e.s (e.g.,
%   background color) to color values and/or check that they are valid RGB
%   triplets.

% fields in e.s to convert/check
fs = {'bgColor', 'textColor'}; 

white = WhiteIndex(expScreen);
black = BlackIndex(expScreen);
grey = white/2;

for fName = fs
    fName = fName{1};
    if isstr(e.s.(fName))
        switch e.s.(fName)
            case 'grey'
                e.s.(fName) = grey;
            case 'black'
                e.s.(fName) = black;
            case 'white'
                e.s.(fName) = white;
            otherwise
                error(['e.s.', fName, ' (carried over from tg.s.', fName, ') is a ', ...
                    'string, but does not match one of the expected values ', ...
                    '(''white'', ''grey'', or ''black''). Use one of these', ...
                    ' or an RGB triplet']);
        end
    elseif isvector(e.s.(fName)) && ...
            (~isrow(e.s.(fName)) || ...
            numel(e.s.(fName)) ~= 3 || ...
            any(e.s.(fName) > 255 || e.s.(fName) < 0))
        error(['e.s.', fName, ' (carried over from tg.s.', fName, ') is a ', ...
            'vector but not a valid RGB triplet (0-255) as is expected.', ...
            'Alternatively use strings ''white'', ''grey'', or ''black''.']);
    end
end