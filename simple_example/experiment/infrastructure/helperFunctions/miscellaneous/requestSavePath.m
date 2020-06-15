function path = requestSavePath(postfix, startPath, savePath)
% function path = requestSavePath(postfix)
%
% Ask for save path and participant ID.
%
% 'startPath' is optional and may also be left empty ''. If omitted or
% left empty the current working directory is used
%
% Input 'savePath' is optional and if specified the dialog to get a
% savepath will be skipped and the supplied path used instead.
%
% string 'postfix' is optional. If supplied gets appended to participant ID.
% Pass '' to use arg 'savePath' without applying a postfix.

if nargin < 1 
    postfix = '';
end
if nargin < 2 || isempty(startPath)
    startPath = pwd;
end

while 1
    
    % Ask for participant number and where to save    
    ptsTag = inputdlg('Enter participant code.','Particpant code',1,{''});    
    if nargin < 3
        savePath = uigetdir(startPath, 'Select folder to save results');
    end
    
    path = fullfile(savePath,[ptsTag{1}, postfix,'.mat']);
        
    % check whether file already exists (if not, ask again)
    if exist(path, 'file')
        
        uiwait(msgbox(['File with tag ''', ptsTag{1}, ...
            ''' already exists at ', savePath, ...
            '. Change tag and/or path.'], ...
            'Already exists','modal'));
        
    else
        
        break;
        
    end
    
end

