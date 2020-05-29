
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                               Overview                                  %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% This file is for creating a trial file that can be loaded by the
% experiments scripts. The trial file must contain a nested struct 'tg'
% (for "trial generation") with the following field-names and structure:
%
%  tg                    
%  ?? triallist           <- matrix in which each row corresponds to one trial
%  ?? s                   <- sub-fields hold paradigmn-level settings
%      ?? triallistCols   <- sub-fields hold indices into triallist columns
%      ?   ?
%      ?   ...             <- custom fields for column indices
%     ...                  <- custom fields for paradigm-level settings
%                             (there are some reserved field names with
%                             prespecified functionality, desribed below)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                       Steps in creating a trial-file                    %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% 1) Create a list of trials and store it in 'tg.triallist'.
%
%         For instance, define a list of two trials. Rows are trials and
%         columns are trial properties. Say we want to draw three dots in
%         each trial and we want to vary dot color and horizontal placement
%         between trials. Also, one item is the target item. Finally, each
%         trial gets a unique ID:
% 
%         % trial 1
%         tg.triallist(1, 1) = 1;            % ID 1
%         tg.triallist(1, 2) = 2;            % use color 2
%         tg.triallist(1, 3:5) = [-2,0,1];   % horizontal positions 
%         tg.triallist(1, 6) = 2;            % dot 2 is the target
%
%         % trial 2
%         tg.triallist(2, 1) = 2;            % ID 2
%         tg.triallist(2, 2) = 1;            % use color 1
%         tg.triallist(2, 3:5) = [-5,0,5];   % horizontal positions
%         tg.triallist(2, 6) = 3;            % dot 3 is the target
%
% 2) Create a struct 'tg.s.triallistCols' whose fields indicate which
%    columns of the above trial list hold which trial property. (note that
%    you would usually do this step before step one)
%
%         tg.s.triallistCols.trialID = 1;       % let's call column 1 "trialID"
%         tg.s.triallistCols.color = 2;         % and column 2 "color"
%         tg.s.triallistCols.horzPos = [3,4,5]; % horizontal positions are in these columns
%         tg.s.triallistCols.target = 6;        % tgt number is given in 6 
%
% 3) Define any overarching settings your paradigm code requires and store
%    them in fields of 'tg.s'. 
%
%         For instance, let's define background color and a set of colors
%         that stimuli can be printed in (as RGB triplets). Also, make dot
%         radius a property.
%
%         tg.s.bgColor = [0 0 0];                % black 
%         tg.s.stimColors = {[1 0 0], [0 1 0]};  % red and green
%         tg.s.stimRadius = 1;                   
%
% 4) Save 'tg' to a mat-file (e.g., into /trialFiles) that you will later
%    load into the experiment script.


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%          Coordinate frame and units for stimulus specification          %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% My suggestion is to specify locations and sizes in degrees of visual
% angle and based on the "presentation area coordinate frame". This frame
% has its origin in the screen center, the positive x-axis points to the
% right and the positive y-axis points upward. 
%
% This is different from what Psychtoolbox functions expect (pixel units,
% origin in upper left screen corner, top-down y-axis). However, in the 
% experiment scripts you can use the function paVaToPtbPx (located in
% '/helperFunctions/unitConversion') to easily convert from values in the
% presentation area frame (pa) and °visual angle (Va) to the Psychtoolbox
% frame (Ptb) in pixels (Px). The output of this function can be then be
% passed to the Psychtoolbox functions.  
%
% The advantage of using the presentation-area frame in trial specification
% is that experiments will be more easily portable, e.g., to different
% screens, and similar flexibility issues. Also, stimulus size in degrees
% of visual angle is what really matters in most vision-based experiments.
%
% However, it can be sensible to mix units in some cases, for instance, using
% degrees of visual angle for some values, and absolute distances (e.g., in
% millimeters) for others. For instance, when using motion tracking of hand
% position, hand starting distance from the screen would be specified in
% millimeters while stimulus positions on the screen would still be speci-
% fied in degrees of visual angle. 
% When mixing units, it is a good idea to disambiguate measures in the
% trial list by postfixing fields in 'tg.s.triallistCols' or 'tg.s' 
% accordingly. E.g., add "_va" for degrees visual angle and "_mm" for
% millimeters.
%
% Note that there are more functions to easily convert back and forth
% between the different units and coordinate frames in the folder
% '/helperFunctions/unitConversion'.


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%            Optional / reserved field names in struct 'tg.s'             %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% It is OPTIONAL to define any of these fields. The default behavior for
% those left undefined is indicated below. If a field IS defined, however,
% it should be used only for the intended functionality (in other words,
% don't use these field names for custom purposes or something might break).
%
% See Readme.md for detailed documentation of some of these fields. You
% should read it before using them.

% tg.s.experimentName = 'my_experiment'; % Will be appended to results file
%                                        % names. Default if undefined: ''                                       
% 
% tg.s.useTrialBlocks = true;            % Run 's5a_blockBreak.m' btw. blocks                                       
%                                        % Default if undefined: false. 
% 
% tg.s.shuffleTrialOrder = true;         % Shuffle trials (within blocks) at
%                                        % start of experiment. Default if
%                                        % undefined: false
% 
% tg.s.shuffleTrialOrder = true;         % Shuffle blocks at start of experi-
%                                        % ment. Default if undefined: false                                      
% 
% tg.s.presArea_va = [40, 30];           % [horizontal, vertical] extent of
%                                        % presentation area in degrees visual
%                                        % angle. Default if undefined: [0,0].            
%                                        
% tg.s.bgColor = 'grey';                 % Default background color for all
%                                        % Psychtoolbox windows; either an
%                                        % RGB triplet or one of the strings
%                                        % 'black', 'white', or 'grey'.
%                                        % Default if undefined: 'grey'
%                                        
% tg.s.onscreenWindowTextFont = 'Arial'; % Default font for onscreen window. 
%                                        % Default if undefined: 'Arial'
%                                           
% tg.s.onscreenWindowTextHeight_va = 0.75; % Default font height for onscreen 
%                                        % window [°visual angle]. Default if
%                                        % undefined: 0.75°                                
% 
% tg.s.desiredMouseScreenToDeskRatio = [1 1]; % Setting this will make avai-
%                                        % lable a function getMouseRM for
%                                        % code in folder paradigmDefinition.
%                                        % It is a wrapper for Psychtoolbox'
%                                        % getMouse() but allows setting
%                                        % mouse movement "speed". If this
%                                        % field exists, 
%                                        % e.s.rawMouseScreenToDeskRatio must
%                                        % be set in 'generalSettings.m'.

                                                                    






