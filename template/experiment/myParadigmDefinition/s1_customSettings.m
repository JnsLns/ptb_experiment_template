%%%%%%%%%%%%%%%%%%%%%%%%%%%% Custom settings %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                                         
% Add any custom settings for your paradigm. Any settings that you might  
% want to look up later should be stored in struct 'e.s', others can be   
% stored in their own variables.                      
%
% Generally you should define here only settings that you might need to   
% change later, in between participants and without re-running trial      
% generation, such as properties of some piece of hardware that might     
% change when porting the paradigm between machines.                      
%
% In most cases, it is best to define as many settings as possible during
% trial generation, so that their values are fixed in the trial file, thus
% preventing them from being changed accidentally once trials have been
% created.    
%
%
%        ___Useful variables that exist at the outset of this file___
%            
% e.s   experiment settings
%
%                                                                                                                                                 
%                   ___Usage for testing / debugging___
%                                                                         
% It is also possible to override settings that already exist in the trial
% file (i.e., in struct 't.s'), by re-setting them here. This would      
% normally throw an error, which can however be disabled by setting:      
%                                                                         
% e.s.expScriptSettingsOverrideTrialGenSettings = true;                   
%                                                                         
% Setting this means that when a field with the same name exists in 'e.s' 
% and in 't.s', the value from 'e.s' will take precedence. Instead       
% of throwing an error, which is the default behavior, a message box will 
% warn the user when the experiment is started, but it will then run       
% normally. This should be used only for debugging.                       
%                                                                         
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

