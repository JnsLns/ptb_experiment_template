generalSettings;
s1_paradigmSpecificSettings;

% Things to prepare before trials
preparations;
openOnscreenWindow;
s2_defineOffscreenWindows;
openOffscreenWindows;
s3_drawStaticGraphics;
s4_presentInstructions;

% Iterate over trials
while curTrial <= size(trials,1)
    trialLoopHead;
    if doBlockBreak
        s5a_blockBreak;
    end
    s5b_drawChangingGraphics;
    s5c_oneTrial;    
    trialLoopTail;
end

% Wrap up after all trials are done
s6_presentGoodbye;
cleanUp;

