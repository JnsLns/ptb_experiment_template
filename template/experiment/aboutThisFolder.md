
# Folder `experiment`

Holds all files that define your experiment.

**Note that only files should be added/modified to/in the following subfolders**

* `myTrialFiles` : should contain one or multiple mat-files holding a trial list created during trial generation.
* `myParadigmnDefinition` : contains multiple files in which you define your paradigm. These are called in order when the experiment is run.
* `myCustomFiles` : initially empty, meant to store any custom functions or script files that you need to call from the files in `myParadigmnDefinition`.

`basicSettings.m` holds important settings that you need to adjust to your hardware setup. However, do not remove or add code or variables there, just adjust the values.

`infrasturcture` contains, well, internally used infrastructure code that shouldn't be modified. But it can't hurt to take a look at it, since some functions there might be useful to you as well (especially the `CoordinateConverter` class).

`runExperiment.m` and `resumeExperiment.m` shouldn't be modified either - just run them to execute the experiment or finish an existing but incomplete results file, respectively.

