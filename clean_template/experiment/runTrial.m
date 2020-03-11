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


