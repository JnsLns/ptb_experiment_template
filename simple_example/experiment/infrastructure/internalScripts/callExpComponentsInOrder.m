settings;
s1_customSettings;

% Things to prepare before trials
preparations;
openOnscreenWindow;
s2_defineOffscreenWindows;
openOffscreenWindows;
s3_drawStaticGraphics;
s4_presentInstructions;

% Iterate over trials
while curTrialNumber <= size(triallist,1)
    trialLoopHead;
    if doBlockBreak
        s5a_blockBreak;
    end
    s5b_drawChangingGraphics;
    s5c_presentTrial;    
    trialLoopTail;
end

% Wrap up after all trials are done
s6_presentGoodbye;
cleanUp;

