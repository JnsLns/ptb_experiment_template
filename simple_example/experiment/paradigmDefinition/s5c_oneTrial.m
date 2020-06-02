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

% Set default values for some variables
out.sequNum = sequNum;  % ordinal position at which trial was presented

% Initialize matrix for trajectory data (custom data that will be saved not
% in 'e.results' but 'e.trajectories', which is accomplished in the file
% storeCustomOutputData.m).
trajectory = [];
    


% -------------------------------------------------------------------------
% PRESENTATION STARTS HERE
% -------------------------------------------------------------------------



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





%%%% PHASE 3: Present stimuli

% If participant moves off starting position, abort trial (code 3).

out.tStimOnset_pc = nan;

if ~out.abortCode
    
    % Copy offscreen window with stims and start marker to onscreen window
    Screen('CopyWindow', winsOff.stims.h, winOn.h);
    
    % present items
    [~,out.tStimOnset_pc,~,~] = Screen('Flip', winOn.h, []);
    
    % present items for fixed time
    deltatItems = GetSecs - out.tStimOnset_pc;
    while deltatItems <= trials(curTrial, triallistCols.stimDuration)
        
        % get position of mouse pointer (in pres area frame, visual angle)
        [mouse_xy_pa_va, mouse_xy_ptb_px] =  getMouseRM();
        
        % Check whether cursor in starting position
        cursorOnStart = ...
        checkCursorInCircle(mouse_xy_pa_va, e.s.startPos_va, e.s.startRadius_va);
        
        % if start pos left, abort trial
        if ~cursorOnStart
            out.abortCode = 3;
            break;
        end
        
        % Increment timer
        deltatItems = GetSecs - out.tStimOnset_pc;
       
        % Refresh display and draw pointer
        Screen('CopyWindow', winsOff.stims.h, winOn.h);
        Screen('DrawDots', winOn.h, mouse_xy_ptb_px, ...
            vaToPx(e.s.cursorRad_va, e.s.spatialConfig)*2, ...
            e.s.cursorColor, [], 1);
        Screen('Flip', winOn.h, []);
        
    end
    
end



%%%% PHASE 3 B: Post stimulus mask

% If participant moves off starting position, abort trial (code 3).

out.tPostStimMaskOnset_pc = nan;

if ~out.abortCode
    
    % Copy offscreen window with mask to onscreen window
    Screen('CopyWindow', winsOff.postStimMask.h, winOn.h);
    
    % present mask
    [~,out.tPostStimMaskOnset_pc,~,~] = Screen('Flip', winOn.h, []);
    
    % present mask for fixed time, monitor pointer position
    deltatMask = GetSecs - out.tPostStimMaskOnset_pc;
    while deltatMask <= e.s.durPostStimMask
        
        % get position of mouse pointer (in pres area frame, visual angle)
        [mouse_xy_pa_va, mouse_xy_ptb_px] = getMouseRM();            
        
        % Check whether cursor in startin position
        cursorOnStart = ...
        checkCursorInCircle(mouse_xy_pa_va, e.s.startPos_va, e.s.startRadius_va);
        
        % if start pos left, abort trial
        if ~cursorOnStart
            out.abortCode = 3;
            break;
        end
        
        % Increment timer
        deltatMask = GetSecs - out.tPostStimMaskOnset_pc;               
        
    end
    
end



%%%% PHASE 4: Location response

% wait for click
% If allowed response time exceeded, abort trial (code 4).

out.tLocResponseOnset_pc = nan;
out.tLocResponseOffset_pc = nan;
out.tClick_pc = nan; 

if ~out.abortCode
    
    % clear onscreen window and get location response onset time
    [~,out.tLocResponseOnset_pc,~,~] = Screen('Flip', winOn.h, []);
    
    % wait for response (pointer at screen surface)
    loopCounter = 0;
    while 1
        
        loopCounter = loopCounter + 1;
        
        % get position of mouse pointer (in pres area frame, visual angle)
        [mouse_xy_pa_va, mouse_xy_ptb_px] = getMouseRM();
        pcTime = GetSecs;                
        
        % if max time is up, leave loop and abort trial
        if pcTime - out.tLocResponseOnset_pc > e.s.allowedLocResponseTime
            out.tLocResponseOffset_pc = pcTime;
            out.abortCode = 4;
            break;
        end
                
        % record pointer position
        trajectory(loopCounter, ...
            [e.s.trajCols.x, ...
            e.s.trajCols.y, ...
            e.s.trajCols.t]) = [mouse_xy_pa_va, pcTime];
                        
        % store time and proceed upon mouse click
        [~,~,mouseButtons] = GetMouse;
        if any(mouseButtons)
            out.tLocResponseOffset_pc = pcTime;
            out.tClick_pc = pcTime;
            break;
        end
        
        % Refresh display and draw pointer        
        Screen('DrawDots', winOn.h, mouse_xy_ptb_px, ...
            vaToPx(e.s.cursorRad_va, e.s.spatialConfig)*2, ...
            e.s.cursorColor, [], 1);
        Screen('Flip', winOn.h, []);
        
    end
    
end



%%%% PHASE 5: Target presence keyboard response

% wait for yes/no button to be pressed.
% if allowed response time exceeded, abort trial (code 5)

out.tgtPresentResponse = nan;
out.tTgtPresentResponseOnset_pc = nan;
out.tgtPresentResponseRT = nan;

if ~out.abortCode        
    
    % copy response window to onscreen window and show
    Screen('CopyWindow', winsOff.targetResponse.h, winOn.h);
    [~, out.tTgtPresentResponseOnset_pc, ~, ~] = Screen('Flip',winOn.h,[]);
    
    while 1                
        
        % if max time is up, leave loop and abort trial
        if GetSecs - out.tTgtPresentResponseOnset_pc > e.s.allowedTgtResponseTime
            out.abortCode = 5;
            break;
        end
        
        % Check keyboard
        [keyIsDown, secs, keyCode, ~] = KbCheck;
        
        % Store response
        if keyIsDown
            
            if strcmp(KbName(keyCode), e.s.yesKeyName)
                out.tgtPresentResponse = 1;
            elseif strcmp(KbName(keyCode), e.s.noKeyName)
                out.tgtPresentResponse = 0;
            end
            
            % store RT and proceed
            if ~isnan(out.tgtPresentResponse)
                out.tgtPresentResponseRT = ...
                    secs - out.tTgtPresentResponseOnset_pc;
                break;
            end
            
        end
        
    end
    
end

% clear onscreen window
Screen('Flip', winOn.h, []); 




% -------------------------------------------------------------------------
% PRESENTATION ENDS HERE (except for possible feedback)
% -------------------------------------------------------------------------


%%%% set trial to be rerun if it was aborted
if out.abortCode ~= 0
    rerunTrialLater = true;
end


%%%% Determine correctness and type of target presence response

out.responseCorrect = nan;
out.responseType = nan;

if ~out.abortCode

    ttype = trials(curTrial, triallistCols.trialType);
    
    if ttype == 1                       % tgt present trial         
        
        if out.tgtPresentResponse == 1          % hit (1)            
            out.responseCorrect = 1;
            out.responseType = 1;             
        elseif out.tgtPresentResponse == 0      % miss (2)         
            out.responseCorrect = 0;
            out.responseType = 2;             
        end
        
    elseif ttype == 2                   % both present trial
        
        if out.tgtPresentResponse == 1          % illusory conjunction (3)
            out.responseCorrect = 0;   
            out.responseType = 3;             
        elseif out.tgtPresentResponse == 0      % correct rejection BP (4)             
            out.responseCorrect = 1;
            out.responseType = 4;             
        end        
    
    elseif ttype == 3                   % color only trial       
        
        if out.tgtPresentResponse == 1          % feature error (5)            
            out.responseCorrect = 0;   
            out.responseType = 5;             
        elseif out.tgtPresentResponse == 0      % correct rejection CO (6)            
            out.responseCorrect = 1;
            out.responseType = 6;             
        end    
                
    end
    
end
 

%%%% Feedback

% Determine appropriate feedback
if out.abortCode == 0
        
    if out.responseCorrect == 1
        bp = e.s.feedbackBeepCorrect;        
    elseif out.responseCorrect == 0        
        bp = e.s.feedbackBeepIncorrect;        
    end        
    
    Beeper(bp(1), bp(2), bp(3));
    
elseif out.abortCode ~= 0   
    
    dur = e.s.feedback.dur_abort;
    
    if out.abortCode == 1        
        feedbackStr = e.s.feedback.notMovedToStart;       
    elseif out.abortCode == 2        
        feedbackStr = e.s.feedback.leftStartInFix;        
    elseif out.abortCode == 3        
        feedbackStr = e.s.feedback.leftStartInStim;        
    elseif out.abortCode == 4        
        feedbackStr = e.s.feedback.exceededLocRT;        
    elseif out.abortCode == 5        
        feedbackStr = e.s.feedback.exceededTgtRT;                
    end
    
    % Display feedback.
    ShowTextAndWait(feedbackStr, e.s.feedbackTextColor, winOn.h, dur, false);
    
end


%%%% create unique ID for current response

% I suggest keeping this. It doesn't hurt and allows you to identify trials
% unambigously should you require to do so.

out.reponseID = round(rand()* 1e+12);
if isfield(e.s.resCols, 'responseID')
    while any(e.results(:, e.s.resCols.responseID) == responseID)
        out.reponseID = round(rand()* 1e+12);
    end
end



