% NOTES FOR TRIAL GENERATION %%%%%%%%%%%%%%%%%%%%%%%%%

% Adjust for stimulus line width when defining size in trial
% generation (stims should still be as large as defined by h and v).


% NOTE Struct tg should contain fields
% s         --> all settings that need not be iterated over (these are copied to
%               e.s in the beginning of the experimental script)
% triallist --> list of trials (each row will copied into experimental
%               results matrix when the respective trial is completed)
% triallistCols --> Will be used in experimental script to address into
%                   triallist. Also, its fields are added to e.s.resCols
%                   (with an appropriate numeric offset to account for
%                   already existing results columns) to be able to address
%                   into the trial-data columns in the final results
%                   matrix.
%


% These need to be defined during trial generation; tg.s is copied to e.s
% in the experimental script. Size and position measures are in degrees 
% visual angle unless fieldnames are postfixed with '_mm'.
%
%
% tg.s.fixRadius_va;    Radius of fixation cross (visual angle)
% tg.s.fixLineWidth_va; Line width of fixation cross (visual angle)
% tg.s.fixColor;        Color of fixation cross (rgb)
% tg.s.startPos_mm;     Pointer tip starting position that has to be assumed at the outset of
%                       trial. Row vector x,y,z in presentation area frame (mm). Should be in the
%                       center
% tg.s.startRadius_mm   Radius around tg.startPos_mm in which pointer tip
%                       has to be to count as being on the starting position
% tg.s.circleLineWidth_va;
% tg.s.durOnStart;
% tg.s.durWaitForStart;
% tg.s.durPreStimFixation;
% tg.s.durItemPresentation;
% tg.s.allowedLocResponseTime;
% tg.s.allowedTgtResponseTime;
% tg.s.zZeroTolerance   pointer's absolute z-value must be below this value
%                       for response to be registered (mm) 
% tg.s.pointerStartAngle;  max angle (deg) of lines from pointer tip to
%                          pointer markers with z-axis during start phase
% tg.s.circleColor_notOk;
% tg.s.circleColor_ok;
% tg.s.yesKeyName;      should be 'return'
% tg.s.noKeyName;       should be '.'
% tg.s.stimShapes;
% tg.s.stimColors;
% tg.s.feedbackColor;
% tg.s.presArea_va = [20, 15]; % size of presentation angle in degrees visual angle
%
%
% cell array with letter specifications for function lineItem
%                                            % 0  = O (tgt)
%tg.s.stimShapes{1} = {[1,3,9]};             % 1  = L
%tg.s.stimShapes{2} = {[1,9],[3,7]};         % 2  = X
%tg.s.stimShapes{3} = {[4,6],[1,7],[3,6]};   % 3  = I
%tg.s.stimShapes{4} = {[1,3,5,9,7]};         % 4  = W
%tg.s.stimShapes{5} = {[7,1,3],[2,8]};       % 5  = F
%tg.s.stimShapes{6} = {[3,1,5,7,9]};         % 6  = M
%tg.s.stimShapes{7} = {[7,1,3,9],[2,8]};     % 7  = E
%tg.s.stimShapes{8} = {[1,3],[2,8],[7,9]};   % 8  = H
%tg.s.stimShapes{9} = {[1,6,7]};             % 9  = V
%tg.s.stimShapes{10} = {[1,7,3,9]};          % 10 = Z
%tg.s.stimShapes{11} = {[1,7],[4,6]};        % 11 = T
%tg.s.stimShapes{12} = {[1,5,7],[5,6]};      % 12 = Y
%tg.s.stimShapes{13} = {[3,1,9,7]};          % 13 = N
%
%
% stim color specification. color codes in triallist should correspond to
% element number in this array. Adjust these to have the correct colors
% used by Hazeltine!
%tg.s.stimColors{1} = [1 0 0]; % red
%tg.s.stimColors{2} = [0 1 0]; % green
%tg.s.stimColors{3} = [0 0 1]; % blue
%tg.s.stimColors{4} = [1 1 0]; % yellow
%tg.s.stimColors{5} = [0 0 0]; % black
%tg.s.stimColors{6} = [1 1 1]; % white
%
% Feedback strings
%tg.s.feedback.correct;
%tg.s.feedback.incorrect;
%tg.s.feedback.dur_nonAbort;
%tg.s.feedback.notMovedToStart;
%tg.s.feedback.leftStartInFix
%tg.s.feedback.leftStartInStim
%tg.s.feedback.exceededLocRT
%tg.s.feedback.exceededTgtRT
%tg.s.feedback.dur_abort


% Contents of the triallist (and fields of tg.triallistCols)
% (at the same time fields in tg.triallistCols)
%
% Note: All position data in the triallist must be in visual angle!
%
% tg.triallistCols.vertPosStart;  % center positions
% tg.triallistCols.vertPosEnd;
% tg.triallistCols.horzPosStart;
% tg.triallistCols.horzPosEnd;
% tg.triallistCols.vertExtStart;  % extent
% tg.triallistCols.vertExtEnd;
% tg.triallistCols.horzExtStart;
% tg.triallistCols.horzExtEnd;
% tg.triallistCols.stimIdentitiesStart;   % shape codes corresponding to tg.StimShapes
% tg.triallistCols.stimIdentitiesEnd;
% tg.triallistCols.stimColorsEnd;         % stim color codes corresponding to tg.stimColors
% tg.triallistCols.stimColorsEnd;
% tg.triallistCols.stimLineWidthsStart;   % actual line width (not codes)
% tg.triallistCols.stimLineWidthsEnd;
% tg.triallistCols.trialType  % 1 = target present, 2 = both ftrs present, 3 = color only

% NOTE: Regardless of the length of the number of elements covered by the
% above spans of columns, items can be left unspecified by putting nan in
% the stimIdentities column.
