%%% Convert color strings ('white, 'black', 'grey') in fields of 'e.s' whose
%   names end on 'Color' to PTB color lookup table index.

white = WhiteIndex(useScreenNumber);
black = BlackIndex(useScreenNumber);
grey = white/2;

% convert
for fName = fieldnames(e.s)'    
    fName = fName{1};
    if isstr(e.s.(fName)) && charEndsWith(fName, 'Color') 
        switch e.s.(fName)
            case 'grey'
                e.s.(fName) = grey;
            case 'black'
                e.s.(fName) = black;
            case 'white'
                e.s.(fName) = white;            
        end            
    end    
end