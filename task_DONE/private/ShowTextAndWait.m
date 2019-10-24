function keyName = ShowTextAndWait(string, color, onscreenWin, waitSecs, waitForKeyPress)
% function keyName = ShowTextAndWait(string, win, color, waitSecs, waitForKeyPress)
%    
% Present centered text 'string' in onscreen window 'onscreenWin' and wait
% for waitSecs.
% 
% waitForKeyPress is optional, default false. If false, after text onset the 
% function simply waits for 'waitSecs' seconds. If true, text is displayed
% indefinately until a key is pressed and then the function waits for
% 'waitSecs' seconds.


DrawFormattedText(onscreenWin, string, 'center', 'center', color);
Screen('Flip', onscreenWin, []);
  
if nargin > 4 && waitForKeyPress == true

    [~,k,~] = KbWait;
    keyName = KbName(k);
    
else
    
    keyName = '';

end

WaitSecs(waitSecs);

   