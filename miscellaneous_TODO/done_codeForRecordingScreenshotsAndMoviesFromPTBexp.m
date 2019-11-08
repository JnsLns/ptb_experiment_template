% Write images to disk using the following code, then use another software
% (e.g., avidemux) to combine them into a movie. (seems to be much faster
% than using MATLAB's videoWrite...)

% Note: For some reason, the framerate setting in the code does not work.
% Last I tried I never got more than 10 images per second... maybe due to
% the time needed to access disk? would be strange...

%% Put this just before the trial loop
% Settings for storing screenshots 
screenshotframeRate = 25;
ssmatfile = matfile('d:\myScreenshots.mat','writable',true);
ssmatfile.screenshots = zeros(winRect(4),winRect(3),3,2); % initialize first page in 4th dim to be of same size as onscreen window
ssNum = 1;
tLastScreenshot = 0;


%% Put this in each loop where the buffers are flipped for refreshing screen
% Store current front buffer image from onscreen window
if GetSecs - tLastScreenshot(end) >= 1/screenshotframeRate
    imwrite(Screen('GetImage', win),['f:\expimages\', num2str(ssNum,'%01.3u'),'.jpg']);
    tLastScreenshot(end+1) = GetSecs;
    ssNum = ssNum + 1;
end