
# Folder `reusableScripts`

These are scripts that are used internally in some places (__so do not modify them!__), but the may also be useful when implementing a new experiment and may be called in custom code. For instance, if you need to pause an experiment at a custom but prespecified point, say to do some re-calibration with some hardware, use `pauseAndResume.m` by simply including it in the respective code location (`pauseAndResume;`). 