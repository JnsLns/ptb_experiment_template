% Draw graphics that are trial-specific to offscreen windows.
% Use the window pointers stored in struct 'winsOff.myWindow.h'.
% The coordinate frame for drawing is of course the Psychtoolbox frame,
% units are pixels. Use functions 'vaToPx' and 'paVaToPtbPx' to convert
% from visual angle to that frame. See folder 'common_functions' for these
% functions documentations and other conversion functions you may use.
%
% Whatever you draw here will probably based on what is defined in the
% trial list for the current trial. Access the current trial's parameters
% from the trial list like this:
%
%      trials(curTrial, triallistCols.whateverYouAreLookingFor)


% some abbreviations for columns in triallist
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

% letter identities, colors, and linewidths (codes)
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








