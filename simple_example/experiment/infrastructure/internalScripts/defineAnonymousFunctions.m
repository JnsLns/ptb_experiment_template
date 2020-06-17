% Define anonymous functions here. These can then be used in the experiment
% code for convenience.


% getMouseRM
%
% For getting remapped mouse position; only if desired mouse
% screen-desk-ratio was defined during trial generation.

if isfield(e.s, 'desiredMouseScreenToDeskRatioXY')
    % make sure raw ratio is defined as well
    if ~isfield(e.s, 'rawMouseScreenToDeskRatio') || isnan(e.s.rawMouseScreenToDeskRatio)
        error(['When t.s.desiredMouseScreenToDeskRatioXY is set in trial ', ...
            'generation (which is the case), then e.s.rawMouseScreenToDeskRatio ',...
            'must be defined in generalSettings.m (which is not the case).']);
    end
    getMouseRM = @() getMouseRemapped(e.s.rawMouseScreenToDeskRatio, ...
        e.s.desiredMouseScreenToDeskRatioXY, convert);
elseif isfield(e.s, 'rawMouseScreenToDeskRatio')
    e.s = rmfield(e.s, 'rawMouseScreenToDeskRatio'); % unneeded in this case
end