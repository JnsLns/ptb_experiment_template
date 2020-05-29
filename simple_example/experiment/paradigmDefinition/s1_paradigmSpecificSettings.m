%%%%%%%%%%%%%% Settings specific to the implemented paradigm. %%%%%%%%%%%%%

% Add any settings here that are specific to your paradigm and that might
% need to be changed in between participants without re-running trial
% generation. This might occur, for instance, for settings that depend on
% properties of some piece of hardware that might be different when the
% experiment is run on a different machine.
%
% Note however that it is usually a better idea to define as many settings
% as possible during trial generation, so that their values are fixed in
% the trial file, as this ensures that they can't be changed accidentally
% once trials have been generated (yes, it does happen :).
% As always, any settings defined here that you might want to look up later
% should be stored in struct 'e.s', to save in the results file.

%%%%%%%%%%%%%%%%%%%%%%% Usage for testing / debugging %%%%%%%%%%%%%%%%%%%%%
%                                                                         %
% It is also possible to override settings that already exist in the trial%
% file (i.e., in struct 'tg.s'), by re-setting them here. This would      %
% normally throw an error, which can however be disabled by setting:      %
%                                                                         %
% e.s.expScriptSettingsOverrideTrialGenSettings = true;                   %
%                                                                         %
% Setting this means that when a field with the same name exists in 'e.s' %
% and in 'tg.s', the value from 'e.s' will take precedence. Instead       %
% of throwing an error, which is the default behavior, a message box will %
% warn the user when the experiment is started, but it will then run      % 
% normally. This should be used only for debugging.                       %
%                                                                         %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

