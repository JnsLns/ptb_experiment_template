**Usage: Create a new project in your github by pressing the "Use this template" button for each new experiment you implement. This will shield experimental code from being updated, making sure the experiment can be re-run in the exact same form any time.**


*Note: I recently made huge changes to the code base. Since then, the docs are in disarray. They will be cleaned up in the next days. However, in addition to this documentation, each modifiable code file itself contains relatively detailed instructions on how to use it, and that should be OK already.*



# TODO
- mouse stuff documentation... new anonymous function getMouseRM...
- Motion tracking input 
- take a look at readme.md in simple_example/experiment and incorporate 
  useful stuff here. 
- coordinate converter
- i changed folder structure (did I change it or only add a folder? at least helperClasses added... also renamed settings to basicSetting.m. also added results folder)
- state where files are loaded from by default and where they are stored... (or leave that to docs in basicSettings)

## Debug capabilities

There are a few debugging capabilities that are particularly useful when dealing with the notoriously unwieldly Psychtoolbox windows – due to which many a good codesmen have been lost in the abyss of the task manager. In other words, these features take care of closing the windows and reopening them after debugging (as well as re-drawing any graphics).

```breakToDebug;``` can be included in any file after ```runExperiment```. It will close PTB windows and return to the MATLAB prompt without terminating the experiment function. Execution can be resumed as with any break point (F5). 

```debugOnError``` is a setting optionally defined in ```basicSettings.m```. If defined and ```true```, any error in the experimental scripts will invoke ```breakToDebug```, thus allowing to inspect the function workspace before terminating.

Finally, the message box invoked by pausing the experiment manually (hold pause key at the start of a trial) has an option which allows to go to the prompt for debugging.
	

## resumeExperiment() — completing an interrupted session

Say your triallist has 1000 trials, but the computer crashes after 800 (yes, it happens :). Fortunately, the experimental script routinely saves and updates a preliminary result file, in the selected save folder. That file is replaced by the final file upon experiment completion, but stays around if the experiment gets interrupted. It will be named something like ```bliblablu_myExperiment.mat.incomplete```. To run the remaining trials, execute ```resumeExperiment```. It will ask for an incomplete file instead of a trial file, and simply finish the remaining trial list exactly as if the interruption never happened. Should there be another interruption during the new session, no problem, the ```*.incomplete``` file will hold the new trials as well and you can resume from there again. Upon completion of the experiment, the final result file will be created as usual and the incomplete file is automatically deleted. Note though that a backup of the incomplete file is made in the same folder, to ensure that data is never lost. That backup file can be deleted manually.

Note that values set in struct 'e.s' within ```basicSettings.m```, ```s1_customSettings``` or later override what is stored in the loaded file (and what will be saved). This is intended behavior, as it allows to finish an incomplete session on different hardware and therefore different settings. However, if you have to do this, be wary about using ```e.s.convert``` during later analysis to convert units, as ```e.s.convert``` stored in the final result file will be based on the *new* settings, and might thus not be valid for the older batch of trials. The best workaround for this is to routinely do all necessary conversions already when recording results during the experiment. 

## Which files should I edit?
Here's the main directory and file structure with folders and files marked that you should edit. All others should not be modified. In summary, files in folders starting with ```my``` can be modified. In addition, you need to adjust values in ```builtInSettings.m``` to your hardware setup and finally write some code for trial list generation in ```trialGeneration.m```. Files in ```/experiment/infrastructure/``` should not be changed (but can be called in your own code as described later).
```
.
+-- experiment
|	+-- infrastructure
|	+-- myCustomFiles             <-- store any custom files here
|	+-- myParadigmDefinition      <-- add code in existing files
|	+-- myTrialFiles 	      	  <-- put trial files here (*.mat)
|	basicSettings.m 		      <-- only adjust values, dont modify code
|	runExperiment.m 			  
|   resumeExperiment.m
|
+-- trialGeneration 		      
	trialGeneration.m             <-- add code that generates trial file
```


## Execution order of script files

The experiment is started by running ```runExperiment``` or ```resumeExperiment```. Experiment files are then executed in the order listed below (the last block of files is located in ```/myParadigmDefinition```) . 
```
basicSettings.m
s1_customSettings.m
s2_defineOffscreenWindows.m
s3_drawStaticGraphics.m
s4_presentInstructions.m
	s5a_blockBreak.m                |
	s5b_drawChangingGraphics.m      | loop (one iteration per trial)
	s5c_presentTrial.m              |
s6_presentGoodbye.m
```
Additional scripts are executed in between under the hood, but this need not bother us. If you really must, look at ```/experiment/infrastructure/internalScripts/callExpComponentsInOrder.m``` to see the full program structure.

## What does each file do?

Not much, until you put some code in. In other words, all files in ```/experiment/myParadigmDefinition/``` are empty at first, save for instructions on what kind of code you should write in each file. Here's an overview:

```
settings.m
```
**It is vitally important to set up this file correctly!** It's a bunch of settings needed for every experiment that is based on this code, mostly hardware-related things. More specifically, this contains settings that you might have to change halfway through participants, say because you move over to a different computer (think screen size and such). 

```
runExperiment.m                      
```
Don't modify this, just use it to start the experiment. The code takes care of adding the subdirectories of ```/experiment/``` to the MATLAB path for the duration of the experiment.

```
s1_customSettings.m
```
Similar to ```settings.m```, but for additional settings required in your own, custom experiment, such as properties of some piece of special hardware. 

<details>
<summary>
Click for details.
</summary>
The idea is to put only things here that you might have to adjust at some point. Do **not** put settings here that are vital to be consistent over participants (e.g., presentation times); these should be fixed in the trial file.
</details>

```
s2_defineOffscreenWindows.m
```
Open as many offscreen windows as you need. Drawing graphics to them happens later, though.

<details>
<summary>
Click for details.
</summary>
Psychtoolbox uses the concept of offscreen windows. Each window is basically a canvas onto which you can draw something but without showing it on the screen yet. Only when you want to display it on the screen, you copy the offscreen window to the "onscreen window". Drawing in advance can improve presentation timing later.
</details>

```
s3_drawStaticGraphics.m
```
Draw graphics to the prepared offscreen windows. This file is for drawing graphics that do not change over trials, such as a fixation cross. 
```
s4_presentInstructions.m
```
Do anything you like before the experiment starts. Typically used to display instructional text or other things that the participant needs to see beforehand. 
```
s5a_blockBreak.m                
```
This file is part of the trial-loop. It is potentially executed once at the outset of each trial. However, this particular file is executed only when block number changes (and some other conditions are met, see details). Typically used to implement breaks for the participant. 

<details>
<summary>
Click for details.
</summary>
	
The code in this file is executed at the outset of the trial loop if all of the following conditions are met:

- ```e.s.useTrialBlocks``` is true. Set it as ```tg.s.useTrialBlocks``` in ```trialGeneration.m```. This setting determines whether trials are organized into blocks. If enabled, each trial must have a trial number in ```tg.triallist.block```.
- The block number of the current trial is different from that of the previous trial.
- The number of the current trial's block was included in ```tg.s.breakBeforeBlockNumbers```. If ```tg.s.breakBeforeBlockNumbers``` was not specified, the default is to run ```s5a_blockBreak.m``` before each block except the first one.  

</details>

```
s5b_drawChangingGraphics.m      
```
This file is part of the trial-loop. It is executed onceon each trial. [TODO]
```
s5c_presentTrial.m              
```
This file is part of the trial-loop. It is executed onceon each trial. [TODO]
```
s6_presentGoodbye.m
```
Do anything you like before the experiment ends. Typically used to display a goodbye message or gather post-experiment questionnaire data . 

# Built-in functionality
Note that all folders in ```/experiment``` are added to the MATLAB path when the experiment is run (so that all files and functions in there can be called from anywhere in the experimental code, including those in ```/experiment/myCustomFiles```). They are removed again once the experiment is complete (or crashes).

-ending a field in tg.s with color means that it will be converted :
%%% Convert color strings ('white, 'black', 'grey') in fields of 'e.s' whose
%   names end on 'Color' to PTB color lookup table index.
- State somewhere which variable can be assessed where under what name
	tg.triallist --> trials     after preparations.m, i.e. staring with

## Reserved field names for trial generation
## Reusable script snippets
## Helper functions
## Pre-existing variables



# Overview of how to implement an experiment
# Trial list generation
tg.s
tg.triallist


# Coordinate systems and units

## Presentation area

The presentation area is an imagined rectangle centered within the screen.
Its side lengths are set in degrees of visual angle during trial
generation, through 'tg.s.presArea_va'. For instance:

tg.s.presArea_va = [20, 10];    % [horizontal, vertical] 

It serves as a coordinate frame in which stimulus positions should be
defined during trial generation. The origin is at the bottom left
corner, the positive x-axis points to the right and the positive
y-axis points upward. Degrees of visual angle should be used as units.

Using the presentation area as coordinate frame means that stimuli
positions are defined relative to the screen center rather than in 
relation to screen borders, making stimulus positioning independent from
screen size. Thus, different screens can easily be used for the same 
experiment while keeping stimulus positions constant. The only thing
that needs to be adjusted when switching screens is the physical screen
size ('e.s.expScreenSize_mm' in generalSettings.m).

If the field 'presArea_va' is not defined during trial generation, the
default [0,0] will be used. This means that the coordinate origin for
stimulus definition will be in the screen center, which should be
convenient in most cases. 


# Rough trial generation overview

TODO HERE: Explain how target number and similar works with fields in 
 	       in triallistCols that contain row vectors (update that in 
 	       columnStructs)


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                               Overview                                  %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Here a trial file should be created that can be loaded by the experiment
% scripts. The trial file must contain a nested struct 'tg' (for "trial
% generation") with the following field-names and structure:
%
%  tg
%  tg.triallist    <- table in which each row corresponds to one trial
%  tg.s.someField      <- sub-fields hold paradigmn-level setting
					      custom fields for paradigm-level settings
%                         (there are some reserved field names with
%                         prespecified functionality, described below)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                       Steps in creating a trial-file                    %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% TODO: ADJUST TO TABLE USAGE

% 1) Create a list of trials and store it in 'tg.triallist'.
%
%         For instance, define a list of two trials. Rows are trials and
%         columns are trial properties. Say we want to draw three dots in
%         each trial and we want to vary dot color and horizontal placement
%         between trials. Also, one item is the target item. Finally, each
%         trial gets a unique ID:
% 
%         % trial 1
%         tg.triallist(1, 1) = 1;            % ID 1
%         tg.triallist(1, 2) = 2;            % use color 2
%         tg.triallist(1, 3:5) = [-2,0,1];   % horizontal positions 
%         tg.triallist(1, 6) = 2;            % dot 2 is the target
%
%         % trial 2
%         tg.triallist(2, 1) = 2;            % ID 2
%         tg.triallist(2, 2) = 1;            % use color 1
%         tg.triallist(2, 3:5) = [-5,0,5];   % horizontal positions
%         tg.triallist(2, 6) = 3;            % dot 3 is the target
%
% 2) Create a struct 'tg.s.triallistCols' whose fields indicate which
%    columns of the above trial list hold which trial property. (note that
%    you would usually do this step before step one)
%
%         tg.s.triallistCols.trialID = 1;       % let's call column 1 "trialID"
%         tg.s.triallistCols.color = 2;         % and column 2 "color"
%         tg.s.triallistCols.horzPos = [3,4,5]; % horizontal positions are in these columns
%         tg.s.triallistCols.target = 6;        % tgt number is given in 6 
%
% 3) Define any overarching settings your paradigm code requires and store
%    them in fields of 'tg.s'. 
%
%         For instance, let's define background color and a set of colors
%         that stimuli can be printed in (as RGB triplets). Also, make dot
%         radius a property.
%
%         tg.s.bgColor = [0 0 0];                % black 
%         tg.s.stimColors = {[1 0 0], [0 1 0]};  % red and green
%         tg.s.stimRadius = 1;                   
%
% 4) Save 'tg' to a mat-file (e.g., into /trialFiles) that you will later
%    load into the experiment script.


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%          Coordinate frame and units for stimulus specification          %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% My suggestion is to specify locations and sizes in degrees of visual
% angle and based on the "presentation area coordinate frame". By default,
% this frame has its origin in the screen center. The positive x-axis
% points to the right and the positive y-axis points upward. 
%
% This is different from what Psychtoolbox functions expect (pixel units,
% origin in upper left screen corner, top-down y-axis). However, in the 
% experiment scripts you can use the function paVaToPtbPx (located in
% '/helperFunctions/unitConversion') to easily convert from values in the
% presentation area frame (pa) and °visual angle (Va) to the Psychtoolbox
% frame (Ptb) in pixels (Px). The output of this function can be then be
% passed to the Psychtoolbox functions.  
%
% The advantage of using the presentation-area frame in trial specification
% is that experiments will be more easily portable, e.g., to different
% screens, and similar flexibility issues. Also, stimulus size in degrees
% of visual angle is what really matters in most vision-based experiments.
%
% However, it can be sensible to mix units in some cases, for instance, using
% degrees of visual angle for some values, and absolute distances (e.g., in
% millimeters) for others. For instance, when using motion tracking of hand
% position, hand starting distance from the screen would be specified in
% millimeters while stimulus positions on the screen would still be speci-
% fied in degrees of visual angle. 
% When mixing units, it is a good idea to disambiguate measures in the
% trial list by postfixing fields in 'tg.s.triallistCols' or 'tg.s' 
% accordingly. E.g., add "_va" for degrees visual angle and "_mm" for
% millimeters.
%
% Note that there are more functions to easily convert back and forth
% between the different units and coordinate frames in the folder
% '/helperFunctions/unitConversion'.


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%            Optional / reserved field names in struct 'tg.s'             %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% It is OPTIONAL to define any of these fields. The default behavior for
% those left undefined is indicated below. If a field IS defined, however,
% it should be used only for the intended functionality (in other words,
% don't use these field names for custom purposes or something might break).
%
% See Readme.md for detailed documentation of some of these fields. You
% should read it before using them.

% tg.s.experimentName = 'my_experiment'; % Will be appended to results file
%                                        % names. Default if undefined: ''                                       
% 
% tg.s.useTrialBlocks = true;            % Run 's5a_blockBreak.m' btw. blocks                                       
%                                        % Default if undefined: false. 
% 
% tg.s.shuffleTrialOrder = true;         % Shuffle trials (within blocks) at
%                                        % start of experiment. Default if
%                                        % undefined: false
% 
% tg.s.shuffleBlockOrder = true;         % Shuffle blocks at start of experi-
%                                        % ment. Default if undefined: false                                      
% 
% tg.s.presArea_va = [40, 30];           % [horizontal, vertical] extent of
%                                        % presentation area in degrees visual
%                                        % angle. Default if undefined: [0,0].            
%                                        
% tg.s.bgColor = 'grey';                 % Default background color for all
%                                        % Psychtoolbox windows; either an
%                                        % RGB triplet or one of the strings
%                                        % 'black', 'white', or 'grey'.
%                                        % Default if undefined: 'grey'
%                                        
% tg.s.onscreenWindowTextFont = 'Arial'; % Default font for onscreen window. 
%                                        % Default if undefined: 'Arial'
%                                           
% tg.s.onscreenWindowTextHeight_va = 0.75; % Default font height for onscreen 
%                                        % window [°visual angle]. Default if
%                                        % undefined: 0.75°                                
% 
% tg.s.desiredMouseScreenToDeskRatio = [1 1]; % Setting this will make avai-
%                                        % lable a function getMouseRM for
%                                        % code in folder paradigmDefinition.
%                                        % It is a wrapper for Psychtoolbox'
%                                        % getMouse() but allows setting
%                                        % mouse movement "speed". If this
%                                        % field exists, 
%                                        % e.s.rawMouseScreenToDeskRatio must
%                                        % be set in 'generalSettings.m'.


# Optional settings during trial generation

--- tg.s.useTrialBlocks

Boolean, default if undefined: false. If set to true, trials are blocked.
This allows implementing pauses for the participants or running other code
between blocks. In detail, if 'tg.s.useTrialBlocks' is true:

Each trial in 'tg.triallist' must be marked as belonging to one block. For
this, define 'tg.s.triallistCols.block' and assign to it the number of a
column of the trial list ('tg.triallist'). This column must contain integers
that identify the block number for each trial. Arbitrary integers may be
used but each block must have a unique number and all trials with the same
number must be in consecutive rows (else an error will be thrown).                                                                    

Any code in 's5a_blockBreak.m' (folder 'paradigmDefinition') will be
executed before each block but the first one. Optionally, this can be
further controlled by defining 'tg.s.breakBeforeBlockNumbers' and assigning
to it an array of block numbers. 's5a_blockBreak.m' will then be executed
only before the specified blocks (which may include the first one).

Trial shuffling will occur only within and not across blocks (see
'tg.s.shuffleTrialOrder'), that is, block order is preserved.

--- tg.s.shuffleTrialOrder
  
Boolean, default if undefined: false. If set to true, the order of trials
in the triallist will be shuffled at the outset of the experimental script,
so that each participant will see a different trial order. If blocks are
used (see 'tg.s.useTrialBlocks'), shuffling will occur only within blocks.     
                                          
--- tg.s.shuffleBlockOrder             
                                       
Boolean, default if undefined: false. If set to true, the order of blocks
in the triallist will be shuffled at the outset of the experimental script,
so that each participant will see a different block order. Obviously, this
only comes to effect if blocks are used (see 'tg.s.useTrialBlocks').






# Psychophysics experiment template using MATLAB & Psychtoolbox 3

This template is designed to speed up the development of psychophsics experiments
with MATLAB and Psychtoolbox 3. It handles some common aspects of experiment scripts,
such as loading a list of trials, reading data from it, presenting instructions, 
iterating over trials, generating and saving a matrix of results, and converting between 
different spatial reference frames and units (e.g., millimeters, degrees of visual angle,
and pixels).

What you still have to do is creating the list of trials as needed for your experiment
(you can do that in `trial_generation.m`), define experiment-specific settings, draw
your stimuli, and specify which variables should be stored in the result file (you can do
all of that in the files in the `experiment` folder; start with `main.m`).

The general idea is that you should usually only modify the files located
in the `experiment` and `trial_generation` top folders.  Functions and files in
the private and `common_functions` folders should not need to be touched, although 
it can't hurt to take a look at them since they might be useful for your experiment
as well. 

Note that there is also extensive documentation in the code files themselves. Also note that
there's a working example experiment packaged with the code which uses the template code
and should give a pretty good idea how to go about implementing your own experiment.

## Input to the experiment: Trial list and settings

When `main.m` is run, it asks for a trials file. It is generally up to you to 
construct this file, depending on your paradigm. It must however contain a struct
`tg`, which is expected to specify general settings for the experiment as well as
a list of trials and trial properties. There are some mandatory fields in this
struct, of which I explain the most important ones here. There are a few others, 
though, which are listed in `trial_generation.m`.

* `tg.s`, where 's' stands for 'settings'. Each of its sub-fields specifies one
setting. An example would be the maximum allowed response time `tg.s.allowedTgtResponseTime`.
This should only be settings that are relevant across trials.

* `tg.triallist`, which contains the trial list in the form of a matrix. Each row
corresponds to one trial, and each column to one trial property (such as trial ID,
condition, stimulus positions, etc.). Trials will be presented in that list order
(although it can be specified that trials that were aborted before completion 
for some reason should be redone later and shuffled into the remaining trial list,
which will modify this order).

* `tg.s.triallistCols`, a special sub-field of `tg.s` that allows to address the 
columns of `tg.triallist` "by name" instead of hard-coding column indices. See
explanation [here](#column-index-structs).

* `tg.s.presArea_va`, a two-element row vector that specifies the extent of the
presentation area (see next section) in degrees of visual angle.

#### Units

One concept used in the scripts is that of a "presentation area". This is a rectangular
area whose extent is specified during trial generation in `tg.s.presArea_va`
(in degrees visual angle). It will automatically be centered within the screen used
to present the experiment and its actual size (e.g., in millimeters) will depend 
on the viewing distance of the participant (which is specified at the outset of the
experimental script `main.m`). Thus, it will always be of the same size with respect
to visual angle, allowing to present the experiment on different screens and at 
different viewing distances.

For this to work, settings, positions and sizes of visual items specified during
trial generation should be given in degrees visual angle (as far as that makes sense)
and within a reference frame that is relative to the presentation area.
This frame's origin is located at the lower left corner of the "presentation area", a
rectangular region centered within the screen, x-axis increases rightward,
y-axis upward; see [below](#spatial-reference-frames-and-units) for more info on spatial
reference frames. When drawing things in the experimental script, use the conversion
functions in the `common_functions` folder to convert from that reference frame
to the frame used by Psychtoolbox.

#### Further notes on settings

Most experimental settings are defined already during trial
generation (in `tg.s`) rather than in the experimental script. The idea 
is to ensure that once trials have been generated and saved, experiment
settings cannot be modified accidentally halfway through participants.

The few things that are set in the experimental script itself (as well
stored in `e.s`) are specific properties of the hardware used or the spatial
arrangement, such as screen size or viewing distance of the participant.
Setting these in the experimental script allows things like switching to
a screen of a different size halfway through participants, since the actual
sizes of stimuli on the screen as well as other spatial values
are computed dynamically in the experimental script based on the
settings there, so that all distances and sizes will automatically
adhere to the desired visual angles specified in `tg.triallist`.

## Output of the experiment: Results matrix, custom data, and settings

The idea here is that the experiment script takes a trial list as input and
uses the information internally, but outputs only one self-contained struct
`e` in the saved file so that the trial list or file won't be needed for analysis
anymore. 

Struct `e` will hold all settings and results. It has the following (sub-)fields:

* `e.results`, a matrix where each row is one trial that was presented
(in presentation order) and columns are properties of the participant's
responses or trial properties. Note that incomplete trials that were 
aborted for some reason are stilll recorded in the matrix, so that the
final order is not necessarily identical to that of `tg.triallist`. Trial
properties in `e.results` are transferred from `tg.triallist`, though,
so that all required information is present and `tg.triallist` is not
needed anymore.

* `e.s.resCols` a special sub-field of `e.s` that allows to address the 
columns of `e.results` "by name" instead of hard-coding column indices.
See explanation [here](#column-index-structs). `e.s.resCols` is automatically
created based on the variables defined as output of the experiment (as described
[here](#specifying-which-variables-should-be-stored-in-the-results-matrix))

* `e.s`, a struct with various fields that hold __all__ non-trial-specific
settings used for the experiment. This includes copies of all fields from
`tg.s` (except `triallistCols`, which is integrated with `e.s.resCols` instead), 
so that `tg` is not needed for analysis.

* Additional custom-defined fields of `e`. If some data you want to store
does not fit the results matrix (`e.results`), you can store that data in
additional fields of `e` that you may create as needed. See documentation in
`storeCustomOutputData.m`.

## Specifying which variables should be stored in the results matrix

##### Short version

Everything written to fields of struct `out` during trials will
automatically be stored it in the results matrix (`e.results`). Add or remove
fields to/from `out` as needed, but assign only integers or column vectors.
Columns of the results matrix can later be addressed "by name" using
column indices in fields of `e.s.resCols`. 

##### Detailed version

An empty struct `out` is created/reset before each trial. Fields
can be created in this struct as needed during the trial (preferably
within `runTrial.m`). A column vector or an integer should be written
to each field (say, a response time). When the trial ends, the
objects stored in the fields of `out` will be transformed into a
row of results values and this row is written to the results
matrix (`e.results`).

Note that `e.s.resCols` (see [below](#column-index-structs)) is
automatically created based on the contents of `out`. The fields of
`e.s.resCols` are named after the fields that exist in `out` at the
end of a trial. 

If the value of a field of `out` is a column vector then its elements
will be written to the results matrix in consecutive columns and
`e.s.resCols` will have two fields for this object, one to address into the
first column of the span of columns, the other addressing into the last
one (so that together they can be used to retrieve the full span of values).
The two fields of `e.s.resCols` have the same name as the respective
field of `out` except for being postfixed with 'Start' and 'End', respectively.

It is possible to add fields to `out` that were not used in earlier trials,
in which case rows in `e.results` from preceding trials will be filled with
nans in these columns. Note however that once a field in `out` has been established,
the objects stored in it must be of the same size in each trial (pad with nans
if needed).


## Column-index structs

Column-index structs are used in multiple places in the code, in order
to be able to address into columns of often-used target matrices "by name"
instead of having to hard-code or remember what data is stored in which column.
Examples are `e.s.resCols` (for `e.results`) and `tg.s.triallistCols`
(for `tg.triallist`). __Note that in the experiment script you can refer to 
`tg.s.triallistCols` simply by `triallistCols`.__ Each column-index struct has
multiple fields, and each field holds an integer that refers to a column of the
target matrix. For instance: 

```matlab
>> e.s.resCols.responseCorrect

e.s.resCols.responseCorrect = 12  
                                  
>> % correctness is stored in column 12 of e.results,
>> % so we can get the correctness for the tenth trial
>> % like this:
>>
>> e.results(10, e.s.resCols.responseCorrect)

e.results(10, e.s.resCols.responseCorrect) = 1
````

Some field names of column-index structs are postfixed with 'Start' or
'End', such as `e.s.triallistCols.shapesStart` and `tg.s.triallistCols.shapesEnd`.
These refer to a span of columns in the matrix. Such spans can be addressed like this:

```matlab
>> tg.s.triallistCols.shapesStart

tg.s.triallistCols.shapesStart = 12  
                                  
>> tg.s.triallistCols.shapesEnd

tg.s.triallistCols.shapesEnd = 15

>> % Shapes seem to be stored in columns 12 to 15,
>> % so we can get all shape codes for tiral 10 like this:
>>
>> tg.triallist(10, tg.s.triallistCols.shapesStart:tg.s.triallistCols.shapesEnd)

tg.triallist(10, tg.s.triallistCols.shapesStart:tg.s.triallistCols.shapesEnd) = 
    1     2     3     4
````

If different such spans refer to similar entities (e.g., the horizontal
positions of stimuli and the vertical positions of stimuli), then the order
of entities within the span should be ensured to be identical in
all cases, so that different types of values can later be attributed to
the matching item more easily.


## Spatial reference frames and units

![spatial reference frames](doc_images/readme_spatial_setup.jpg)

#### Short version

All input and output to and from the experimental script should be in the
presentation-area-based frame and in degrees visual angle except for
settings that make sense only in millimeters (like physical screen
size; these are postfixed '\_mm') or pixels (like screen resolution;
postfixed '\_px'). When calling Psychtoolbox functions,
use conversion functions in `common_functions` to convert to the Psychtoolbox
frame.

#### Detailed version

There are two coordinate reference frames (CRF) relevant here (see figure above).
In most cases you really only need to think about the first one, as all positions
for drawing and similar things should be specified in that frame. The second one
is used by Psychtoolbox and only relevant when using Psychtoolbox functions. On top
of this, there are convenient conversion functions in the `common_functions` folder
that allow switching between frames easily.

* *__Presentation-area-based frame (pa):__* Should be used for all input to and
ideally also for output from the experimental script (although that is up to you)
, that is, in trial generation (struct `tg` loaded from trial file) and for
results output (`e.results`). The origin is at the bottom left of the presentation
area (rectangular area whose size is defined in `tg.presArea_va` and which is inset
in and centered within the screen), x-axis increases to the right, y-axis increases
upward. Units used in conjunction with this frame are degrees of visual angle (va),
except for a few settings that make sense only in millimeters or pixels; these
settings are clearly marked by the postfix '_mm' or '_px' in the fieldnames of `e.s`.

* *__Psychtoolbox frame (ptb):__* Used only in the internals of the experimental 
script and when drawing to Psychtoolbox-windows. The origin is at the top left of
the screen, x-axis increasing to the right, y-axis increasing downward. Units used
in conjunction with this frame are pixels. The Psychtoolbox drawing functions expect
data to be in this frame. Thus, when using Psychtoolbox functions, use conversion
functions (see next section) to convert any data to this frame first. Note that
Psychtoolbox output like mouse position from functions like `GetMouse` are also in
this frame. To map these back to other frames and/or units you can as well use
conversion functions.

#### Functions for CRF and unit conversion

The `common_functions` folder contains functions that allow converting between the
different reference frames, by passing the values to be converted 
plus the struct `e.s.spatialConfig` (which is created at the outset of the
experimental script and holds all relevant information about the spatial
setup, such as viewing distance, screen extent etc).

All of these functions follow the same naming scheme (see the individual
functions' documentations for more info). Naming examples:

* `paVaToPtbPx()`: convert from presentation-area-based frame (pa) in 
degrees visual angle (va) to Psychtoolbox frame (ptb) in pixels (px).

* `pxToMm()`: convert from pixels (px) to millimeters (mm).

Since `e.s.spatialConfig` is stored with the results data, these functions
can also be used during later analysis (so it does not restrict analysis if 
you initially save results data only in one frame).

#### Note: Visual angle conversion

The method to do calculations with visual angle used in the conversion functions is
slightly different from the standard way.

The method that most psychophysics people use to convert between visual angle and
sizes or distances on a flat screen is Method 1 in the figure below (where d is
viewing distance, s is stimulus size or distance, and theta is the visual angle in
degrees). With this method, stimulus sizes or distances depend on eccentricity, as
can be seen from the different lengths of the green lines in the figure. With this
method it is sometimes not clear when people provide stimulus sizes or distances
whether they computed them as if the stimulus was in the center of vision, or whether
they accounted for its eccentricity (which in most cases does not seem to be the case). 

In the code, I instead use Method 2, which computes size or distance s as the
length of the arc with radius d that corresponds to theta. As can be seen from
the red lines in the figure, there is a constant relationship between
angle and size with this method. I use this method instead of the standard one to
be able to use degrees of visual angle as units in the coordinate system in which stimuli
locations and sizes are defined. This works only if the relationship is constant.

Of course, the results of the two methods differ somewhat, and this difference
increases with the visual angle, eccentricity, or stimulus size at hand. However, for 
all practical stimulus sizes and distances that may occur in experiments that you would
implement using this code, this difference between the methods is negligibly small (which
may be one reason why people do not bother stating whether or not they accounted for
eccentricity). The bottom figure shows the difference for different values of visual angle,
to help decide whether the difference is relevant for your particular experiment.

![Visual angle conversion](doc_images/readme_visual_angle.jpg)

![Angle computation method difference](doc_images/readme_angle_method_comparison.jpg)







