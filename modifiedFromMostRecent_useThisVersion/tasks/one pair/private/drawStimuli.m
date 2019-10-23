

% abbreviations for columns in triallist (used in the following)
vps = e.s.triallistCols.vertPosStart;  % positions
vpe = e.s.triallistCols.vertPosEnd;
hps = e.s.triallistCols.horzPosStart;
hpe = e.s.triallistCols.horzPosEnd;
ves = e.s.triallistCols.vertExtStart;  % extent
vee = e.s.triallistCols.vertExtEnd;
hes = e.s.triallistCols.horzExtStart;
hee = e.s.triallistCols.horzExtEnd;
sids = e.s.triallistCols.stimIdentitiesStart;        
side = e.s.triallistCols.stimIdentitiesEnd;        
scs  = e.s.triallistCols.stimColorsEnd;        
sce  = e.s.triallistCols.stimColorsEnd;        
lws  = e.s.triallistCols.stimLineWidthsStart;        
lwe  = e.s.triallistCols.stimLineWidthsEnd;        

% triallist row for current trial
ct = e.trials(curTrial,:);

% item positions in psychtoolbox coordinates / pixels
[x_pos, y_pos] = paVaToPtbPx(ct(hps:hpe), ct(vps:vpe), spatialConfig);

% item extent in pixels
x_ext = vaToPx(ct(hes:hee), spatialConfig);
y_ext = vaToPx(ct(ves:vee), spatialConfig);

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
                     [x_pos(i), y_pos(i)]);
        
        % letter O (target)
        else                         
            
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








