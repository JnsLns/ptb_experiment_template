% Check whether pause key is being pressed (i.e., the key set in
% basicSettings to be the pause key). If so, variable
% 'pauseKeyPressed' will be true, else it will be false.

pauseKeyDepressed = false;
if KbCheck
    
    [~,~,whichKey] = KbCheck;
    keyName = KbName(whichKey);
    if iscell(keyName)
        keyName = keyName{1};
    end
    
    if strcmp(keyName,pauseKey)
        pauseKeyDepressed = true;                 
    end
    
end

