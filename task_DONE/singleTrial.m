%%%% Pause execution if desired

% Check whether pause key is being pressed, if so, halt execution and
% close PTB windows. Reopen if resumed.
pauseAndResume;



%%%% Initialize things

% Clear offscreen windows
for osw = fieldnames(winsOff)'
    Screen('FillRect', winsOff.(osw), winsOff.(osw).bgColor);
end

abortTrial = 0;
trajectory = nan(20000, max(structfun(@(x) x, e.s.trajCols)));



%%%% Draw to offscreen windows

% Modify this file to draw whatever stimuli you need to winsOff.stims.h
drawStimuli; 

% Draw fixation cross to winsOff.fix.h
drawFixation; 




% -------------------------------------------------------------------------
% PRESENTATION STARTS HERE
% -------------------------------------------------------------------------




%%%% Wait for pts. to assume starting position

% Go on when they have kept starting pos for e.s.durOnStart
% If not in start pos within e.s.durWaitForStart, abort trial (code 1).

% Copy start marker offscreen window to onscreen window & present
Screen('CopyWindow', winsOff.empty.h, winOn.h);
Screen('Flip', winOn.h, []);

tOnStart = 0;
deltatOnStart = 0;
startScreenOnset = GetSecs;
while deltatOnStart <= e.s.durOnStart
    
    % get position of pointer tip (in pres area frame)
    [tipPos_pa, ~, ~, vzData] = getTip_pa(e.s);
    
    % determine distance to starting position
    distFromStart = dist3d(tipPos_pa, e.s.startPos_mm);
    
    % Check whether it is within starting region
    if distFromStart < e.s.startRadius_mm
        tipAtStart = 1;
    else
        tipAtStart = 0;
    end
    
    % Check whether pointer markers are within prescribed starting angle
    M = filterTrackerData(vzData, e.s.markers.pointer_IDs, true); % pos
    V = M - repmat(tipPos_pa, 3, 1);       % vectors from tip to markers
    A = zAngle(V);                         % angles from z-axis
    if ~any(A > e.s.pointerStartAngle)     % check deviation
        withinAngle = 1;
    else
        withinAngle = 0;
    end
    
    % what happens next depends on how long pointer has been on/off marker:
    % (1) if pts in starting position
    %   (A) and was not during last iteration     -> start timer
    %   (B) and already was during last iteration -> increment timer
    % (2) if pts not in starting position
    %   (A) but was in last iteration             -> reset counter to zero
    %   (B) and never was and max wait time up    -> abort trial
    if withinAngle && tipAtStart                                      % (1)
        if deltatOnStart == 0                                         % (A)
            tOnStart = GetSecs;
        end
        deltatOnStart = GetSecs - tOnStart;                           % (B)
    elseif ~(withinAngle && tipAtStart)                               % (2)
        if  deltatOnStart ~= 0  &&  deltatOnStart < e.s.durOnStart    % (A)
            deltatOnStart = 0;
        elseif GetSecs - startScreenOnset > e.s.durWaitForStart       % (B)
            abortTrial = 1;
            break;
        end
    end
    
    % Draw indicators to show in which direction the pointer has to be
    % moved to arrive at the starting position (circle for distance, arrows
    % for pointer inclination)
    drawStartPosIndicators;
    
    Screen('Flip',winOn.h,[]);
    
end



%%%% Show fixation cross

% for e.s.durPreStimFixation seconds.
% If during that time pts moves off start marker, abort trial (code 2).

tFixOnset_pc = nan;

if ~abortTrial
    
    % copy fix window to onscreen window
    Screen('CopyWindow', winsOff.fix.h, winOn.h);
    [~, tFixOnset_pc, ~, ~] = Screen('Flip',winOn.h,[]);
    
    deltatFix = GetSecs - tFixOnset_pc;
    
    while deltatFix <= e.s.durPreStimFixation
        
        % get position of pointer tip
        tipPos_pa = getTip_pa(e.s);
        
        % Check whether tip position is in correct location and pointer is
        % angled correctly. This is indicated by variables tipAtStart and
        % withinAngle, respectively.
        checkStartingPosition;
        
        % if start pos left, abort trial
        if ~withinAngle || ~tipAtStart
            abortTrial = 2;
            break;
        end
        
        % Increment timer
        deltatFix = GetSecs - tFixOnset_pc;
        
    end
    
end



%%%% Present stimuli

% If participant moves off starting position, abort trial (code 3).

tStimOnset_pc = nan;

if ~abortTrial
    
    % Copy offscreen window with stims and start marker to onscreen window
    Screen('CopyWindow', winsOff.stims.h, winOn.h);
    
    % present items
    [~,tStimOnset_pc,~,~] = Screen('Flip', winOn.h, []);
    
    % present items for fixed time
    deltatItems = GetSecs - tStimOnset_pc;
    while deltatItems <= e.s.durItemPresentation
        
        % Check whether tip position is in correct location and pointer is
        % angled correctly. This is indicated by variables tipAtStart and
        % withinAngle, respectively.
        checkStartingPosition;
        
        % if start pos left, abort trial
        if ~withinAngle || ~tipAtStart
            abortTrial = 3;
            break;
        end
        
        % Increment timer
        deltatItems = GetSecs - tStimOnset_pc;
        
    end
    
end



%%%% Location response

% wait for pointer to be close to screen surface.
% If allowed response time exceeded, abort trial (code 4).

tLocResponseOnset_pc = nan;
tLocResponseOnset_tr = nan;
tLocResponseOffset_pc = nan;
tLocResponseOffset_tr = nan;

if ~abortTrial
    
    % clear onscreen window and get location response onset time
    [~,tLocResponseOnset_pc,~,~] = Screen('Flip', winOn.h, []);
    
    % wait for response (pointer at screen surface)
    loopCounter = 1;
    while 1
        
        % get position of pointer and time
        [tipPos_pa, trackerTime, ~, ~] = getTip_pa(e.s);
        pcTime = GetSecs;
        
        % store onset time from trackers
        if loopCounter == 1
            tLocResponseOnset_tr = trackerTime;
        end
        
        % if max time is up, leave loop and abort trial
        if pcTime - tLocResponseOnset_pc > e.s.allowedLocResponseTime
            tLocResponseOffset_tr = trackerTime;
            abortTrial = 4;
            break;
        end
        
        % record pointer position
        trajectory(loopCounter, ...
            [e.s.trajCols.x, ...
            e.s.trajCols.y, ...
            e.s.trajCols.z, ...
            e.s.trajCols.t]) = [tipPos_pa, pcTime];
        
        % store time and proceed if pointer at screen surface (z = 0)?
        if abs(tipPos_pa(3)) < e.s.zZeroTolerance
            tLocResponseOffset_pc = pcTime;
            tLocResponseOffset_tr = trackerTime;
            break;
        end
        
    end
    
end



%%%% Target presence keyboard response

% wait for yes/no button to be pressed.
% if allowed response time exceeded, abort trial (code 5)

tgtPresentResponse = nan;
tTgtPresentResponseOnset_pc = nan;
tgtPresentResponseRT = nan;

if ~abortTrial        
    
    % copy response window to onscreen window and show
    Screen('CopyWindow', winsOff.targetResponse.h, winOn.h);
    [~, tTgtPresentResponseOnset_pc, ~, ~] = Screen('Flip',winOn.h,[]);
    
    while 1
        
        % if max time is up, leave loop and abort trial
        if pcTime - tTgtPresentResponseOnset_pc > e.s.allowedTgtResponseTime
            abortTrial = 5;
            break;
        end
        
        % Check keyboard
        [keyIsDown, secs, keyCode, ~] = KbCheck;
        
        % Store response
        if keyIsDown
            
            if strcmp(KbName(keyCode), e.s.yesKeyName)
                tgtPresentResponse = 1;
            elseif strcmp(KbName(keyCode), e.s.noKeyName)
                tgtPresentResponse = 0;
            end
            
            % store RT and proceed
            if ~isnan(tgtPresentResponse)
                tgtPresentResponseRT = secs - tTgtPresentResponseOnset_pc;
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




%%%% Determine correctness and type of target presence response

responseCorrect = nan;
responseType = nan;

if ~abortTrial

    ttype = trials(curTrial, triallistCols.trialType);
    
    if ttype == 1                       % tgt present trial         
        
        if tgtPresentResponse == 1          % hit (1)            
            responseCorrect = 1;
            responseType = 1;             
        elseif tgtPresentResponse == 0      % miss (2)         
            responseCorrect = 0;
            responseType = 2;             
        end
        
    elseif ttype == 2                   % both present trial
        
        if tgtPresentResponse == 1          % illusory conjunction (3)
            responseCorrect = 0;   
            responseType = 3;             
        elseif tgtPresentResponse == 0      % correct rejection BP (4)             
            responseCorrect = 1;
            responseType = 4;             
        end        
    
    elseif ttype == 3                   % color only trial       
        
        if tgtPresentResponse == 1          % feature error (5)            
            responseCorrect = 0;   
            responseType = 5;             
        elseif tgtPresentResponse == 0      % correct rejection CO (6)            
            responseCorrect = 1;
            responseType = 6;             
        end    
                
    end
    
end



%%%% Feedback

if abortTrial == 0
    
    dur = e.s.feedback.dur_nonAbort;
    
    if responseCorrect == 1
        feedbackStr = e.s.feedback.correct;
    elseif responseCorrect == 0
        feedbackStr = e.s.feedback.incorrect;
    end        
    
elseif abortTrial ~= 0

    dur = e.s.feedback.dur_abort;
    
    if abortTrial == 1        
        feedbackStr = e.s.feedback.notMovedToStart;       
    elseif abortTrial == 2        
        feedbackStr = e.s.feedback.leftStartInFix;        
    elseif abortTrial == 3        
        feedbackStr = e.s.feedback.leftStartInStim;        
    elseif abortTrial == 4        
        feedbackStr = e.s.feedback.exceededLocRT;        
    elseif abortTrial == 5        
        feedbackStr = e.s.feedback.exceededTgtRT;
                
    end
    
end

ShowTextAndWait(feedbackStr, e.s.feedbackColor, winOn.h, dur, false)



%%%% Store results 

% prepare new results row and populate

newResRow = [];

% create unique ID for current response
reponseID = round(rand()* 1e+12);
while any(e.results(:, e.s.resCols.responseID) == responseID)
    reponseID = round(rand()* 1e+12);
end

% populate with result values
newResRow(e.s.resCols.sequNum) = sequNum;
newResRow(e.s.resCols.responseID) = reponseID;
newResRow(e.s.resCols.abortCode) = abortCode;
newResRow(e.s.resCols.responseCorrect) = responseCorrect;
newResRow(e.s.resCols.responseType) = responseType;
newResRow(e.s.resCols.tgtPresentResponse) = tgtPresentResponse;
newResRow(e.s.resCols.tgtPresentResponseRT) = tgtPresentResponseRT;
newResRow(e.s.resCols.tFixOnset_pc) = tFixOnset_pc;
newResRow(e.s.resCols.tStimOnset_pc) = tStimOnset_pc;
newResRow(e.s.resCols.tLocResponseOnset_pc) = tLocResponseOnset_pc;
newResRow(e.s.resCols.tLocResponseOffset_pc) = tLocResponseOffset_pc;
newResRow(e.s.resCols.tLocResponseOnset_tr) = tLocResponseOnset_tr;
newResRow(e.s.resCols.tLocResponseOffset_tr) = tLocResponseOffset_tr;
newResRow(e.s.resCols.tTgtPresentResponseOnset_pc) = tTgtPresentResponseOnset_pc;

% append trial data 
newResRow = [newResRow, trials(curTrial, :)];

% store in results matrix
e.results(end+1, :) = newResRow;



%%%% Store trajectory 

% note that for aborted trials, this will results in an empty matrix

% remove unfilled rows
trajectory(all(isnan(trajectory)'), :) = [];

% of any directly successive rows in trajectory that have identical
% position data, remove all but the first ones (if desired).
if e.s.dontRecordConstantTrajData    
    rem = trajectory(:, [e.s.trajCols.x, e.s.trajCols.y, e.s.trajCols.z]);
    rem = [ones(1, size(rem,2)); diff(rem,1,1)];
    rem = all(rem' == 0);
    trajectory(rem, :) = [];       
end

% store in trajectory array
e.trajectories{end+1} = trajectory;



%%%% save to file (append)

if doSave
    save(savePath, 'e', '-append');
end



%%%% Shuffle aborted trial into remaining triallist

if abortTrial
    
    if curTrial ~= size(trials,1)
        
        % Do reordering on vector of row indices
        rowInds = 1:size(trials,1);
        newPos = randi([curTrial, numel(rowInds)]);
        abortedRow = rowInds(curTrial);
        rowInds(curTrial) = [];
        upper = rowInds(1:newPos-1);
        lower = rowInds(newPos:end);
        rowInds = [upper, abortedRow, lower];
        
        % Apply to trials
        trials = trials(rowInds, :);
        
    end
    
    curTrial = curTrial - 1; % will be incremented again at trial outset.
    
end
