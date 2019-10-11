
% in mm from center out in all directions (to edges, not corners of image)
showRadius = 130; % NOTE: this does not work as intended....


horzAx_mm = horzAx/pxPerMm(1);
vertAx_mm = vertAx/pxPerMm(2);
fitFun_horzSpan = max(horzAx_mm)-min(horzAx_mm);
fitFun_vertSpan = max(vertAx_mm)-min(vertAx_mm);
outerVal_horz = (fitFun_horzSpan-showRadius*2)/2;
outerVal_vert = (fitFun_vertSpan-showRadius*2)/2;

% find linear indices of start and end values in axes vectors (and
% fitFun dimension) for given showRadius
[~,lndx_upperVal_horz] = min(abs(horzAx_mm - outerVal_horz));
[~,lndx_lowerVal_horz] = min(abs(horzAx_mm - (-outerVal_horz)));
[~,lndx_upperVal_vert] = min(abs(vertAx_mm - outerVal_vert));
[~,lndx_lowerVal_vert] = min(abs(vertAx_mm - (-outerVal_vert)));

% Crop fitFun and axes value vectors to conform ro showRadius
fitFun_cropped = fitFun(lndx_lowerVal_vert:lndx_upperVal_vert,lndx_lowerVal_horz:lndx_upperVal_horz);
horzAx_mm_cropped = horzAx_mm(lndx_lowerVal_horz:lndx_upperVal_horz);
vertAx_mm_cropped = vertAx_mm(lndx_lowerVal_vert:lndx_upperVal_vert);

figure;
imagesc(horzAx_mm_cropped,vertAx_mm_cropped,fitFun_cropped);
xlabel('millimeters');
ylabel('millimeters');
axis square;