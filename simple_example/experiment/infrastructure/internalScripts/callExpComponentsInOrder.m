loadFileToResume; % only effective if 'resumeMode' is true.

basicSettings;
s1_customSettings;

% Things to prepare before trials
preparations;
openOnscreenWindow;
s2_defineOffscreenWindows;
openOffscreenWindows;
s3_drawStaticGraphics;
if ~resumeMode
s4_presentInstructions;
elseif resumeMode
showResumeInstruction;
end
    
% Iterate over trials
while curTrialNumber <= size(triallist,1)
    trialLoopHead;
    if doBlockBreak
        s5a_blockBreak;
    end
    s5b_drawTrialSpecificGraphics;
    s5c_presentTrial;    
    trialLoopTail;
end

% Wrap up after all trials are done
finalSave;
s6_presentGoodbye;
cleanUp;

