# Example experiment using the template code

Jonas Lins, November 2019


## What's this ? 

This is an example experiment implementation based on the template code,
essentially a simplified version of the experiment described by
Hazeltine et al. (1997) in "If it's not there, where is it? Locating
illusory conjunctions", Journal of Experimental Psychology, 23(1), 263-277.

## How to run 

You may need to adjust 'e.s.expScreenSize_mm' and 'e.s.viewingDistance_mm'
in experimentSettings.m according to your screen and setup.

Then run runExperiment.m in the experiment root folder to start the experiment.


### Documentation from template code

## Files and directory structure

General note: All folders and subfolder in the experiment directoy are
added to the MATLAB path when running the experiment (and removed on exit),
so that all files can be inserted or called as functions in your own
experiment code.

### Experiment root folder
#### experimentSettings.m
Adjust the values there to your hardware setup. No other changes required.
#### runExperiment.m
Run this file to execute the experiment. Do not modify this file.

### Folder \paradigmDefinition
This is where the magic happens: All scripts in this folder can and should
be modified in order to implement your paradigm. Each file represents one
step in the course of the experiment. When the experiment is run, these
files are run in the order they are numbered (with scripts 5a to 5d being
executed repeatedly, once for each trial, before proceeding to number 6).
All of the scripts are empty by default, except for some documentation on
how to use them and what to write in them. See the list below for a quick
overview of each script's intended function.

Executed once before trials

s1_paradigmSpecificSettings   Define any settings your paradigm needs.
s2_defineOffscreenWindows.m   Define offscreen windows to be opened.
s3_drawStaticGraphics.m       Draw graphics that are static over trials.
s4_presentInstructions.m      Present pre-trial instructions.

Executed in a loop, once for each trial

s5a_blockBreak.m               Do things between trial blocks.
s5b_drawChangingGraphics.m     Draw graphics that change from trial to trial.
s5c_oneTrial.m                 Course of events in each experimental trial.
s5d_storeCustomOutputData.m    Save response data not fitting into the
                               default results list ('e.results').

Executed once when all trials are through:

s6_presentGoodbye.m               Code to be run when experiment ends.         

### Folder \helperFunctions
Various functions used somewhere in the internal experiment code. These
functions should usually not be modified. Most of them can however
be useful for implementing your own paradigm. Especially those in the 
unitConversion subdirectory are indispensable to convert between units and
coordinate reference frames. See the list of the most useful ones below. TODO

### Folder \internalExperimentScripts
Inner workings to make the experiment run. Best not modify these files.

### Folder \internalExperimentScripts

### Folder \trialFiles
Put files created in trial generation here.

(You can just as well put them
somewhere else, because they are loaded via a load dialog each time the
experiment is run. But this way they are kept close to the experiment 
script...)

### Folder \customFiles
Put any custom script files or functions for your paradigm here. You may
also create subdirectories to keep it tidy. The folder is added to the 
MATLAB path when the experiment is run (and removed afterwards), so you can
use all of these files in any experimental code you write.




