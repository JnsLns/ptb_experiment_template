

% abbreviations for columns in triallist (used in the following)
vps = triallistCols.vertPosStart;  % positions
vpe = triallistCols.vertPosEnd;
hps = triallistCols.horzPosStart;
hpe = triallistCols.horzPosEnd;
vss = triallistCols.vertSizeStart;  % extent
vse = triallistCols.vertSizeEnd;
hss = triallistCols.horzSizeStart;
hse = triallistCols.horzSizeEnd;
sids = triallistCols.stimIdentitiesStart;        
side = triallistCols.stimIdentitiesEnd;        
scs  = triallistCols.stimColorsEnd;        
sce  = triallistCols.stimColorsEnd;        
lws  = triallistCols.stimLineWidthsStart;        
lwe  = triallistCols.stimLineWidthsEnd;        

% triallist row for current trial
ct = e.trials(curTrial,:);

% item positions in psychtoolbox coordinates / pixels
[x_pos, y_pos] = paVaToPtbPx(ct(hps:hpe), ct(vps:vpe), spatialConfig);

% item extent in pixels
x_ext = vaToPx(ct(hss:hse), spatialConfig);
y_ext = vaToPx(ct(vss:vse), spatialConfig);

% letter identities, colors, and linewidths
shapeCodes = ct(sids:side);
colorCodes = ct(scs:sce);
lineWidths = ct(lws:lwe);

% Draw items
for i = 1:side-sids+1

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








