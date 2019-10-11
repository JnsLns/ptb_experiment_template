
% viewing distance [mm] is e.s.viewingDistance
vd = e.s.viewingDistance;

nStims = 5; % number of stimuli

% stimulus sizes in visual angle
h = 0.54; % horizontal extent
v = 0.71; % vertical extent
hSep = 0.94 + h; % spacing horz (border-to-border)

% convert to mmw
vaToMm = @(a) tand(a)*vd;
stims_h_mm = vaToMm(h);
stims_v_mm = vaToMm(v);
sep_h_mm = vaToMm(hSep);


% Stimulus midpoint positions relative to array midpoint
nSpaces = nStims - 1;
total_h_mm = nSpaces * sep_h_mm + nStims * stims_h_mm; % total extension
hPos_mm = (stims_h_mm/2 + (0:nStims-1)*sep_h_mm) - total_h_mm/2;

% TODO: Adjust for line width (stims should still be as large as defined by
% h and v.

% nine grid points to construct stimulus shapes
% 1 2 3
% 4 5 6  (5 is at 0,0)
% 7 8 9

points_xy = ...
    [-stims_h_mm/2 ,  stims_v_mm/2 ; ...
      0            ,  stims_v_mm/2 ; ...      
      stims_h_mm/2 ,  stims_v_mm/2 ; ...            
     -stims_h_mm/2 ,  0            ; ...
      0            ,  0            ; ...
      stims_h_mm/2 ,  0            ; ...           
     -stims_h_mm/2 , -stims_v_mm/2 ; ...
      0            , -stims_v_mm/2 ; ...
      stims_h_mm/2 , -stims_v_mm/2   ...
    ];

% function mapping 1 to 9 to coords (center is position relative to array center)
gridShape = @(points, center_xy) points_xy(points,:) + repmat(center_xy, 1, size(points,1));

% letters
l = struct();
l.L = [1,7,9];
l.X = [1,9,5,3,7];
l.I = [1,3,2,8,7,9];
l.W = [1,7,5,9,3];
l.F = [3,1,4,5,4,7];
l.M = [7,1,5,3,9];
l.E = [3,1,4,6,4,7,9];
l.H = [1,7,4,6,3,9];
l.V = [1,8,3];
l.Z = [1,3,7,9];
l.T = [1,3,2,8];
l.Y = [1,5,3,5,8];
l.N = [7,1,9,3];





stims = {};
hAx = axes('nextplot', 'add');
fnames = fields(l);
for fnum = 1:numel(fnames)            
    fname = fnames{fnum};
    stim = gridShape(l.(fname), [sep_h_mm*fnum, 10*fnum]);    
    stims{end+1} = stim;
    plot(hAx, stims{end}(:,1), stims{end}(:,2), 'linewidth', 3);
end
axis equal
