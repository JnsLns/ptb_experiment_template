
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%   Settings   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Note: Size and position measures are in degrees visual angle ('_va')
% unless fieldnames are postfixed with '_mm' (millimeters). All position
% data is in the presentation-area-based coordinate frame.


%%%% Reserved field names in struct 'tg.s' (detailed documentation below)

% It is optional to define these fields, default behavior is indicated below.
% IF they are defined, however, use them only for the intended functionality! 

tg.s.experimentName = 'my_experiment'; % Will be appended to results file names.                                   
                                       % Default if undefined: ''                                       
tg.s.useTrialBlocks = true;            % Run 's5a_blockBreak.m' btw. blocks                                       
                                       % Default if undefined: false
                                       % See Readme.md for details.
tg.s.shuffleTrialOrder = true;         % Shuffle trials (within blocks) at
                                       % start of experiment
                                       % Default if undefined: false
                                       % See Readme.md for details.
tg.s.shuffleTrialOrder = true;         % Shuffle blocks at start of experiment
                                       % Default if undefined: false
                                       % See Readme.md for details.                                       

tg.s.presArea_va = [40, 30];           % [horizontal, vertical] extent of
                                       % presentation area in degrees visual
                                       % angle.
                                       % Default if undefined: [0, 0] (i.e., 
                                       % the coordinate origin will be in
                                       % the screen center).
                                       % See Readme.md                                          

% Visuals
                                       
tg.s.onscreenWindowTextFont = 'Arial';    % Default font for onscreen window. 
                                          % Default if undefined: 'Arial'
tg.s.onscreenWindowTextHeight_va = 0.75;  % Default font height for onscreen 
                                          % window [°visual angle]
                                          % Default if undefined: 0.75°
tg.s.bgColor = 'grey';              % default background color for all
                                    % Psychtoolbox windows; either an
                                    % RGB triplet or one of the strings
                                    % 'black', 'white', or 'grey'. Default
                                    % if undefined: 'grey'.                                    

% Mouse movement
                                    
% Setting this will make available a function getMouseRM for any code in 
% folder paradigmDefinition. That function is a wrapper for Psychtoolbox'
% getMouse() and will return remapped mouse positions blablabla...
% If this field exists, e.s.rawMouseScreenToDeskRatio must be set in
% 'generalSettings.m':
% See Readme.md for details.
tg.s.desiredMouseScreenToDeskRatio = [1 1]; 





                               

                                      



   







