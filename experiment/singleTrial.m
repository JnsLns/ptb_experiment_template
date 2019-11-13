
% This script presents a single trial including feedback and assigns values
% to struct 'out'


out.abortCode = 0;
out.sequNum = sequNum;



%%%% Draw to offscreen windows

% Modify this file to draw whatever stimuli you need to winsOff.stims.h
drawStimuli; 

% Draw fixation cross to winsOff.fix.h
drawFixation; 

% Draw start marker to winsOff.startMarker.h
 [sm_xy_ptb_px(1), sm_xy_ptb_px(2)] = ...
    paVaToPtbPx(e.s.startPos_va(1), e.s.startPos_va(2), e.s.spatialConfig);
Screen('DrawDots', winsOff.startMarker.h, sm_xy_ptb_px, ...
        vaToPx(e.s.startMarkerRad_va, e.s.spatialConfig)*2, ...
        e.s.startMarkerColor, [], 1);


    
    
% -------------------------------------------------------------------------
% PRESENTATION STARTS HERE
% -------------------------------------------------------------------------



%%%% Wait for pts. to assume starting position

% Go on when they have kept starting pos for e.s.durOnStart
% If not in start pos within e.s.durWaitForStart, abort trial (code 1).

% Copy start marker offscreen window to onscreen window & present
Screen('CopyWindow', winsOff.startMarker.h, winOn.h);
Screen('Flip', winOn.h, []);

tOnStart = 0;
deltatOnStart = 0;
startScreenOnset = GetSecs;
while deltatOnStart <= e.s.durOnStart        
    
    % get position of mouse pointer (in pres area frame, visual angle)
    [mouse_xy_pa_va, mouse_xy_ptb_px] = ...
        getMouseRemapped_pa_ptb(e.s.mouseMovementMultiplier, e.s.spatialConfig);                    
    
    % determine distance to starting position
    distFromStart_va = ...
        dist3d([mouse_xy_pa_va, 0], [e.s.startPos_va, 0], [0 0 1]);
    
    % Check whether it is within starting region
    if distFromStart_va < e.s.startRadius_va
        tipAtStart = 1;
    else
        tipAtStart = 0;
    end
    
    % what happens next depends on how long pointer has been on/off marker:
    % (1) if pts in starting position
    %   (A) and was not during last iteration     -> start timer
    %   (B) and already was during last iteration -> increment timer
    % (2) if pts not in starting position
    %   (A) but was in last iteration             -> reset counter to zero
    %   (B) and never was and max wait time up    -> abort trial
    if tipAtStart                                                     % (1)
        if deltatOnStart == 0                                         % (A)
            tOnStart = GetSecs;
        end
        deltatOnStart = GetSecs - tOnStart;                           % (B)
    elseif ~tipAtStart                                                % (2)
        if  deltatOnStart ~= 0  &&  deltatOnStart < e.s.durOnStart    % (A)
            deltatOnStart = 0;
        elseif GetSecs - startScreenOnset > e.s.durWaitForStart       % (B)
            out.abortCode = 1;
            break;
        end
    end       
    
    % Draw pointer / start marker
    Screen('CopyWindow', winsOff.startMarker.h, winOn.h);
    Screen('DrawDots', winOn.h, mouse_xy_ptb_px, ...
        vaToPx(e.s.cursorRad_va, e.s.spatialConfig)*2, e.s.cursorColor, [], 1);
    
    % Draw indicators to show in which direction the pointer has to be
    % moved to arrive at the starting position (circle for distance, arrows
    % for pointer inclination)
    drawStartPosIndicators;
    
    % Refresh
    Screen('Flip', winOn.h, []);    
    
end



%%%% Show fixation cross

% for e.s.durPreStimFixation seconds.
% If during that time pts moves off start marker, abort trial (code 2).

out.tFixOnset_pc = nan;

if ~out.abortCode
    
    % copy fix window to onscreen window
    Screen('CopyWindow', winsOff.fix.h, winOn.h);
    [~, out.tFixOnset_pc, ~, ~] = Screen('Flip',winOn.h,[]);
    
    deltatFix = GetSecs - out.tFixOnset_pc;
    
    while deltatFix <= e.s.durPreStimFixation
        
        % get position of mouse pointer (in pres area frame, visual angle)
        [mouse_xy_pa_va, mouse_xy_ptb_px] = ...
            getMouseRemapped_pa_ptb(e.s.mouseMovementMultiplier, e.s.spatialConfig);
        
        checkStartingPosition;
        
        % if start pos left, abort trial
        if ~tipAtStart
            out.abortCode = 2;
            break;
        end
        
        % Increment timer
        deltatFix = GetSecs - out.tFixOnset_pc;
        
        % Refresh display and draw pointer
        Screen('CopyWindow', winsOff.fix.h, winOn.h);
        Screen('DrawDots', winOn.h, mouse_xy_ptb_px, ...
            vaToPx(e.s.cursorRad_va, e.s.spatialConfig)*2, ...
            e.s.cursorColor, [], 1);
        Screen('Flip', winOn.h, []);
        
    end
    
end



%%%% Present stimuli

% If participant moves off starting position, abort trial (code 3).

out.tStimOnset_pc = nan;

if ~out.abortCode
    
    % Copy offscreen window with stims and start marker to onscreen window
    Screen('CopyWindow', winsOff.stims.h, winOn.h);
    
    % present items
    [~,out.tStimOnset_pc,~,~] = Screen('Flip', winOn.h, []);
    
    % present items for fixed time
    deltatItems = GetSecs - out.tStimOnset_pc;
    while deltatItems <= e.s.durItemPresentation
        
        % get position of mouse pointer (in pres area frame, visual angle)
        [mouse_xy_pa_va, mouse_xy_ptb_px] = ...
            getMouseRemapped_pa_ptb(e.s.mouseMovementMultiplier, e.s.spatialConfig);
        
        % Check whether tip position is in correct location and pointer is
        % angled correctly. This is indicated by variable tipAtStart.
        checkStartingPosition;
        
        % if start pos left, abort trial
        if ~tipAtStart
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



%%%% Location response

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
        [mouse_xy_pa_va, mouse_xy_ptb_px] = ...
            getMouseRemapped_pa_ptb(e.s.mouseMovementMultiplier, e.s.spatialConfig);
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



%%%% Target presence keyboard response

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
 


%%%% create unique ID for current response
out.reponseID = round(rand()* 1e+12);
if isfield(e.s.resCols, 'responseID')
    while any(e.results(:, e.s.resCols.responseID) == responseID)
        out.reponseID = round(rand()* 1e+12);
    end
end



%%%% Feedback

if out.abortCode == 0
    
    dur = e.s.feedback.dur_nonAbort;
    
    if out.responseCorrect == 1
        feedbackStr = e.s.feedback.correct;
    elseif out.responseCorrect == 0
        feedbackStr = e.s.feedback.incorrect;
    end        
    
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
    
end

ShowTextAndWait(feedbackStr, e.s.feedbackTextColor, winOn.h, dur, false)






