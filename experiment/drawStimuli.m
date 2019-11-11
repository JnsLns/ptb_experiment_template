

% abbreviations for columns in triallist (used in the following)
vps = triallistCols.vertPosStart;  % positions
vpe = triallistCols.vertPosEnd;
hps = triallistCols.horzPosStart;
hpe = triallistCols.horzPosEnd;
vss = triallistCols.vertSizesStart;  % extent
vse = triallistCols.vertSizesEnd;
hss = triallistCols.horzSizesStart;
hse = triallistCols.horzSizesEnd;
sshs = triallistCols.shapesStart;        
sshe = triallistCols.shapesEnd;        
scs  = triallistCols.colorsStart;        
sce  = triallistCols.colorsEnd;        
lws  = triallistCols.lineWidthsStart;        
lwe  = triallistCols.lineWidthsEnd;        

% triallist row for current trial
ct = trials(curTrial,:);

% item positions in psychtoolbox coordinates / pixels
[x_pos, y_pos] = paVaToPtbPx(ct(hps:hpe), ct(vps:vpe), e.s.spatialConfig);

% item extent in pixels
x_ext = vaToPx(ct(hss:hse), e.s.spatialConfig);
y_ext = vaToPx(ct(vss:vse), e.s.spatialConfig);

% letter identities, colors, and linewidths
shapeCodes = ct(sshs:sshe);
colorCodes = ct(scs:sce);
lineWidths = vaToPx(ct(lws:lwe), e.s.spatialConfig);

% Draw items
for i = 1:sshe-sshs+1

    % skip nan entries in shapeCodes (i.e., stimIdentities)
    if ~isnan(shapeCodes(i))
        
        % straight-line letters (non-targets)
        if shapeCodes(i) ~= 0  
    
            lineItem(winsOff.stims.h, ...
                     [x_ext(i) y_ext(i)], ...      
                     [3 3], ...
                     e.s.stimShapes{shapeCodes(i)}, ...
                     lineWidths(i), ...
                     e.s.stimColors{colorCodes(i)}, ...
                     [x_pos(i), y_pos(i)], ...
                     true, ...
                     lineWidths(i), ...
                     e.s.bgColor);
        
        % letter O (target)
        else                         
            
            % note: the circle will be inscribed in the rect regardless of
            % the line width.
            Screen('FrameOval', ...
                   winsOff.stims.h, ...
                   e.s.stimColors{colorCodes(i)}, ...
                   [x_pos(i) - x_ext(i)/2, ...
                    y_pos(i) - y_ext(i)/2, ...
                    x_pos(i) + x_ext(i)/2, ...
                    y_pos(i) + y_ext(i)/2], ...
                    lineWidths(i), ...
                    lineWidths(i));
            
        end
        
    end
    
end








