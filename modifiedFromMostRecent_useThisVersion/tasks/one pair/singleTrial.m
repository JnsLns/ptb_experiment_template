%%%% Pause execution if desired

% Check whether pause key is being pressed, if so, halt execution and
% close PTB windows. Reopen if resumed.
pauseAndResume;



%%%% Initialize things

% Clear offscreen windows
for osw = fieldnames(winsOff)'
    Screen('FillRect', winsOff.(osw), winsOff.(osw).bgColor);
end

abortTrial = nan;
trajectory = zeros(20000,3);



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
% If not in start pos within e.s.durWaitForStart, abort trial (code 2).

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
    if withinAngle && tipAtStart
        if deltatOnStart == 0                                         % (A)
            tOnStart = GetSecs;
        end
        deltatOnStart = GetSecs - tOnStart;                           % (B)
    elseif ~(withinAngle && tipAtStart)                                % (2)
        if  deltatOnStart ~= 0  &&  deltatOnStart < e.s.durOnStart    % (A)
            deltatOnStart = 0;
        elseif GetSecs - startScreenOnset > e.s.durWaitForStart       % (B)
            abortTrial = 2;
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
% If during that time pts moves off start marker, abort trial (code 5).

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
            abortTrial = 5;
            break;
        end
        
        % Increment timer
        deltatFix = GetSecs - tFixOnset_pc;
        
    end
    
end



%%%% Present stimuli

% If participant moves off start position, abort trial (code 3).

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

% If allowed response time exceeded, abort trial (code 3).

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
            abortTrial = 3;
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
            tMovementOffset_pc = pcTime;
            tMovementOffset_tr = trackerTime;
            break;
        end
        
    end
    
end



%%%% Target presence keyboard response

if ~abortTrial
    
    targetPresentResponse = nan;
    
    % copy response window to onscreen window and show
    Screen('CopyWindow', winsOff.targetResponse.h, winOn.h);
    [~, tTgtResponseOnset_pc, ~, ~] = Screen('Flip',winOn.h,[]);
    
    while 1
        
        % if max time is up, leave loop and abort trial
        if pcTime - tTgtResponseOnset_pc > e.s.allowedTgtResponseTime
            abortTrial = 3;
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
                tgtPresentResponse_RT = secs - tTgtResponseOnset_pc;
                break;
            end
            
        end
        
    end
    
end




% -------------------------------------------------------------------------
% PRESENTATION ENDS HERE (except for possible feedback)
% -------------------------------------------------------------------------




%%%% Trial aftermath (feedback, correctness etc.)

% retest for trial abortion, since it may have happened during
% stimulus display through exceeding max display time
if ~abortTrial
    
    Screen('Flip', winOn.h, []); % flip from backbuffer to onscreen window (backbuffer is cleared)
    
    % Determine correctness of response
    if % TODO: Correctness criterion here...
        correctResponse = 1;
    elseif ~isempty(chosenItem) % incorrect response
        correctResponse = 0;
    end
    
end

if ~abortTrial
    
    %%%% store results
    
    % NOTE: Any position data in 'results' and 'trajectories' should first
    % be converted to the presentation-area-based coordinate frame (in
    % millimeters), Use ptbPxToPaMm() for this.
    
    e.results(curTrial,e.s.resCols.correct) = correctResponse; % if response correct 1, else 0
    e.results(curTrial,e.s.resCols.chosen) = chosenItem; % item chosen by participant
    e.results(curTrial,e.s.resCols.type) = e.trials(curTrial,tg.triallistCols.type); % trialtype
    e.results(curTrial,e.s.resCols.stimOnset_pc) = tStimOnset_pc; % onset of stimulus display, pc time
    e.results(curTrial,e.s.resCols.moveOnset_pc) = movementOnset_pc; % start time of movement, pc time
    e.results(curTrial,e.s.resCols.moveOffset_pc) = movementOffset_pc; % end time of movement, pc time
    e.results(curTrial,e.s.resCols.reactionTime_pc) = movementOnset_pc - phraseOffset_pc;
    e.results(curTrial,e.s.resCols.movementTime_pc) = movementOffset_pc - movementOnset_pc;
    e.results(curTrial,e.s.resCols.responseTime_pc) = movementOffset_pc - phraseOffset_pc;
    
    e.results(curTrial,e.s.resCols.horzPosStart:e.s.resCols.horzPosEnd) = (stimuliCenters_px(:,1)' - presMargins_px(1))/e.s.pxPerMm(1);
    e.results(curTrial,e.s.resCols.vertPosStart:e.s.resCols.vertPosEnd) = (presArea_px(2)-(stimuliCenters_px(:,2)' - presMargins_px(2)))/e.s.pxPerMm(2);
    e.results(curTrial,e.s.resCols.itemRadiiStart:e.s.resCols.itemRadiiEnd) = stimuliCenters_px(:,3)'/mean(e.s.pxPerMm);
    e.results(curTrial,e.s.resCols.startPosX) = (e.s.startPos_mm(1)-presMargins_px(1))/e.s.pxPerMm(1);
    e.results(curTrial,e.s.resCols.startPosY) = (presArea_px(2)-(e.s.startPos_mm(2)-presMargins_px(2)))/e.s.pxPerMm(2);
    
    % copy relevant parameters of current trial to results matrix
    e.results(curTrial,e.s.resCols.trialID)  = e.trials(curTrial,tg.triallistCols.trialID);
    e.results(curTrial,e.s.resCols.tgt) = e.trials(curTrial,tg.triallistCols.tgt);
    e.results(curTrial,e.s.resCols.ref) = e.trials(curTrial,tg.triallistCols.ref);
    e.results(curTrial,e.s.resCols.spt) = e.trials(curTrial,tg.triallistCols.spt);
    e.results(curTrial,e.s.resCols.colorsStart:e.s.resCols.colorsEnd) = e.trials(curTrial,tg.triallistCols.colorsStart:tg.triallistCols.colorsEnd);
    e.results(curTrial,e.s.resCols.wordOrder) = e.trials(curTrial,tg.triallistCols.wordOrder);
    e.results(curTrial,e.s.resCols.dtr) = e.trials(curTrial,tg.triallistCols.dtr);
    e.results(curTrial,e.s.resCols.tgtSlot) = e.trials(curTrial,tg.triallistCols.tgtSlot); % tgtSlot code (1=top right, 2=top left, 3=bottom right, 4=bottom left )
    e.results(curTrial,e.s.resCols.nTgts) = e.trials(curTrial,tg.triallistCols.nTgts); % Number of target items (items in target color)
    e.results(curTrial,e.s.resCols.nItems) = e.trials(curTrial,tg.triallistCols.nItems); % Total number of items
    e.results(curTrial,e.s.resCols.fitsStart:e.s.resCols.fitsEnd) = e.trials(curTrial,tg.triallistCols.fitsStart:tg.triallistCols.fitsEnd);
    
    
    
    
    %%%% trim and store trajectory
    
    % remove unfilled rows
    trajectory(loopsSinceStimOffset+1:end,:) = [];
    
    % remove rows with duplicate (2d) mouse positions (due to
    % for-loop rate being higher than mouse polling); never re-
    % move rows with movement onset time and movement offset time.
    % (Note that this also removes data points where mouse was
    % not moved relative to the preceding data point)
    if e.s.dontRecordConstantTrajData
        m = 2;
        while m < size(trajectory,1)
            if all(trajectory(m,[e.s.trajCols.x,e.s.trajCols.y]) == trajectory(m-1,[e.s.trajCols.x,e.s.trajCols.y])) && ...
                    trajectory(m,e.s.trajCols.t) ~= movementOnset_pc && ...
                    trajectory(m,e.s.trajCols.t) ~= movementOffset_pc
                trajectory(m,:) = [];
            else
                m = m+1;
            end
        end
    end
    
    % convert to millimeter data and flip y-axis to get from PTB's
    % to a "normal" coordinate frame (also make relative to presentation area)
    trajectory(:,e.s.trajCols.x) = (trajectory(:,e.s.trajCols.x)-presMargins_px(1))/e.s.pxPerMm(1);
    trajectory(:,e.s.trajCols.y) = (presArea_px(2)-(trajectory(:,e.s.trajCols.y)-presMargins_px(2)))/e.s.pxPerMm(2);
    
    % store in cell
    e.trajectories{curTrial} = trajectory;
    
    % save everything to file (append)
    if doSave
        save(savePath, 'e', '-append');
    end
    
end






%%%% Feedback
% TODO: Move this above result saving

if ~abortTrial
    
    % provide feedback
    if tooSlow % e.s.maxRT exceeded (supersedes other feedback)
        feedbackStr = e.s.tooSlowString;
    elseif correctResponse
        feedbackStr = e.s.correctString;
    elseif ~correctResponse
        feedbackStr = e.s.incorrectString;
    end
    
    durFeedback = e.s.Feedback_nonAbort;
    
    % Play sound as feedback for target-present response
    %Beeper(600, 0.25, 0.075); % correct
    %Beeper(100, 0.25, 0.075); % incorrect
    
end

if abortTrial
    
    if  abortTrial == 1 % did not start moving after maxSecsToMove seconds following phrase onset
        feedbackStr = e.s.noMoveString;
    elseif abortTrial == 2 % did not move pointer on start marker
        feedbackStr = e.s.noResponseString;
    elseif abortTrial == 3 % did not choose a stimulus
        feedbackStr = e.s.noResponseString;
    elseif abortTrial == 5 % left start marker before spatial phrase was removed
        feedbackStr = e.s.earlyMoveString;
    end
    
    durFeedback = e.s.Feedback_abort;
    
end

ShowTextAndWait(feedbackStr, e.s.feedbackColor, winOn.h, durFeedback, false)



%%%% Shuffle aborted trial into remaining triallist

if abortTrial
    
    if curTrial ~= size(e.trials,1)
        
        % Do reordering on vector of row indices
        rowInds = 1:size(e.trials,1);
        newPos = randi([curTrial, numel(rowInds)]);
        abortedRow = rowInds(curTrial);
        rowInds(curTrial) = [];
        upper = rowInds(1:newPos-1);
        lower = rowInds(newPos:end);
        rowInds = [upper, abortedRow, lower];
        
        % Apply to e.trials
        e.trials = e.trials(rowInds, :);
        
    end
    
    curTrial = curTrial - 1; % will be incremented again at trial outset.
    
end
