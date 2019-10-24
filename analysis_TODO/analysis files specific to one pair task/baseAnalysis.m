
% -- Data structs:
%
% Input for this script is loaded from results files specified below. These
% files contain two structs: e and tg (experiment output and trial generation
% output, respectively). **Input to analyses comes exclusively from e!**;
% tg is and should not be used in this analyses.
%
% For analyses, all relevant data from e is aggregated in struct a in the
% very first script called below: loadingAndMiscPreps.m. From thereon, the
% entire analysis draws exclusively on this struct a. No additional data
% sources are needed for the analyses.
%
% While structs e (from experiment) and tg (from trial generation) continue
% to exist in the workspace during analysis they are and should not be used
% in any way for analyses (i.e., beyond what is done in loadingAndMiscPreps;
% they are just carried over from trial generation and experiment to allow
% looking up settings used there, if ever necessary). To be on the safe side,
% the settings stored in structs e and tg are also compared between loaded
% files in loadingAndMiscPreps and a warning is shown if they differ, to avoid
% throwing together results from differently configured experiments.
%
%
% -- Data coordinate frames:
%
% At the outset of analysis (i.e., until prepareTrajs.m, the second script 
% called below directly after loadingAndMiscPreps.m), all unprocessed
% position input data in all structs is in millimeters (not pixels) and
% lives in a coordinate frame whose origin is at the bottom left corner of
% the rectangular presentation area (which during the experiment was
% centered on the screen and had an extent of a.s.presArea_mm(1:2)), x-axis
% increasing to the right, y-axis increasing upwards.
%
% This changes ONLY for data in struct a, namely in prepareTrajs.m, which
% rotates and translates ALL* position data in struct a, according to the
% settings of a.s.doRotation and a.s.doTranslation. If enabled, these rotate
% trajectories to end on y-axis (see descr. below) and translate them to 
% start at [0,0], respectively. The non-trajectory position data is trans-
% formed accordingly to ensure consistency. All data derived after that
% (mean trajectories etc.) are in that same coordinate frame.
%
% * "all" means: trajectories, item positions stored in results matrix,
% and start marker positions stored in results matrix (no other position
% data is needed for analysis nor is it present in struct a).

%%

tic                   

% Store output of analysis (this is useful especially to preserve the set
% of trajectories actually included in the displayed trajectories when
% discarding trajectories for post hoc balancing (as this information is
% stored nowhere else and can't really be reproduced otherwise; note
% however that a backup of rowSets is made in a.s.backedUpRowSets during
% each analysis run, which may be used in a session to reuse a rowSet for
% subsequent runs). Note: Since balancing is now usually done by mean of
% means instead of discarding trials, this is mostly not needed, as each
% analysis can be reproduced from scratch.
aTmp.saveOutput = 0;

%% Visualization settings 
aTmp.showIndivTrajPreview = 0;                   % show single trajectories, one at a time, before going on...   
aTmp.showIndivTrajPreviewCurved = 0;             % same as before, but show only those discarded due to high curvature
aTmp.plotTrajectories = 1;                       % plot trajectories?
aTmp.plotOtherResults = 1;                       % plot results data?
aTmp.doPlotConstraintCategoryDistribution = 0;   % show distribution of constraint categories?                                                       
aTmp.plotCaseNumbersAcrossParticipants = 0;       % show mean, min, max case numbers across pts. for each condition
                                                 % (before conditions are joined by MoM)
aTmp.plotColors = {'r','b','g','c','m','y'};
aTmp.lineStyles = {'-',':','-.'};
aTmp.lineWidth = 1.5; % may be overridden by setting in plotSettings.m

%% Preprocessing settings              
                
% Interpolation
a.s.interpMethod = 'linear';                                % method for trajectory interpolation
a.s.samplingPeriodForInterp = 0.01;                         % sampling interval [milliseconds] for trajInterMatch()
a.s.nQueryPointsForInterp = 151;                            % number of query points for trajInter()
a.s.padAlignedToLength = ceil(3/a.s.samplingPeriodForInterp);   % Final length of matrices output by alignedMean and alignedStd. 

a.s.USE_TEMPORAL_NORMALIZATION_NOT_SPATIAL_PROTOTYPE = 1; % should be 1 (else activates prototype for spatial interpolation in computeStatistics
                                                          % which among other things discards trajectories that curve backward 
                                                          % along y-axis interpolation in computeStatistics)

% Rectification
a.s.doRotation = 1;                                         % make ideal path parallel to y-axis?                   
a.s.doTranslation = 1;                                      % translate trajs such that 1st data point is on 0,0
a.s.chosenItemDefinesRefDir = 1;                            % determine refDir for rotation based on chosen item instead of last data point

% Curvature 
a.s.curvatureSegmentLength = 15;    % length of traj segments for curvature computation
a.s.symThreshForCurvature = 0.05;   % used in all calls of curvatureOsc (see its doc for details)
a.s.symTimeThreshForCurvature = 1;    % same as above
a.s.roundToDecForCurvature = 2;       % same as above
a.s.curvatureCutoff = 0.06;% threshold above which trajs are marked as "sharply curved" in results mat                             
                           % Note: The maximum possible curvature (i.e., when two succeeding segments
                           % are exactly antiparallel) depends on segment length:
                           % maxCurve = 1/(0.5*segLen). That is, threshold should be adjusted when
                           % changing segment length
                                                     
a.s.curveComputationStartPointsSeparation = 1; % [mm] Curvature computation is done through osculating circle with preceding interpolation to uniform segment length;
                                               % the determined max curvature value of a trajectory is somewhat dependent on chance based on the arc distance
                                               % of the first data point from a strongly curved portion (which may either be "bridged" by a segment or result in a
                                               % sharp corner). Therefore, curvature computation is done for multiple interpolations and the max curvature
                                               % found in any of them is used. The interpolations differ in what point on the trajectory is used as starting point.
                                               % The first one uses the first data point of the trajectory, the second one uses a point an amount of arclength away
                                               % from the first data point, where the amount of arc length between the different starting points is determined
                                               % by the value set here, the third point is again that amount of arc length further down the trajectory and so on.
                                               % PotenTial starting point positions are within a segment of the trajectory of an arc length equal to a.s.curvatureSegmentLength,
                                               % which means that all possible positions of the interpolated trajectory are realized. Note that this algorithm is equivalent to 
                                               % fitting two connected line segments of fixed length a.s.curvatureSegmentLength to different positions on the raw
                                               % trajectory (distance is a.s.curveComputationStartPointsSeparation) such that all three vertices of the two line segments
                                               % lie on the trajectory, then construct a circle through the three points and use the inverse radius
                                               % as curvature for the arc length position at which the first vertex of the two-line segment is situated.

a.s.curvatureBinsUpperBounds = [0.06  1/(a.s.curvatureSegmentLength*0.5)/2 1/(a.s.curvatureSegmentLength*0.5)];
                                    % For use with IV "curvature bins", see ivDefinition
                                    % These are upper bounds of curvature bins into which trajectories are sorted
                                    % by assigning bin codes (1 to numel of this setting)
                                    % into a.rs column a.s.resCols.curvatureBin. Can be used to plot data divided by curvature
                                    % bin by specifying the respective IV in ivDefinition (don't forget to disable
                                    % curvature-exlcusion IV). Bins include their upper bound.
                                    % Alternatively, use the following two lines to specify bin *number*:
                                    % nCurveBins = 5; maxCurvature = 1/(a.s.curvatureSegmentLength*0.5);
                                    % a.s.curvatureBinsUpperBounds = linspace(maxCurvature/a.s.numOfCurvatureBins,maxCurvature,nCurveBins);                          
                            
aTmp.doPreproc = 0;  % If neither the loaded files nor the above preprocessing settings have been changed
                     % since the last run of the script, preprocessing can be disabled to save time
                     % (results from last run with preprocessing must be present
                     % in workspace; may also be loaded manually)               
                                   
%% Other settings

% Balancing options

a.s.balancingByMeanOfMeans = 1;    % do balancing by first computing averages within trial sets
                                   % from the same balancing category (code in a.s.relevantBalancingColumn)
                                   % and then computing a mean over these means.                                                                                                                                      
                                   
a.s.averageAcrossParticipantMeans  = 1; % do mean of means over participants for plotting?
                                        % Should usually be 1. If enabled an additional row is added
                                        % to cell array ivs (beyond what is specified in ivDefinition.m),
                                        % defining participants as an IV; before plotting, a.s.res and
                                        % a.s.trj are "collapsed" and averaged along that dimension to
                                        % plot an overall mean across participants means.                                       
                                        % Data separated by participants (e.g., as input for paired sample
                                        % tests) is still available in a.byPts.res and a.byPts.trj.
                                        
a.s.subtractMeanOfMeansNotGM = 1;       % This comes to effect only if subtracting overall mean from condition
                                        % means is activated for any IV in ivDefinition.m (in column
                                        % a.s.ivsCols.subtractOverallMean of a.s.ivs).
                                        % 1 means the mean of mean across condition means is used (usually the best choice)
                                        % 0 means the grand mean across individual trials from the active
                                        % conditions is used.                                                                                                   
              
a.s.combineLevelsByMeanOfMeansNotGrandMean = 1; % If this is 1, IV levels defined in a.s.ivs colum
                                                % a.s.ivsCols.joinVals are merged through a mean over the
                                                % respective levels' means, which negates the impact
                                                % of differential case numbers per level on the overall mean.
                                                % This is done in combineIVLevelByMoM.
                                                % If this is 0, the levels are instead merged by combining
                                                % the levels rowSets through logical OR (in combineRowSets),
                                                % which is equivalent to a grand mean over the pooled trials from
                                                % the respective levels and thus may give rise to biases toward the
                                                % effects in overrepresented categories.

% SOMEWHAT WIP...                
% Gauss fitting to mean trajectories, storing coefficients in a.trj.fit.gAmpl (amplitude),
% a.trj.fit.gMean (mean), and a.trj.fit.gSigm (width)        
a.s.doGaussFit = 0;              % fit Gaussian curves to each participant's mean trajectory?
a.s.gFit.aggregationType = 'wrp';  % Use "warped" (wrp) or "aligned" (trajectories) as basis.
a.s.gFit.dataType = 'pos';         % Fit to trajectories representing which measure? (pos,spd,vel,acc)     
a.s.gFit.xAxCol = 'x';             % Which column of source trajectory matrices provides data along x-axis                                     
                                   % (usually deviation from direct path or similar); give field name
                                   % in a.s.trajCols as string.
a.s.gFit.yAxCol = 't';             % Which column of source trajectory matrices provides data along y-axis                                     
                                   % (usually time data); give field name in a.s.trajCols as string.
a.s.gFit.yAxProp = 0;              % normalize data in yAxCol by maximum value (for each traj) in that column?
a.s.gFit.yAxUseIndices = 1;        % set a.s.gFit.yAxProp = 0 if using this! 
                                   % If this is enabled, y data is not used for the fitting y axis but instead the
                                   % element indices (1:numel(yData)) are used; If data is equally spaced anyway
                                   % this can be used.
% IMPORTANT: Using gauss fitting is usually only makes sense when a.s.ivsCols.subtractOverallMean is enabled for
% an IV because the overall (kinematic) shape of trajectories otherwise tends to mask smaller effects.
% Also, note that the fitting treats negative values as 0, so that biases into the numerically
% negative direction are not represented by the fitted function. This must be taken into account when
% interpreting the coefficients. Fortunately, subtracting an IVs overall mean from two of its levels
% produces two curves that are symmetric across the x-axis (and the fits are done for both versions), so
% that biases that are negative in one of them are positive in the other, which means that there are
% meaningful coefficients for both (you just have to look in the correct cells of a.trj.fit.gMean (etc.).                                                
                                                
% Enable/disable some computations (saves time)
% (position data for "warped" and raw trajectories are always computed due to certain dependencies,
% as well as results values in a.res)
a.s.doCompute_aligned = 0;      % aligned mean trajectories (constant interpolation time interval, time locked to move onset)                                     
a.s.doCompute_spdVelAcc = 0;    % speed, componential velocity, componential acceleration
a.s.doCompute_aucMaxDev = 0;    % area under curve, maximum deviation

% Settings for analysis with temporally aligned interpolation
a.s.doApplyTimeCutoff = 0; % Should normally be zero. Use only when analyzing trajectories with "aligned" interpolation.
                           % Discards trajectories whose movement time is below a.s.tCutoff and
                           % cuts all others to that length. Note that the
                           % former is not always advised (especially not for comparison with otherwise normalized
                           % data), because it changes not only the matching of trajectory portions
                           % but also the data base that is analyzed.
                           % For details see description of script applyTimeCutoff below.
                           % Caution: Changes a.tr and that may affect subsequent analysis runs!
a.s.tCutoff = 0.7; % [seconds] Only effective when a.s.doApplyTimeCutoff == 1

% ----- LEGACY BALANCING OPTIONS --------------------------------------------------------
% These should usually not be used and make sense only if a.s.balancingByMeanOfMeans==0                                    
a.s.discardTrialsToBalance = 0;    % Randomly discard trials from each IV-level(*) to achieve
                                   % balancing of numbers of code occurrences in a.s.relevantBalancingColumn
                                   % of results matrix. Note: Balancing takes place *before* rowSets are
                                   % joined and *after* rowSets are joined.            
                                   % (*) participants are as well treated as an IV-level for that purpose
                                   % Both of the following settings come to effect only if a.s.discardTrialsToBalance == 1 
a.s.zeroCasesImpactBalancing_beforeJoinVals = 0; % usually 0                                 
a.s.zeroCasesImpactBalancing_afterJoinVals = 1;  % usually 1
                                   % There are two points in the analysis pipeline where
                                   % trials within each cell of rowSets (i.e., within each combination
                                   % of conditions defined in ivs) are balanced such that each code
                                   % in the the matrix' rs column a.s.expectedBalancingValues occurs an  
                                   % equal number of times. Namely, balancing occurs before any IV
                                   % levels are merged, and after (because joining may introduce new
                                   % imbalances). The above settings define for each of these whether
                                   % (1) or not (0) zero occurences for one of the possible codes in a
                                   % condition are taken into account as a limiting factor (discarding
                                   % all other trials in the set); alternatively, the lowest number of
                                   % cases above zero is used as limiting factor. Note that some
                                   % balancing categories are incompatible with some conditions (e.g.,
                                   % spt:"right" & dtr:left & ref:opposite) so that balancing in
                                   % isolation is not possible for these (therefore usually set
                                   % beforeJoinVals=0), but joining may allow balancing in these cases
                                   % (therefore usually set afterJoinVals=1).                                                                                                         
a.s.numResamples = 1;   % If >1, the random discard procedure for post hoc balancing (and relevant
                        % analysis steps) is repeatedly performed, with a different set of trials
                        % in each run (from overrepresented categories - the category/ies with the
                        % least cases alway contributes all trials). The overall mean of the sampling
                        % results is returned as the analysis result. This converges toward
                        % the mean of means and is therefore here just for comparison and legacy.                                  
a.s.reuseOldRowSets = 0;% Should normally be 0; If 1, rowSets from previous run (stored in
                        % a.s.backedUpRowSets) are used, overwriting the a.s.rowSets computed in
                        % generateRowSets, balancing scripts etc. (other variables modifed in
                        % these scripts are NOT re-used, but computed anew; so this should be
                        % used only if you know what you are doing!!!)                     
                        % If 0, then rowSets from this run is stored, overwriting any
                        % previously backed up a.s.backedUpRowSets.                                                                      
a.s.removeZeroCaseParticipants = 0;     % Completely discards participants from analyses who after balancing
                                        % have zero cases in any of the conditions (combinations) defined in
                                        % ivs (i.e., cells in rowSets). This is done after re-balancing (if
                                        % enabled) following combineRowSets. Should normally be 1.
                                        % Note: The array pages in array rowSets holding these participants
                                        % are deleted and relevant data is removed from ivs (but a.s.files is
                                        % not changed).                                   
% ----- END OF LEGACY OPTIONS -------------------------------------------------------------                   

                                        
%% Load files & run preprocessing scripts

% prepare save file
if aTmp.saveOutput
    waitfor(msgbox('Select target file to store analysis results.'));
    [aTmp.analysisOutFile, aTmp.analysisOutPath] = uiputfile('anaOut_.mat');
end

if aTmp.doPreproc
    % Load result files
    % Note: Settings (e.g., presArea_mm and such) are used from the last loaded
    % file; a warning is shown if settings differ between loaded files.
    waitfor(msgbox('Select experiment output files to analyze.'));
    [a.s.files, a.s.path] = uigetfile('multiselect','on');
    loadingAndMiscPreps;    % Load results an concatenate participants' data (also add a.s.resCols.pts)
    prepareTrajs;           % trim, translate, rotate trajectories (a.tr, a.rs item positions, a.rs start pos)
else warning('Preprocessing scripts skipped, using data present in workspace.');
end

defineNewResultsColumns;% Add new column indices to a.s.resCols (used for new results values below)

if aTmp.doPreproc
    computeMaxCurvature;    % Compute maximum curvature for each traj and add to results
end



%% Run analysis scripts
% Note:Scripts labeled SETTINGS can be adjusted to obtain different analyses/plots
% See Documentation.txt for detailed information about the component scripts.
% Note that script-specific variables are cleared at the end of each file.

% ---Processing that is independent of IVs and trial sets

% Loop for resampling of trials set from overrepresented balancing categories
for sampleRun = 1:a.s.numResamples
if a.s.numResamples>1 && a.s.discardTrialsToBalance
    aTmp.sampleRun = sampleRun;
end
    
    
prepareResults;         % compute new results values (except max. curvature & pts. tags, which is done above)
%trajPreview;           % NEEDS WORK preview individual trajectories and items (ALL trajs except curved ones)
ivDefinition;           % --SETTINGS-- Independent variable and IV-level definition

addBalancingCategoryIV; % when a.s.balancingByMeanOfMeans==1, this adds an internally used IV
                        % (i,e., a row to a.s.ivs) labelled internalBalancingCategoryIV and based
                        % on results column a.s.relevantBalancingColumn. This IV persists until
                        % after computeStatistics, where data arrays are collapsed along the respective
                        % dimension via mean of means (in collapseAlongBalCatIV).

addPtsAsLastRowInIvs;   % define participants as IV in the last row of cell array ivs 
mirrorSomeTrajectories; % flip trajectories across "ideal path" where desired, adjust item positions in results accordingly
                        % Note1: a.s.resCols.sideNonChosenToDirPath, refSide, and comSide are not changed accordingly!
                        % Note2: Mirroring does not impact balancing (i.e., it still works)!
makeFigTitleString;     % (of minor importance) Construct figure title from ivs settings
                        
% ---Determine trial sets based on IVs/conditions and balancing (modifying a.s.rowSets)                        

addTemporaryIVLevels;   % temporarily add IV values that are involved in requested
                        % difference/joined levels but are not desired to be plotted themselves
generateSets;           % make sets of trajectory/trial indices based on a.s.ivs
discardForBalancing_A;  % Removes (sets to 0) trials in rowSets to achieve balancing
                        % of relevant trial properties within each combination of conditions/participants                                           
                        
combineRowSets;         % Realizes a.s.ivsCols.joinVals (merge trial sets from different IV-levels);
                        % also removes IV-levels that were activated only for use in combineRowSets
                        % (removes only levels, i.e., array pages, not whole IVs/dimensions)                                                
                        % Comes to effect only if a.s.combineLevelsByMeanOfMeansNotGrandMean==0
                        % (otherwise, desired IV-level joins are realized by combineIVLevelByMoM.m)                        
discardForBalancing_B;  % Removes (sets to 0) trials in rowSets to achieve balancing
                        % as before (has to be redone after combining row sets)
                                     
removeZeroCasePts;      % remove participants that have zero case for any balancing category in any
                        % condition (i.e., in any cell of rowSets). This must run before trial data
                        % itself is assigned into array cells (only a.s.rowSets and ivs is adjusted)
                        % Note that the respective participant's data are altogether removed from
                        % rowSets (cells are deleted) and from ivs                       

applyTimeCutoff;        % This script (1) finds trajectories whose duration (first to last data
                        % point) is shorter than a.s.tCutoff and removes these from all row sets (i.e.,
                        % from all remaining analyses), (2) removes data beyond that cutoff from
                        % all other trajectories (note that the time stamp for each last data point,
                        % i.e., the one closest to a.s.tCutoff, us changed to to a.s.tCutoff,
                        % which introduces a tiny imprecision in the last data points).
                        % This script is meant to be used with time-aligned interpolation, so that
                        % all time points in mean trajectory data are based on the same number of
                        % trajectories (otherwise later portions of the mean trajectories are based
                        % on less and less data).
                        %
                        % CAUTIONARY NOTE: Unlike the other scripts, this one changes a.tr directly,
                        % that is, the data on which all following scripts draw, and the change
                        % cannot be reversed without reloading or re-preprocessing the data.
                        
% Re-use rowSets from previous run?
% This overwrites a.s.rowSets computed in above scripts with a version stored during a previous run.
if a.s.discardTrialsToBalance
    if a.s.reuseOldRowSets
        warning('Using rowSets from previous run (overwriting the one just computed)');
        a.s.rowSets = a.s.backedUpRowSets{aTmp.sampleRun};
    elseif isfield(aTmp,'sampleRun')
        if aTmp.sampleRun == 1; a.s.backedUpRowSets={}; end % clear on first run
        a.s.backedUpRowSets{aTmp.sampleRun} = a.s.rowSets; % save rowSets used in this run for later re-use
    end
end

% ---Assign actual data to cell arrays based on trial sets from above and process these chunks
                        
computeStatistics;      % for each combination of IV-levels. compute means and SDs **across trials**; also compute AUC,MD
                        % (note that at this point, the trials pose the statistical ensemble) 
                        
                        % At this point, means in the data arrays are means across trials.
                        
collapseAlongBalCatIV;  % Collapse data arrays along the IV/dimension that hold the balancing categories,
                        % using a mean of means (i.e., the mean trajectory in each balancing category is
                        % weighted equally, regardless of the number of individual trials it                        
                        % was computed from).                                          
                        % Note that all singleton dimension are squeezed out of the data arrays at this point
                        % (however, there should be none at this point, except for the now-singleton
                        % balancing category dimension).
                        % Note that the additional cell array aTmp.ncs_ind which is created in this script
                        % tracks how many cases from each individual balancing category went into each
                        % mean. This is used in the following script (combineIVLevelByMoM.m, runs
                        % only if any combinations enabed) to ensure that an equal number of means
                        % from each balancing category contributes to the combinations generated there. 

                        % At this point, means in the data arrays are means across the balancing category-specific means over trials.

plotCaseNumbersPerCondition; % This plots case number within each condition (mean, min, max over participants)
                        
combineIVLevelByMoM;    % If desired, combine certain IV-levels by mean of means. At this point at the latest,
                        % each resulting mean/combinaton of conditions should be based on the same number of
                        % means from each balancing categories in order to prevent biases due to one of the
                        % balancing categories being overrepresented in the respective overall mean (e.g., if two
                        % condition means are averaged here, and one is based only on trials from balancing
                        % category rs/cs while the other is based only and rs/cd, then the mean of means will be
                        % biased toward rs). Also, it is required that a mean from each balancing
                        % category goes into the combination to ensure overall balancing. Both of these things are
                        % checked here and a warning is issued if any of them is not the case.                      

                        % At this point, means in the data arrays are means across the means across the balancing
                        % category-specific means over trials.                        
                        
subtractIVAverage_grandMean;   % if any, only one of these is used (depends on a.s.subtractMeanOfMeansNotGM)                     
subtractIVAverage_meanOfMeans;
                        % for a given dimension (i.e., IV), subtract the average across all activate
                        % levels from each individual mean trajectory. The overall mean is obtained...
                        % ... if a.s.subtractMeanOfMeansNotGM == 1 as a mean of means over mean
                        % trajectories from the conditions.
                        % ... if a.s.subtractMeanOfMeansNotGM == 0 as the grand mean across all
                        % individual trials. The latter is done by simply (and only temporarily!)
                        % collapsing a.s.rowSets along that dimension, combining all trials that are
                        % active (==1) in any page along that dimension (logical OR), then computing
                        % statistics for the resulting overall trial set via calling computeStatistics
                        % using the temporary rowSets, re-expanding the resulting means arrays along
                        % the formerly collapsing dimension page and then cell-by-cell subtracting
                        % overall means from the the original ones.
                        
computeDiffsBtwMeans;   % compute difference between IV-level means where desired
                        % Note: .ind-cells of struct trj are not merged! (those in struct res are!)                                                                                            
removeTmpDiffIVLevels;  % remove IV-levels that were activated only for use in computeDiffsBtwMeans                     
                        % (removes only levels, i.e., array pages, not whole IVs/dimensions)                        

gaussFitTimeCourse;     % WIP (works in principle... correct point for doing this? e.g., put before diffs?)                                                   
                        
resampleAnalysis;       % WIP (works in principle but currently computes across-sample means
                        % only for a.trj.wrp.pos.avg; also, this is obsolete, since balancing
                        % is now done by mean of means in a single pass) 
end % resampling loop end
                        
averageAcrossPtsMeans;  % UP TO HERE, EVERYTHING IS WITHIN-PARTICIPANT;
                        % this now averages over pts. (if enabled) to allow plotting a single
                        % overall-pts. mean for each condition.
                        % Note1: Standard deviations found in struct fields labeled ".std", are
                        % *between-subject stds* (stds btw. individual pts.' means), as these are
                        % also relevant for hypothesis tests. However, this also adds a field
                        % ".meanStd", holding the mean std over participants (gives an idea of
                        % trial-to-trial variation).      
                        % Note2: Pts-based data is retained in a.byPts, to be used for paired
                        % sample hypothesis tests.                                
                        
% ---Plotting                        
                        
plotSettings;           % --SETTINGS-- define what data should be plotted over what axes etc.
plotTrajData;           % Plotting: trajectories
plotResData;            % Plotting: non-trajectory data
plotConstraintCategoryDistribution_analysis; % Plotting: distribution of trials over different constraint categories to evaluate balancing


%% Aftermath

% save output
if aTmp.saveOutput
    drawnow
    disp(['Saving output to ' aTmp.analysisOutPath aTmp.analysisOutFile]);
    save([aTmp.analysisOutPath aTmp.analysisOutFile], 'a', 'aTmp');
end
disp(['Done.' char(10)])
displaySummary;
toc


