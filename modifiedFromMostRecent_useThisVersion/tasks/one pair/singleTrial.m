%%%% Pause execution if desired

% Check whether pause key is being pressed, if so, halt execution and
% close PTB windows. Reopen if resumed.
pauseAndResume;



%%%%  Re-initialize variables

% TODO: Removed unused after adjusting rest of code

% initialize/reset variables
startMarkerOnset = [];
tOnStart = [];
deltatOnStart = 0;
phraseVisible = 0;
pointerOnStart = 0;
abortTrial = 0;
arrayOnset = 0;
movementOnset_pc = [];
movementOffset_pc = [];
noResponse = 1;
trajectory = zeros(20000,3);
loopsSincePhraseOffset = 0;
currentTgtNum = [];
currentRefNum = [];
tgtString = [];
refString = [];
sptString = [];
chosenItem = [];
passedOtherItems = 0;
tooSlow = 0;
tipPos = [0,0,0];
pcTime = [];
correctResponse = [];
t_min1 = [];
tipPos_old = [];
tipPos_new = [];
t_current = [];
deltaTipPos_mm = [];
currentVelocity = [];
phraseOnset_pc = [];
phraseOffset_pc = [];
clickTime_pc = [];
stimuliCenters_px = [];
stimuli_rgb = [];


% Clear offscreen windows
for osw = fieldnames(winsOff)'
    Screen('FillRect', winsOff.(osw), winsOff.(osw).bgColor);
end


%%%% Draw to offscreen windows)

% Modify this file to draw whatever stimuli you need to winsOff.stims.h
drawStimuli; % TODO

% Draw fixation cross to winsOff.fix.h
drawFixation; % TODO



% -------------------------------------------------------------------------
% PRESENTATION STARTS HERE
% -------------------------------------------------------------------------




%%%% Wait for pts. to move to starting position

% Wait for pointer to be in desired position (tip in x/y screen center, at
% some fixed z position and marker on pointer are at some larger z)

% Go on when pointer has dwelled there for e.s.durOnStart.

% If pointer not in position within e.s.durWaitForStart abort trial (code 2).

% Draw dot to mark x/y position; draw circle whose radius is equal to
% z - z_start. Draw target pos in x/y. Some signal when pointer is in
% position.



% Copy start marker offscreen window to onscreen window
Screen('CopyWindow', winsOff.empty.h, winOn.h);
% Present start marker
Screen('Flip', winOn.h, []); % flip (backbuffer cleared)

startMarkerOnset = GetSecs;
while deltatOnStart <= e.s.durOnStart
    
    

    
    
    % get position of pointer tip
    tipPos = transformedTipPosition(cfids, pids, cfs, vth, mps, eds, dth);
        
    if dist3d(tipPos,[start_pos_px, 0],[0 0 1]) < start_r_px
        pointerOnStart = 1;
    else
        pointerOnStart = 0;
    end
    
    % what happens next depends on how long pointer has been on/off marker:
    % if pointer is on start marker ...
    if pointerOnStart
        % ...and was not during last iteration -> start timer
        if deltatOnStart == 0
            tOnStart = GetSecs;
        end
        % ...and already was during last iteration -> increment timer
        deltatOnStart = GetSecs - tOnStart;
        % if pointer is not on start marker...
    elseif ~pointerOnStart
        % ...but was in last iteration -> reset counter to zero
        if  deltatOnStart ~= 0  &&  deltatOnStart < e.s.durOnStart
            deltatOnStart = 0;
            % ... and never was and max wait time is up -> leave while and abort trial
        elseif GetSecs - startMarkerOnset > e.s.durWaitForStart
            if blockType ~= 0 % not during practice
                abortTrial = 2;
                break;
            end
        end
    end
    
    % Refresh display and draw pointer
    if deltatOnStart ~= 0
        Screen('CopyWindow', offwin_smOn_noStims, winOn.h);
    else
        Screen('CopyWindow', winsOff.empty.h, winOn.h);
    end
    Screen('DrawDots', winOn.h, tipPos(1:2), cursorRad_px*2, tg.white, [], 1);
    Screen('Flip',winOn.h,[]);
    
end


%% Show phrase
% show phrase for durPhrase seconds. If during that time pts
% moves off start marker, abort trial (code 5). Else, end loop and go to next.

if ~abortTrial
    
    % draw spatial Phrase & cursor to onscreen
    Screen('CopyWindow', offwin_smOn_noStims, winOn.h);
    DrawFormattedText(winOn.h, phraseString, phraseRect(1), phraseRect(2), tg.phraseColor);
    Screen('DrawDots', winOn.h, tipPos(1:2), cursorRad_px*2, tg.white, [], 1);
    [~, phraseOnset_pc]  = Screen('Flip',winOn.h,[]);
    
    deltatPhrase = GetSecs - phraseOnset_pc;
    
    while deltatPhrase <= durPhrase
        
        % get position of pointer and check whether it is within start marker
        [tipPos(1),tipPos(2)] = getMouseRemapped2(e.s.mouseRemappingFactor);
        if ~(dist3d(tipPos,[start_pos_px, 0],[0 0 1]) < start_r_px)
            abortTrial = 5;
            break; % leave loop and abort trial
        end
        
        % Refresh display and draw pointer
        Screen('CopyWindow', offwin_smOn_noStims, winOn.h);
        DrawFormattedText(winOn.h, phraseString, phraseRect(1), phraseRect(2), tg.phraseColor);
        Screen('DrawDots', winOn.h, tipPos(1:2), cursorRad_px*2, tg.white, [], 1);
        Screen('Flip',winOn.h,[]);
        
        % Increment timer
        deltatPhrase = GetSecs - phraseOnset_pc;
        
    end
    
end


% Play sound as start signal
%Beeper(600, 0.25, 0.075); % correct
%Beeper(100, 0.25, 0.075); % incorrect



%% Wait for movement onset
% Wait until participant moves the pointer with at least e.s.velocityThreshold mm/s.
% If that does not happen within e.s.maxSecsUntilMove, abort trial (code 1).
% Note: Mouse position is recorded here already to have a data margin
% preceeding movement onset.

if ~abortTrial
    
    % draw start marker and cursor to onscreen window
    Screen('CopyWindow', offwin_smOn_noStims, winOn.h);
    Screen('DrawDots', winOn.h, tipPos(1:2), cursorRad_px*2, tg.white, [], 1);
    [~, phraseOffset_pc]  = Screen('Flip',winOn.h,[]);
    
    % get reference position & time for detecting movement onset
    t_min1 = GetSecs;
    [tipPos_old(1),tipPos_old(2)] = getMouseRemapped2(e.s.mouseRemappingFactor);
    
    % wait for movement onset
    while 1
        
        t_current = GetSecs;
        [tipPos_new(1),tipPos_new(2)] = getMouseRemapped2(e.s.mouseRemappingFactor);
        
        % start recording mouse position and counting loops
        loopsSincePhraseOffset = loopsSincePhraseOffset + 1;
        trajectory(loopsSincePhraseOffset,[e.s.trajCols.x,e.s.trajCols.y,e.s.trajCols.t]) = ...
            [tipPos_new(1:2), t_current];
        
        % check speed against threshold in regular intervals
        if t_current - t_min1 >= e.s.velocitySamplingInterval
            
            % Compute pointer speed
            deltaTipPos_mm = (tipPos_new - tipPos_old)./e.s.pxPerMm;
            currentVelocity = sqrt(sum(deltaTipPos_mm.^2)) / (t_current - t_min1);
            
            % if thresh exceeded, store movement onset time and leave loop
            if currentVelocity > e.s.velocityThreshold
                movementOnset_pc = t_current;
                break
                % if time is up, abort trial
            elseif t_current - phraseOffset_pc > e.s.maxSecsUntilMove
                if blockType ~= 0 % not during practice
                    abortTrial = 1;
                    break
                end
            end
            
            % reset time and store new reference position
            [tipPos_old(1),tipPos_old(2)] = getMouseRemapped2(e.s.mouseRemappingFactor);
            t_min1 = GetSecs;
            
        end
        
        % Refresh display and draw pointer
        if dist3d([tipPos_new, 0],[start_pos_px, 0],[0 0 1]) < start_r_px
            Screen('CopyWindow', offwin_smOn_noStims, winOn.h);
        else
            Screen('CopyWindow', winsOff.empty.h, winOn.h);
        end
        Screen('DrawDots', winOn.h, tipPos_new(1:2), cursorRad_px*2, tg.white, [], 1);
        Screen('Flip',winOn.h,[]);
        
    end
    
end

%% Present items

if ~abortTrial
    
    %% Present stimulus array
    % if max time is up, leave loop and abort trial (code 3)
    
    % Copy offscreen window with stims and start marker to onscreen window
    Screen('CopyWindow', offwin_smOff_stims, winOn.h);
    
    % present items (note: do wait for flip here, to make sure next data
    % point is recorded only when stims are present)
    [~,arrayOnset,~,~] = Screen('Flip', winOn.h, []);
    
    % this checks whether cursor is within item border
    pointerWithinStim = zeros(size(stimuliCenters_px,1),1);
    
    % wait until an item is clicked
    while 1
        
        % Get pointer position & time
        [tipPos(1),tipPos(2)] = getMouseRemapped2(e.s.mouseRemappingFactor);
        pcTime = GetSecs;
        
        % if max time is up, leave loop and abort trial
        if pcTime - arrayOnset > e.s.durWaitForReaction
            if blockType ~= 0 % not during practice
                abortTrial = 3;
                break;
            end
        end
        
        % record pointer position each iteration --> trajectory
        loopsSincePhraseOffset = loopsSincePhraseOffset + 1;
        trajectory(loopsSincePhraseOffset,[e.s.trajCols.x,e.s.trajCols.y,e.s.trajCols.t]) = ...
            [tipPos(1:2), pcTime];
        
        % check whether cursor is inside any stimulus borders
        pointerWithinStim = dist3d(tipPos,[stimuliCenters_px(:,1:2), zeros(size(stimuliCenters_px,1),1)],[0 0 1]) < stimuliCenters_px(:,3);
        
        % if pointer is on an item and hasn't been on one before
        % record movement offset time
        if  isempty(movementOffset_pc) && any(pointerWithinStim)
            movementOffset_pc = pcTime;
            % if pointer not on any stimulus but has been last iteration
            % re-empty movement offset time;
            % take note that mouse passed over an ultimately unselected item
        elseif ~isempty(movementOffset_pc) && ~any(pointerWithinStim)
            movementOffset_pc = [];
            passedOtherItems = 1;
        end
        
        % Detect click, store chosen item, leave loop.
        [~,~,mouseButtons] = GetMouse;
        if ~isempty(movementOffset_pc) && any(mouseButtons)
            clickTime_pc = pcTime;
            chosenItem = find(pointerWithinStim);
            break;
        end
        
        % Refresh display and draw mouse pointer
        % Copy stim offscreen window to onscreen window
        Screen('CopyWindow', offwin_smOff_stims, winOn.h);
        % draw mouse position
        Screen('DrawDots', winOn.h, tipPos(1:2), cursorRad_px*2, tg.white, [], 1);
        % order flip at next possible time, but do not wait for
        % flip before proceeding, to avoid limiting mouse capture
        % by screen refresh rate.
        Screen('Flip',winOn.h,[],[],2);
        
    end
    
end


%% Trial aftermath (feedback, correctness etc.)


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
    e.results(curTrial,e.s.resCols.type) = trials(curTrial,tg.triallistCols.type); % trialtype    
    e.results(curTrial,e.s.resCols.stimOnset_pc) = arrayOnset; % onset of stimulus display, pc time
    e.results(curTrial,e.s.resCols.moveOnset_pc) = movementOnset_pc; % start time of movement, pc time
    e.results(curTrial,e.s.resCols.moveOffset_pc) = movementOffset_pc; % end time of movement, pc time
    e.results(curTrial,e.s.resCols.reactionTime_pc) = movementOnset_pc - phraseOffset_pc;
    e.results(curTrial,e.s.resCols.movementTime_pc) = movementOffset_pc - movementOnset_pc;
    e.results(curTrial,e.s.resCols.responseTime_pc) = movementOffset_pc - phraseOffset_pc;        
    
    e.results(curTrial,e.s.resCols.horzPosStart:e.s.resCols.horzPosEnd) = (stimuliCenters_px(:,1)' - presMargins_px(1))/e.s.pxPerMm(1);
    e.results(curTrial,e.s.resCols.vertPosStart:e.s.resCols.vertPosEnd) = (presArea_px(2)-(stimuliCenters_px(:,2)' - presMargins_px(2)))/e.s.pxPerMm(2);
    e.results(curTrial,e.s.resCols.itemRadiiStart:e.s.resCols.itemRadiiEnd) = stimuliCenters_px(:,3)'/mean(e.s.pxPerMm);
    e.results(curTrial,e.s.resCols.startPosX) = (start_pos_px(1)-presMargins_px(1))/e.s.pxPerMm(1);
    e.results(curTrial,e.s.resCols.startPosY) = (presArea_px(2)-(start_pos_px(2)-presMargins_px(2)))/e.s.pxPerMm(2);
    
    % copy relevant parameters of current trial to results matrix
    e.results(curTrial,e.s.resCols.trialID)  = trials(curTrial,tg.triallistCols.trialID);
    e.results(curTrial,e.s.resCols.tgt) = trials(curTrial,tg.triallistCols.tgt);
    e.results(curTrial,e.s.resCols.ref) = trials(curTrial,tg.triallistCols.ref);
    e.results(curTrial,e.s.resCols.spt) = trials(curTrial,tg.triallistCols.spt);
    e.results(curTrial,e.s.resCols.colorsStart:e.s.resCols.colorsEnd) = trials(curTrial,tg.triallistCols.colorsStart:tg.triallistCols.colorsEnd);
    e.results(curTrial,e.s.resCols.wordOrder) = trials(curTrial,tg.triallistCols.wordOrder);
    e.results(curTrial,e.s.resCols.dtr) = trials(curTrial,tg.triallistCols.dtr);
    e.results(curTrial,e.s.resCols.tgtSlot) = trials(curTrial,tg.triallistCols.tgtSlot); % tgtSlot code (1=top right, 2=top left, 3=bottom right, 4=bottom left )
    e.results(curTrial,e.s.resCols.nTgts) = trials(curTrial,tg.triallistCols.nTgts); % Number of target items (items in target color)
    e.results(curTrial,e.s.resCols.nItems) = trials(curTrial,tg.triallistCols.nItems); % Total number of items
    e.results(curTrial,e.s.resCols.fitsStart:e.s.resCols.fitsEnd) = trials(curTrial,tg.triallistCols.fitsStart:tg.triallistCols.fitsEnd);
    
    
    
    
    %%%% trim and store trajectory
    
    % remove unfilled rows
    trajectory(loopsSincePhraseOffset+1:end,:) = [];
    
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
    
    if curTrial ~= size(trials,1)
        
        % Do reordering on vector of row indices
        rowInds = 1:size(trials,1);        
        newPos = randi([curTrial, numel(rowInds)]);        
        abortedRow = rowInds(curTrial);        
        rowInds(curTrial) = [];                         
        upper = rowInds(1:newPos-1); 
        lower = rowInds(newPos:end); 
        rowInds = [upper, abortedRow, lower];
        
        % Apply to 'trials' and 'e.triallist' so both heed order of presentation        
        trials = trials(rowInds, :);
        e.triallist = e.triallist(rowInds, :);                
                
    end
        
    curTrial = curTrial - 1; % will be incremented again at trial outset.
    
end
