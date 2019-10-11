function path = requestSavePath(postfix)
% function path = requestSavePath(postfix)
%
% Ask for save path and participant ID.
%
% postfix is optional.

if nargin < 1
    postfix = '';
end

while 1
    
    % Ask for participant number and where to save    
    ptsTag = inputdlg('Enter participant code.','Particpant code',1,{''});
    savePath = uigetdir('S:\','Select folder to save results');
    
    path = [savePath,[ptsTag{1}, postfix,'.mat']];
        
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

