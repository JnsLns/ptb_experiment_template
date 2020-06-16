%%%%%%%%%%%%%%%%%%%%%%%%% Run the current trial %%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% This script presents a single trial.
%
% In here, you should implement the sequential structure of the trial by
% presenting things to the participant, wait for a specific time or for
% participant actions, and then proceed to the next phase, and so on.
% Use the offscreen windows that you drew to earlier, by copying them to
% the onscreen window when needed. Use info about the current trial to
% customize what happens ('currentTrial' holds all that info).
%
%
%            ___Variables that exist at the outset of this file___
%
% ...and which you will probably need:
%
% currentTrial     table. Row of current trial from the trial list.
%                  Contains all properties of the current trial. Access
%                  trial info like this: 'currentTrial.someTrialProperty'.
% sequNum          double. total number of trials presented so far,
%                  including current trial. 
% rerunTrialLater  Boolean. Determines whether current trial will be
%                  repeated. Is automatically set to false before each
%                  trial. See below.     
% out              struct. Re-initialized before each trial to be empty.
%                  Fields become variables in the results table (see below).                 
% e.s              Experiment settings
%
% ... and which you probably won't need in this script file:
%
% triallist        table. List of all trials (rows are trials).
% curTrialNumber   double. Row number of the current trial in 'triallist'.                 
% winsOff          struct. offscreen windows (pointers: 'winsOff.myWindow.h')
% winOn            struct. onscreen window (pointer: 'winOn.h')
%
%
%              __Accessing the current trial's properties__
%
% currentTrial.whateverYouAreLookingFor
%
%
%             __Copying to onscreen window and presenting__
%
% The window pointer of the onscreen window is 'winOn.h'. So simply do:
% Screen('CopyWindow', winsOff.someWindow.h, winOn.h);
%
% To then present the image, flip from the onscreen window's frontbuffer
% to the backbuffer:
%
% Screen('Flip', winOn.h);
%
% If you need to draw things that change each frame, such as a mouse
% cursor, note that Screen('Flip', ...) clears the backbuffer by default,
% meaning you'll have to copy the offscreen window each frame, e.g.:
%
% while 1
%   Screen('CopyWindow', winsOff.someWindow.h, winOn.h);
%   Screen('DrawDots', ...);       % Draw some dots, such as a mouse cursor
%   Screen('Flip', winOn.h);       % refresh
% end
%
%
%                   __Store things in results table__
%
% To writing things to the results table and thus store them in the output 
% file, assign data to the pre-existing struct 'out'. This struct will be
% initialized automatically before each trial, so never delete or empty
% 'out' manually.
%
% During the trial simply assign any object to a field of 'out' that you
% want stored in the results table. Field names can be chosen freely,
% for instance:
%
% out.responseTime = RT;
%
% After the trial, this will automatically write the value of 'RT' to the
% table 'e.results', into a new row and into the table variable named
% 'responseTime'. If there is no variable in 'e.results' that has the same
% name as a given field of 'out', such a variable is added to 'e.results'
% automatically.
% If a new field name is used only in later trials, existing rows in
% 'e.results' will be padded with NaN (for numeric and logical data) or
% with empty cell arrays (for any other data). Once a field name has been
% used, it must only be assigned data of the same data type on later trials,
% to allow concatenating it to the results table. If a previously used field
% is not assigned in a later trial, it will be padded with NaN or empty
% cell arrays as described above.
%  
%
%             __Set current trial to be repeated later__
%
% You can rerun a trial at a later point of the experimental session, by
% setting 'rerunTrialLater = true;' anywhere in this script. This will move
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


% Initialize empty matrix for mouse trajectory data. It will be used to 
% record x-position, y-position (both in degrees visual angle), and a time
% stamp. 
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
    mouseXY_ptb = convert.paVa2ptbPx(mouseXY(1), mouseXY(2));
    Screen('DrawDots', winOn.h, mouseXY_ptb, ...
    convert.va2px(e.s.mouseCursorRadius) * 2, e.s.mouseCursorColor, [], 1);    
    % Show
    Screen('Flip', winOn.h, []);
    
end



%%%% PHASE 2: Show stimuli and wait for participant to click one dot

% Get stimulus centers and radiuses. We'll need those later to check
% whether the mouse cursor is within an item
stimsX = currentTrial.horzPos;
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
    
    % record pointer position (x,y,t). Will be stored 'out' later...
    trajectory(loopCounter, :) = [mouseXY, GetSecs];
        
    % when participant clicks, store times and response specifics, then
    % proceed
    [~,~,mouseButtons] = GetMouse;
    if any(mouseButtons)                
        
        out.tClick = GetSecs();
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
    mouseXY_ptb = convert.paVa2ptbPx(mouseXY(1), mouseXY(2));
    Screen('DrawDots', winOn.h, mouseXY_ptb, ...
        convert.va2px(e.s.mouseCursorRadius) * 2, e.s.mouseCursorColor, [], 1);
    % Show
    Screen('Flip', winOn.h, []);
    
end



%%% Store / process some additional output data

% Determine and store whether target was selected
out.correct = (currentTrial.target == out.chosenItem);

% create unique ID for current response. It doesn't hurt and allows
% identifying trials unambigously if ever needed.
out.reponseID = round(rand()* 1e+12);

% Convert trajectory matrix to a table with some sensible column names and
% store it in out, to that it will as well be saved in the results table.
out.trajectory = array2table(trajectory, 'VariableNames', {'x','y','t'});

% Some post-processing on the trajectory data to save some disk space: of
% any directly successive rows in trajectory that have identical position
% data, remove all but the first row (this happens since the loop above
% runs faster than the mouse is polled). 
out.trajectory = remSuccDuplTableRows(out.trajectory,{'x','y'});



