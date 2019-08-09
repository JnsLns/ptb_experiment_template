
% NOTE: THIS IS WIP FOR MODIFED EXPERIMENT. ESPECIALLY THE COMMENTS MAY BE
% INCORRECT AS THEY STEM FROM THE LAST VERSION.

% Use this to generate a list of trials for the spatial pointing task,
% including trials according to the specifications given below.

% Run once for adjustment trials and once for main trials, setting up the 
% desired set of trials and number of repetitions first. After each run,
% rename the resulting matrix 'trials' to either 'mainTrials' or 
% 'adjustmentTrials', and store this newly named matrix in a file
% triallist_main.mat or triallist_RTadjustment.mat, respectively. In each
% of these files also store the struct 'triallistCols' (which holds
% information about which columns in the triallist hold which trial
% properties and is used in the experiment to address these columns). Put
% these files in the same directory as the main experiment script.

% note: (true) randomization is done in experimental script, not here.

% In case of changing which column holds which data in the trial list: Be
% sure to also adjust column numbers given in triallistCols according to
% the changes.

% The general idea is that all peculiarities of a trial are explicitly 
% specified in the respective row of the trial list rather rather than
% being derived from the trial type in the experiment script. For example,
% trial type 3 specifies that a trial is a catch trial, but the mismatch
% between the relation of target and reference and the spatial term is also
% realized in the numbers of this trial's row, so that as little as possible
% has to happen in the experimental script that different from what is
% done for a normal relational trial.

% -------------------------------------------------------------------------

% In the *final* list this script produces, each row holds one trial, while
% the columns refer to the following properties:

% the trial number ("ID"), unique to each trial (not trial type!)
triallistCols.trialID = 1;
% trial type (1 = spatial, 2 = color Only)
triallistCols.type = 2;
% The number of the target item (where the number refers to the
% subsection of the columns that specify the individual item colors, from
% left to right)
triallistCols.tgt = 3;
% The number of the reference item (as above)
triallistCols.ref = 4;
% The spatial term that should be used (actual string used depends on
% what string is associated with the number within the experiment script)
triallistCols.spt = 5;
% The hand with which this trial must be responded to (1 = right, 2 =
% left)
triallistCols.hand = 6;
% Order of occurence of ref and tgt in the spatial phrase (1 = tgt first; 2
% = ref first)
triallistCols.wordOrder = 7;
% The colors of the items, in that order (where the location at which
% the color appears in the experiment ultimately depends on the location
% values in the matrix "stimuli" within the experiment script.).
triallistCols.colorsStart = 8;
triallistCols.colorsEnd = 19;

% -------------------------------------------------------------------------

% Change the following list to modify trial types

% The list is structured as detailed above, except that it does 
% not have a trial ID in column 1 yet (i.e., all columns are shifted by one). 
% Also, the numbers given in [triallistCols.colorsStart-1] to
% [triallistCols.colorsEnd-1] do not refer to absolute colors, but signify 
% which items are supposed to have the same colors (same number = same
% colors; the actual color values are assigned randomly later)
% Note that zero for spatial term mean that it isnot needed in this trial
% (likely because the target is specified by color only rather than by a
% spatial relation).

% trial type (1 = correct, 2 = catch trials 3 = single item trial) 
% TGT
% REF
% SPT(1=links,2=rechts)
% response hand (1 = right, 2 = left)
% 12 cols of colors (same number = same color; zero means random color but not that of ref or tgt) 

% * IMPORTANT! The total number of left hand/ right hand trials must be
% equal in the final trial matrix, since left/right hand trials
% are presented in an alternating fashion! (Alternatively, enable random
% hand assignment in experiment script, which overrides the settings in the
% triallist).


%% START OF MAIN TRIALS----------------------------------------------------

% trials = [...     
% 
% % (A) distance 1 (ref/tgt adjacent), 12 items, inner 8 can be ref, inner 6 can
% % be target.                
% % type   tgt   ref  spt   hand  w.order              colors
% %   |     |     |    |      |    |
% %                                     1 2    3 4 5 6 7 8 9 10 11 12       
%     1	  4     3    2   	1    1	  0 0    1 2 0 0 0 0 0 0   0 0; ...
%     1	  4     5    1   	1	 1    0 0    0 2 1 0 0 0 0 0   0 0; ...
%     1	  5     4    2   	1	 1    0 0    0 1 2 0 0 0 0 0   0 0; ...
%     1	  5     6    1   	1	 1    0 0    0 0 2 1 0 0 0 0   0 0; ...    
%     1	  6     5    2   	1	 1    0 0    0 0 1 2 0 0 0 0   0 0; ...
%     1	  6     7    1   	1	 1    0 0    0 0 0 2 1 0 0 0   0 0; ...        
%     1	  7     6    2   	1	 1    0 0    0 0 0 1 2 0 0 0   0 0; ...
%     1	  7     8    1   	1	 1    0 0    0 0 0 0 2 1 0 0   0 0; ...    
%     1	  8     7    2   	1	 1    0 0    0 0 0 0 1 2 0 0   0 0; ...
%     1	  8     9    1   	1	 1    0 0    0 0 0 0 0 2 1 0   0 0; ...
%     1	  9     8    2   	1	 1    0 0    0 0 0 0 0 1 2 0   0 0; ...
%     1	  9    10    1   	1	 1    0 0    0 0 0 0 0 0 2 1   0 0; ...
%      
% % Same displays as (A) but as catch trials (trial type = 2 and reversed
% % (i.e., wrong) spatial terms).
% % type   tgt   ref  spt   hand  w.order              colors
% %   |     |     |    |      |    |
% %                                     1 2    3 4 5 6 7 8 9 10 11 12            
%     2	  4     3    1   	1	 1    0 0    1 2 0 0 0 0 0 0   0 0; ...
%     2	  4     5    2   	1	 1    0 0    0 2 1 0 0 0 0 0   0 0; ...
%     2	  5     4    1   	1	 1    0 0    0 1 2 0 0 0 0 0   0 0; ...
%     2	  5     6    2   	1	 1    0 0    0 0 2 1 0 0 0 0   0 0; ...    
%     2	  6     5    1   	1	 1    0 0    0 0 1 2 0 0 0 0   0 0; ...
%     2	  6     7    2   	1	 1    0 0    0 0 0 2 1 0 0 0   0 0; ...        
%     2	  7     6    1   	1	 1    0 0    0 0 0 1 2 0 0 0   0 0; ...
%     2	  7     8    2   	1	 1    0 0    0 0 0 0 2 1 0 0   0 0; ...    
%     2	  8     7    1   	1	 1    0 0    0 0 0 0 1 2 0 0   0 0; ...
%     2	  8     9    2   	1	 1    0 0    0 0 0 0 0 2 1 0   0 0; ...
%     2	  9     8    1   	1	 1    0 0    0 0 0 0 0 1 2 0   0 0; ...
%     2	  9    10    2   	1	 1    0 0    0 0 0 0 0 0 2 1   0 0; ...
% 
% % Same displays as (A) but with only the target item visible. In these trials
% % with trialType == 3, the experimental script changes everything but the target
% % item to the background color. 
% % type   tgt   ref  spt   hand  w.order              colors
% %   |     |     |    |      |    |
% %                                    1 2    3 4 5 6 7 8 9 10 11 12          
%     3	  4     3    2   	1	 1   0 0    1 2 0 0 0 0 0 0   0 0; ...
%     3	  4     5    1   	1	 1   0 0    0 2 1 0 0 0 0 0   0 0; ...
%     3	  5     4    2   	1	 1   0 0    0 1 2 0 0 0 0 0   0 0; ...
%     3	  5     6    1   	1	 1   0 0    0 0 2 1 0 0 0 0   0 0; ...    
%     3	  6     5    2   	1	 1   0 0    0 0 1 2 0 0 0 0   0 0; ...
%     3	  6     7    1   	1	 1   0 0    0 0 0 2 1 0 0 0   0 0; ...        
%     3	  7     6    2   	1	 1   0 0    0 0 0 1 2 0 0 0   0 0; ...
%     3	  7     8    1   	1	 1   0 0    0 0 0 0 2 1 0 0   0 0; ...    
%     3	  8     7    2   	1	 1   0 0    0 0 0 0 1 2 0 0   0 0; ...
%     3	  8     9    1   	1	 1   0 0    0 0 0 0 0 2 1 0   0 0; ...
%     3	  9     8    2   	1	 1   0 0    0 0 0 0 0 1 2 0   0 0; ...
%     3	  9    10    1   	1	 1   0 0    0 0 0 0 0 0 2 1   0 0; ...
% 
% % (A) distance 1 (ref/tgt adjacent), 12 items, inner 8 can be ref, inner 6 can
% % be target.                
% % type   tgt   ref  spt   hand  w.order              colors
% %   |     |     |    |      |    |
% %                                    1 2    3 4 5 6 7 8 9 10 11 12           
%     4	  4     3    2   	1	1    0 0    1 2 0 0 0 0 0 0   0 0; ...
%     4     4     5    1   	1	1    0 0    0 2 1 0 0 0 0 0   0 0; ...
%     4	  5     4    2   	1	1    0 0    0 1 2 0 0 0 0 0   0 0; ...
%     4     5     6    1   	1	1    0 0    0 0 2 1 0 0 0 0   0 0; ...    
%     4	  6     5    2   	1	1    0 0    0 0 1 2 0 0 0 0   0 0; ...
%     4	  6     7    1   	1	1    0 0    0 0 0 2 1 0 0 0   0 0; ...        
%     4	  7     6    2   	1	1    0 0    0 0 0 1 2 0 0 0   0 0; ...
%     4	  7     8    1   	1	1    0 0    0 0 0 0 2 1 0 0   0 0; ...    
%     4	  8     7    2   	1	1    0 0    0 0 0 0 1 2 0 0   0 0; ...
%     4	  8     9    1   	1	1    0 0    0 0 0 0 0 2 1 0   0 0; ...
%     4	  9     8    2   	1	1    0 0    0 0 0 0 0 1 2 0   0 0; ...
%     4	  9    10    1   	1	1    0 0    0 0 0 0 0 0 2 1   0 0]; 
% 
% 
% % all of the above trials with reversed word order (2); concatenate to above
% order1_tmp = trials;
% order1_tmp(:,6) = 2;
% trials = [trials ; order1_tmp];
% 
% % all of the above trials as left hand trials; concatenate
% leftHand_tmp = trials;
% leftHand_tmp(:,5) = 2;
% trials = [trials ; leftHand_tmp];
% 
% 
% repetitions = 2; % number of repetitions of the block specified above

% END OF MAIN TRIALS-------------------------------------------------------





%% START OF ADJUSTMENT TRIALS----------------------------------------------
% trials = [...     
% 
% % (A) distance 1 (ref/tgt adjacent), 12 items, inner 8 can be ref, inner 6 can
% % be target.                
% % type   tgt   ref  spt   hand  w.order              colors
% %   |     |     |    |      |    |
% %                                     1 2    3 4 5 6 7 8 9 10 11 12       
%     1	  4     3    2   	1    1	  0 0    1 2 0 0 0 0 0 0   0 0; ...
%     1	  4     5    1   	1	 2    0 0    0 2 1 0 0 0 0 0   0 0; ...
%     1	  5     4    2   	1	 1    0 0    0 1 2 0 0 0 0 0   0 0; ...
%     1	  5     6    1   	1	 2    0 0    0 0 2 1 0 0 0 0   0 0; ...    
%     1	  6     5    2   	1	 1    0 0    0 0 1 2 0 0 0 0   0 0; ...
%     1	  6     7    1   	1	 2    0 0    0 0 0 2 1 0 0 0   0 0; ...        
%     1	  7     6    2   	1	 1    0 0    0 0 0 1 2 0 0 0   0 0; ...
%     1	  7     8    1   	1	 2    0 0    0 0 0 0 2 1 0 0   0 0; ...    
%     1	  8     7    2   	1	 1    0 0    0 0 0 0 1 2 0 0   0 0; ...
%     1	  8     9    1   	1	 2    0 0    0 0 0 0 0 2 1 0   0 0; ...
%     1	  9     8    2   	1	 1    0 0    0 0 0 0 0 1 2 0   0 0; ...
%     1	  9    10    1   	1	 2    0 0    0 0 0 0 0 0 2 1   0 0; ...
% % same as above, but other hand   
%     1	  4     3    2   	2    1	  0 0    1 2 0 0 0 0 0 0   0 0; ...
%     1	  4     5    1   	2	 2    0 0    0 2 1 0 0 0 0 0   0 0; ...
%     1	  5     4    2   	2	 1    0 0    0 1 2 0 0 0 0 0   0 0; ...
%     1	  5     6    1   	2	 2    0 0    0 0 2 1 0 0 0 0   0 0; ...    
%     1	  6     5    2   	2	 1    0 0    0 0 1 2 0 0 0 0   0 0; ...
%     1	  6     7    1   	2	 2    0 0    0 0 0 2 1 0 0 0   0 0; ...        
%     1	  7     6    2   	2	 1    0 0    0 0 0 1 2 0 0 0   0 0; ...
%     1	  7     8    1   	2	 2    0 0    0 0 0 0 2 1 0 0   0 0; ...    
%     1	  8     7    2   	2	 1    0 0    0 0 0 0 1 2 0 0   0 0; ...
%     1	  8     9    1   	2	 2    0 0    0 0 0 0 0 2 1 0   0 0; ...
%     1	  9     8    2   	2	 1    0 0    0 0 0 0 0 1 2 0   0 0; ...
%     1	  9    10    1   	2	 2    0 0    0 0 0 0 0 0 2 1   0 0; ...
%      
% % Same displays as (A) but as catch trials (trial type = 2 and reversed
% % (i.e., wrong) spatial terms).
% % type   tgt   ref  spt   hand  w.order              colors
% %   |     |     |    |      |    |
% %                                     1 2    3 4 5 6 7 8 9 10 11 12            
%     2	  4     3    1   	1	 1    0 0    1 2 0 0 0 0 0 0   0 0; ...
%     2	  4     5    2   	1	 2    0 0    0 2 1 0 0 0 0 0   0 0; ...
%     2	  5     4    1   	1	 1    0 0    0 1 2 0 0 0 0 0   0 0; ...
%     2	  5     6    2   	1	 2    0 0    0 0 2 1 0 0 0 0   0 0; ...    
%     2	  6     5    1   	1	 1    0 0    0 0 1 2 0 0 0 0   0 0; ...
%     2	  6     7    2   	1	 2    0 0    0 0 0 2 1 0 0 0   0 0; ...        
%     2	  7     6    1   	1	 1    0 0    0 0 0 1 2 0 0 0   0 0; ...
%     2	  7     8    2   	1	 2    0 0    0 0 0 0 2 1 0 0   0 0; ...    
%     2	  8     7    1   	1	 1    0 0    0 0 0 0 1 2 0 0   0 0; ...
%     2	  8     9    2   	1	 2    0 0    0 0 0 0 0 2 1 0   0 0; ...
%     2	  9     8    1   	1	 1    0 0    0 0 0 0 0 1 2 0   0 0; ...
%     2	  9    10    2   	1	 2    0 0    0 0 0 0 0 0 2 1   0 0; ...
%  % same as above, but other hand      
%     2	  4     3    1   	2	 1    0 0    1 2 0 0 0 0 0 0   0 0; ...
%     2	  4     5    2   	2	 2    0 0    0 2 1 0 0 0 0 0   0 0; ...
%     2	  5     4    1   	2	 1    0 0    0 1 2 0 0 0 0 0   0 0; ...
%     2	  5     6    2   	2	 2    0 0    0 0 2 1 0 0 0 0   0 0; ...    
%     2	  6     5    1   	2	 1    0 0    0 0 1 2 0 0 0 0   0 0; ...
%     2	  6     7    2   	2	 2    0 0    0 0 0 2 1 0 0 0   0 0; ...        
%     2	  7     6    1   	2	 1    0 0    0 0 0 1 2 0 0 0   0 0; ...
%     2	  7     8    2   	2	 2    0 0    0 0 0 0 2 1 0 0   0 0; ...    
%     2	  8     7    1   	2	 1    0 0    0 0 0 0 1 2 0 0   0 0; ...
%     2	  8     9    2   	2	 2    0 0    0 0 0 0 0 2 1 0   0 0; ...
%     2	  9     8    1   	2	 1    0 0    0 0 0 0 0 1 2 0   0 0; ...
%     2	  9    10    2   	2	 2    0 0    0 0 0 0 0 0 2 1   0 0; ...
% 
% % Same displays as (A) but with only the target item visible. In these trials
% % with trialType == 3, the experimental script changes everything but the target
% % item to the background color. 
% % type   tgt   ref  spt   hand  w.order              colors
% %   |     |     |    |      |    |
% %                                    1 2    3 4 5 6 7 8 9 10 11 12          
% %    3	  4     3    2   	1	 1   0 0    1 2 0 0 0 0 0 0   0 0; ...
% %    3	  4     5    1   	1	 1   0 0    0 2 1 0 0 0 0 0   0 0; ...
%     3	  5     4    2   	2	 1   0 0    0 1 2 0 0 0 0 0   0 0; ...
%     3	  5     6    1   	1	 2   0 0    0 0 2 1 0 0 0 0   0 0; ...    
% %    3	  6     5    2   	1	 1   0 0    0 0 1 2 0 0 0 0   0 0; ...
% %    3	  6     7    1   	1	 1   0 0    0 0 0 2 1 0 0 0   0 0; ...        
%     3	  7     6    2   	1	 1   0 0    0 0 0 1 2 0 0 0   0 0; ...
%     3	  7     8    1   	2	 2   0 0    0 0 0 0 2 1 0 0   0 0; ...    
% %    3	  8     7    2   	1	 1   0 0    0 0 0 0 1 2 0 0   0 0; ...
% %    3	  8     9    1   	1	 1   0 0    0 0 0 0 0 2 1 0   0 0; ...
%     3	  9     8    2   	2	 1   0 0    0 0 0 0 0 1 2 0   0 0; ...
%     3	  9    10    1   	1	 2   0 0    0 0 0 0 0 0 2 1   0 0; ...
% 
% % (A) distance 1 (ref/tgt adjacent), 12 items, inner 8 can be ref, inner 6 can
% % be target.                
% % type   tgt   ref  spt   hand  w.order              colors
% %   |     |     |    |      |    |
% %                                    1 2    3 4 5 6 7 8 9 10 11 12           
%     4	  4     3    2   	1	 1    0 0    1 2 0 0 0 0 0 0   0 0; ...
%     4     4     5    1   	2	 2    0 0    0 2 1 0 0 0 0 0   0 0; ...
% %    4	  5     4    2   	1	 1    0 0    0 1 2 0 0 0 0 0   0 0; ...
% %    4     5     6    1   	1	 1    0 0    0 0 2 1 0 0 0 0   0 0; ...    
%     4	  6     5    2   	2	 1    0 0    0 0 1 2 0 0 0 0   0 0; ...
%     4	  6     7    1   	1	 2    0 0    0 0 0 2 1 0 0 0   0 0; ...        
% %    4	  7     6    2   	1	 1    0 0    0 0 0 1 2 0 0 0   0 0; ...
% %    4	  7     8    1   	1	 1    0 0    0 0 0 0 2 1 0 0   0 0; ...    
%     4	  8     7    2   	1	 1    0 0    0 0 0 0 1 2 0 0   0 0; ...
%     4	  8     9    1   	2	 2    0 0    0 0 0 0 0 2 1 0   0 0];
% %    4	  9     8    2   	1	 1    0 0    0 0 0 0 0 1 2 0   0 0; ...
% %    4	  9    10    1   	1	 1    0 0    0 0 0 0 0 0 2 1   0 0]; 
% 
% repetitions = 1; % number of repetitions of the block specified above

% END OF ADJUSTMENT TRIALS-------------------------------------------------






%% START OF PRACTICE TRIALS------------------------------------------------
trials = [...     

% (A) distance 1 (ref/tgt adjacent), 12 items, inner 8 can be ref, inner 6 can
% be target.                
% type   tgt   ref  spt   hand  w.order              colors
%   |     |     |    |      |    |
%                                     1 2    3 4 5 6 7 8 9 10 11 12       
    1	  4     3    2   	2    1	  0 0    1 2 0 0 0 0 0 0   0 0; ...      
    1	  7     6    2   	1	 2    0 0    0 0 0 1 2 0 0 0   0 0; ...
    1	  9     8    2   	2	 1    0 0    0 0 0 0 0 1 2 0   0 0; ...
     
% Same displays as (A) but as catch trials (trial type = 2 and reversed
% (i.e., wrong) spatial terms).
% type   tgt   ref  spt   hand  w.order              colors
%   |     |     |    |      |    |
%                                     1 2    3 4 5 6 7 8 9 10 11 12            

    2	  5     4    1   	1	 2    0 0    0 1 2 0 0 0 0 0   0 0; ...
    2	  8     7    1   	2	 1    0 0    0 0 0 0 1 2 0 0   0 0; ...
    2	  8     9    2   	1	 2    0 0    0 0 0 0 0 2 1 0   0 0; ...

% Same displays as (A) but with only the target item visible. In these trials
% with trialType == 3, the experimental script changes everything but the target
% item to the background color. 
% type   tgt   ref  spt   hand  w.order              colors
%   |     |     |    |      |    |
%                                    1 2    3 4 5 6 7 8 9 10 11 12          
    
    3	  7     6    2   	1	 1   0 0    0 0 0 1 2 0 0 0   0 0; ...  
    3	  9    10    1   	2	 2   0 0    0 0 0 0 0 0 2 1   0 0; ...

% (A) distance 1 (ref/tgt adjacent), 12 items, inner 8 can be ref, inner 6 can
% be target.                
% type   tgt   ref  spt   hand  w.order              colors
%   |     |     |    |      |    |
%                                    1 2    3 4 5 6 7 8 9 10 11 12           
    4	  4     3    2   	1	 1    0 0    1 2 0 0 0 0 0 0   0 0; ...
    4	  8     7    2   	2	 2    0 0    0 0 0 0 1 2 0 0   0 0];



repetitions = 1; % number of repetitions of the block specified above

% END OF PRACTICE TRIALS-------------------------------------------------






%% general settings



numColors = 4; % number of possible colors in array
numItems = 12; % number of items in each array



%% List generation



% -------------------------------------
% replicate and concatenate to achieve desired total number of trials
% note: since this happens here already, trials with the same basic
% configuration will use different colors (which balances color usage
% better!)
trials = repmat(trials,repetitions,1);


for i = 1:size(trials,1)
    
    % Get color-columns from trials matrix (same number = same color)
    temp_in = trials(i,(triallistCols.colorsStart:triallistCols.colorsEnd)-1);
    % prepare output matrix
    temp_out = zeros(size(temp_in));
    
    % shuffle colorset
    colorset = Shuffle(1:numColors);
                       
    % First cycle through elements not labeled zero (i.e., ref & tgt)
    
    % cycle through number of used colors or size of color set (whichever
    % is higher); replace the range of color columns in the matrix 'trials'
    % with new numbers, i.e., exchange the numbers that signify which
    % items should be colored alike with numbers that correspond to actual
    % color values (which in turn are set in the experimental script's
    % settings)    
    % Note that there must be at least one zero in the color columns for
    % the following to work.
    for j = 0:max(numel(unique(temp_in))-1,numColors)
        
        curNo = (numel(unique(temp_in))-1)-j; % "reverse" j, to start from above
                                              % and only in the ende getting to zero 
                                              % so that the remaining
                                              % colors can be used.
        
        if curNo ~= 0 % "non-zero items"           

            % ...then use the first of them for all items labeled curNo
            temp_out(temp_in == curNo) = colorset(1);
            % ...and delete that color from the set
            colorset(1) = [];
            
        elseif curNo == 0 % only zero items left --> assign remaining colors randomly 
                          % with the constraint that the remaining set of
                          % colors is cycled through before reusing a
                          % color (so as to balance color usage as far as possible). 
            
            zeroItemsInd = find(temp_in==0);                        
            
            for k = 1:numel(zeroItemsInd) % for each zero item                                                
                
                colorsetExpanded = repmat(colorset,1,ceil(numel(zeroItemsInd)/numel(colorset)));
                colorsetExpanded = colorsetExpanded(randperm(numel(colorsetExpanded)));
                colorsetExpanded = colorsetExpanded(1:numel(zeroItemsInd));
                temp_out(zeroItemsInd) = colorsetExpanded;                                                
                
            end
            
        end
        
    end
    
    % replace range of color columns in matrix 'trials' with temp_out    
    trials(i,(triallistCols.colorsStart:triallistCols.colorsEnd)-1) = temp_out;
    
end


% add trial numbers (IDs) as first column
trials = [(1:size(trials,1))',trials];





