% This script presents a single trial including feedback and assigns values
% to struct 'out' (meaning these will go into the results matrix).
%
% Everything in here can be modified freely. Present to the participants
% whatever you like and get responses, by specifying the sequential structure
% of the trials. Use the offscreen windows that were drawn to earlier,
% copying them to the onscreen window when needed. Use info from the trial
% list to further customize individual trials.
%
%
%              __Accessing the current trial's properties__
%
% trials(curTrial, triallistCols.whateverYouAreLookingFor)
%
%
%             __Copying to onscreen window and presenting__
%
% The window pointer of the onscreen window is 'winOn.h'. So simply do:
% Screen('CopyWindow', winsOff.someWindow.h, winOn.h);
%
% To then present the image, flip from the onscreen window's frontbuffer
% to the backbuffer:
% Screen('Flip', winOn.h, []);
%
% If you need to draw things that change each frame, such as a mouse
% cursor, note that Screen('Flip', ...) clears the backbuffer by default,
% meaning you'll have to copy the offscreen window each frame, e.g.:
%
% while 1
%   Screen('CopyWindow', winsOff.someWindow.h, winOn.h);
%   Screen('DrawDots', ...);       % Draw some dots, such as a mouse cursor
%   Screen('Flip', winOn.h, []);   % refresh
% end
%
%
%                 __Store things in results matrix__
%
% To store a given value in the results matrix ('e.results'), create a
% field in pre-existing struct 'out', and store the variable whose value
% you want to record in that field (e.g. out.myResultValue = myResultValue).
% Create one field for each variable you want to store. Whatever is in the
% fields of 'out' at the end of the trial will be transferred to the
% results matrix. Also, 'e.s.resCols' is automatically generated, which
% allows you to later see which column numbers of 'e.results' correspond
% to which field of 'out'. (e.g., 'e.s.resCols.RT' may hold the column
% number of response time if you did 'out.RT = RT' during the trial).
%
% However, you can only store vector data or scalars in the fields of
% 'out'. Vector data will occupy multiple columns in 'e.results', which is
% reflected by two instead of one field being created in 'e.s.resCols'.
% As usual, these will be named after the corresponding field in 'out' but
% with 'Start' and 'End' appended, respectively, and address the outer
% columns of the column span in 'e.results' occupied by the vector data.
% Note that the data written to a field of 'out' must have the same size
% as the data written to it when it was used for the first time (pad with
% nans if necessary).
%
% Never delete or empty 'out' manually, this is done automatically.
%
%
%                   __Store custom output data__
%
% Output data that does not fit the results matrix (i.e., that is not a
% scalar nor a reasonably small fixed-length vector of numeric data) can be
% stored as well. For this, store that data in some arbitrary variable in
% the current file and adjust storeCustomOutputData.m accordingly (see
% documentation there).
%
%
%             __Set current trial to be repeated later__
%
% You can rerun a trial at a later point of the experimental session, by
% setting 'rerunTrialLater = true;' anywhere in this file. This will move
% the trial (after it is finished) to a random point in the remaining
% list of trials (if trial blocks are used, i.e., e.s.useTrialBlocks ==
% true, then it is moved to a random point within the remainder of the
% current block). This can be used for instance to repeat trials that were
% aborted prematurely for some reason. Note that the results from trials
% where 'rerunTrialLater' was set to 'true' are still recorded in
% 'e.results'. It is thus a good idea to define an output variable like
% 'out.abortCode' that keeps track of which rows in 'e.results' correspond
% to aborted trials. Note that 'rerunTrialLater' is automatically reset to
% 'false' before each trial.



% Initialize matrix for trajectory data (custom data that will be saved not
% in 'e.results' but 'e.trajectories', which will be accomplished in the
% file storeCustomOutputData.m).
trajectory = [];

% Store ordinal position at which trial was presented. Can't hurt to have
% that in case we reorder rows at some point during later analysis.
out.sequNum = sequNum;  



%%%% PHASE 1: Wait for participant to move to start marker

% Copy start marker offscreen window to onscreen window & present
Screen('CopyWindow', winsOff.startMarker.h, winOn.h);
Screen('Flip', winOn.h, []);

% Initialize time counters
tOnStart = 0;               % time point where last moved onto start marker
deltatOnStart = 0;          % consecutive seconds dwelled on start marker

% Loop until participant has dwelled on marker for 'e.s.durOnStart' seconds
while deltatOnStart <= e.s.durOnStart
    
    %%% Check whether cursor on start marker
    
    % get mouse cursor position (in pres.-area frame, deg. visual angle)
    mouseXY = getMouseRM();
    
    % Check whether cursor is on start marker
    cursorOnStart = ...
        checkCursorInCircle(mouseXY, e.s.startMarkerPos, e.s.startMarkerRadius);
    
    % start or increment timer if on start marker, else reset it to zero
    if cursorOnStart
        if deltatOnStart == 0
            tOnStart = GetSecs;
        end
        deltatOnStart = GetSecs - tOnStart;
    else
        deltatOnStart = 0;
    end
    
    %%% Re-draw cursor
    
    % use start marker window as "background" (copy to onscreen win)
    Screen('CopyWindow', winsOff.startMarker.h, winOn.h);
    % Convert mouse position back to PTB coordinates, draw cursor
    [mouseXY_ptb(1), mouseXY_ptb(2)] = ...
        paVaToPtbPx(mouseXY(1), mouseXY(2), e.s.spatialConfig);
    Screen('DrawDots', winOn.h, mouseXY_ptb, ...
        vaToPx(e.s.mouseCursorRadius, e.s.spatialConfig) * 2, ...
        e.s.mouseCursorColor, [], 1);
    % Show
    Screen('Flip', winOn.h, []);
    
end



%%%% PHASE 2: Show stimuli and wait for participant to click one dot

% Get stimulus centers and radiuses. We'll need those later to check
% whether the mouse cursor is within an item
stimsX = trials(curTrial, triallistCols.horzPos);
stimsY = zeros(1, numel(stimsX)); % vertical position is always zero
stimsXY = [stimsX', stimsY'];

% Copy stimulus offscreen window to onscreen window
Screen('CopyWindow', winsOff.stims.h, winOn.h);
% present stimuli, store onset time
[~, out.tStimOnset, ~, ~] = Screen('Flip', winOn.h, []);

% wait for response (pointer at screen surface)
loopCounter = 0; 
while 1
    
    loopCounter = loopCounter + 1;
    
    % get mouse cursor position (in pres.-area frame, deg. visual angle)
    mouseXY = getMouseRM();
    
    % record cursor position to prepared trajectory matrix
    timeStamp = GetSecs;
    trajectory(loopCounter, ...
        [e.s.trajCols.x, ...
        e.s.trajCols.y, ...
        e.s.trajCols.t]) = [mouseXY, timeStamp];
    
    % when participant clicks, store times and response specifics, then
    % proceed
    [~,~,mouseButtons] = GetMouse;
    if any(mouseButtons)                
        
        out.tClick = timeStamp;
        out.movementTime = out.tClick - out.tStimOnset;        
        
        % check whether an item was clicked; if so, store that and store
        % which item was clicked; if not, set trial to be rerun and mark
        % in results matrix that the trial was rerun.
        [inStim, whichStim] = checkCursorInCircle(mouseXY, stimsXY, e.s.stimRadius);
        if inStim
            out.clickedOnItem = 1;
            out.chosenItem = whichStim;
            out.trialRepeatedLater = 0;
        else
            out.clickedOnItem = 0;
            out.chosenItem = nan;            
            out.trialRepeatedLater = 1;
            rerunTrialLater = true;
        end
        break;        
        
    end
    
   
    %%% Re-draw cursor
    
    % use stim window as "background" (copy to onscreen win)
    Screen('CopyWindow', winsOff.stims.h, winOn.h);
    % Convert mouse position back to PTB coordinates, draw cursor
    [mouseXY_ptb(1), mouseXY_ptb(2)] = ...
        paVaToPtbPx(mouseXY(1), mouseXY(2), e.s.spatialConfig);
    Screen('DrawDots', winOn.h, mouseXY_ptb, ...
        vaToPx(e.s.mouseCursorRadius, e.s.spatialConfig) * 2, ...
        e.s.mouseCursorColor, [], 1);
    % Show
    Screen('Flip', winOn.h, []);
        
end


% Determine and store whether target was selected
out.correct = (triallistCols.target == out.chosenItem);

% create unique ID for current response. It doesn't hurt and allows
% identifying trials unambigously if ever needed.
out.reponseID = round(rand()* 1e+12);




