%%%% Pause execution

% Check whether pause key is being pressed, if so, halt execution and
% close PTB windows. Reopen if resumed.
pauseAndResume;




%%  trial initialization

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
durPhrase = e.s.durPhrase_base + e.s.durPhrase_rand * (rand*2-1); % determine random duration of phrase for this trial
stimuliCenters_px = [];
stimuli_rgb = [];


% Clear offscreen windows
for osw = fieldnames(winsOff)'        
    Screen('FillRect', winsOff.(osw), winsOff.(osw).bgColor);
end     


%%%% Draw to offscreen windows)

% Modify this file to draw whatever stimuli you need to winsOff.stims.h
drawStimuli;

% Draw fixation cross to winsOff.fix.h
drawFixation;


% -------------------------------------------------------------------------
% PRESENTATION STARTS HERE
% -------------------------------------------------------------------------




%% Wait for pts. to move pointer onto start marker
% Wait for pointer to be within the start marker (distance of pointer
% from center is checked). Go on when it has dwelled there for e.s.durOnStart.
% If pointer not on marker within e.s.durWaitForStart abort trial (code 2).

% Copy start marker offscreen window to onscreen window
 Screen('CopyWindow', winsOff.empty.h, winOn.h);
% Present start marker
Screen('Flip', winOn.h, []); % flip (backbuffer cleared)

startMarkerOnset = GetSecs;
while deltatOnStart <= e.s.durOnStart
    
    % get position of pointer tip and check whether pointer is within start marker
    [tipPos(1),tipPos(2)] = getMouseRemapped2(e.s.mouseRemappingFactor);
    curRemapFac = e.s.mouseRemappingFactor;
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
    
    %% Trial aftermath (feedback, correctness etc.)
    
    % If due to accidentally overlapping stimuli two items were
    % registered as selected by the participant, discard trial
    % data (normal abortion without feedback, trial will be redone later).
    if numel(chosenItem) > 1
        abortTrial = 4;
    end
    
    % retest for trial abortion, since it may have happened during
    % stimulus display through exceeding max display time
    if ~abortTrial
        
        % Check whether final movementOffset_pc-arrayOnset (timespan from
        % array presentation to crossing border of actually chosen item)is
        % shorter than e.s.maxRT. (otherwise response is marked as too slow and
        % appropriate feedback is presented later)
        if movementOffset_pc - arrayOnset > e.s.maxRT
            tooSlow = 1;
        end
        
        Screen('Flip', winOn.h, []); % flip from backbuffer to onscreen window (backbuffer is cleared)
        
        % Determine correctness of response        
        if (~isempty(chosenItem) && chosenItem == trials(curTrial,tg.triallistCols.tgt) && any(trials(curTrial,tg.triallistCols.type) == [1 3 4])) || ... % trialtypes 1 (standard relational), 3 (single-item), 4 (spatial cue)
                (~isempty(chosenItem) && chosenItem == numel(pointerWithinStim) && trials(curTrial,tg.triallistCols.type) == 2)                                 % trialtype 2 (spatial catch-trial, phrase and display incongruent)
            correctResponse = 1;
        elseif ~isempty(chosenItem) % incorrect response
            correctResponse = 0;
        end
        
        % provide feedback        
        if tooSlow && blockType ~= 0 % e.s.maxRT exceeded (overrides other feedback; not during practice)
            feedbackStr = 'Zu langsam!';
        elseif correctResponse
            feedbackStr = 'Richtig! Sehr gut!';
        elseif ~correctResponse
            feedbackStr = 'Falsch!';
        end
        
        % Show feedback and keep refreshing cursor
        fbStart = GetSecs();
        while GetSecs() - fbStart <= durFeedback
            DrawFormattedText(winOn.h, feedbackStr, 'center', array_pos_px(2), tg.phraseColor);
            [tipPos(1),tipPos(2)] = getMouseRemapped2(e.s.mouseRemappingFactor);
            Screen('DrawDots', winOn.h, tipPos(1:2), cursorRad_px*2, tg.white, [], 1);
            Screen('Flip', winOn.h, []);
        end
        
        %% store in results matrix
        
        % NOTE: When adding any position data to results or trajectories,
        % it should be converted to millimeters and be specified relative to
        % origin at bottom left of presentation area, with x-axis increasing
        % rightwards, y-axis increasing upwards (as this is expected in
        % analysis).
        
        e.results(curTrial,e.s.resCols.chosen) = chosenItem; % item chosen by participant
        e.results(curTrial,e.s.resCols.type) = trials(curTrial,tg.triallistCols.type); % trialtype
        e.results(curTrial,e.s.resCols.phraseOnset_pc) = phraseOnset_pc; % onset of spatial phrase, pc time
        e.results(curTrial,e.s.resCols.phraseOffset_pc) = phraseOffset_pc; % offset of spatial phrase, pc time
        e.results(curTrial,e.s.resCols.stimOnset_pc) = arrayOnset; % onset of stimulus display, pc time
        e.results(curTrial,e.s.resCols.moveOnset_pc) = movementOnset_pc; % start time of movement, pc time
        e.results(curTrial,e.s.resCols.moveOffset_pc) = movementOffset_pc; % end time of movement, pc time
        e.results(curTrial,e.s.resCols.reactionTime_pc) = movementOnset_pc - phraseOffset_pc;
        e.results(curTrial,e.s.resCols.movementTime_pc) = movementOffset_pc - movementOnset_pc;
        e.results(curTrial,e.s.resCols.responseTime_pc) = movementOffset_pc - phraseOffset_pc;
        e.results(curTrial,e.s.resCols.clickTime_pc) = clickTime_pc;
        e.results(curTrial,e.s.resCols.passed) = passedOtherItems; % if 1, pts. passed over a stimulus but did not stay on this item
        e.results(curTrial,e.s.resCols.correct) = correctResponse; % if response correct 1, else 0
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
        
        %% trim and store trajectory
        
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
        
    end % belongs to second (inner) if, checking for trial abortion
    
end % belongs to first (outer) if, checking for trial abortion

%% In case of trial being aborted: Feedback & trial reordering

% if the current trial was aborted, show appropriate feedback, move trial to end to be redone
if abortTrial
    
    if  abortTrial == 1 % did not start moving after maxSecsToMove seconds following phrase onset
        abortString = e.s.noMoveString;
    elseif abortTrial == 2 % did not move pointer on start marker
        abortString = e.s.noResponseString;
    elseif abortTrial == 3 % did not choose a stimulus
        abortString = e.s.noResponseString;
    elseif abortTrial == 5 % left start marker before spatial phrase was removed
        abortString = e.s.earlyMoveString;
    end
    
    % show feedback
    Screen('Flip',winOn.h,[]);
    [abortString_x, abortString_y] = centerTextOnPoint(abortString, winOn.h, array_pos_px(1), array_pos_px(2));
    DrawFormattedText(winOn.h, abortString, 'center', abortString_y, tg.textColor, [], [], [], 2);
    Screen('Flip',winOn.h,[]);
    WaitSecs(e.s.durAbortFeedback)
    
    % If it's not the last trial anyway, append current row to end
    % of matrix and delete current row (do the same thing for
    % non-pixel trial list, so that these trials are in the same
    % order as the results matrix
    if curTrial ~= size(trials,1)
        trials(end+1,:) = trials(curTrial,:);
        trials(curTrial,:) = [];
        if blockType == 1 % main trials
            e.trials_main(end+1,:) = e.trials_main(curTrial,:);
            e.trials_main(curTrial,:) = [];
        end
    end
    
    % Set back curTrial by 1 (so that the trial that is now in
    % the same row as the deleted one will be done next (since the
    % following line in parent script increments the counter as usual).
    curTrial = curTrial - 1;
    
end