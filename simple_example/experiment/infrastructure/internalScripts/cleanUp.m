%%% Clean up

sca % close windows and show cursor.

% Remove subdirectories from MATLAB path (were added temporarily at start)
for p = pathsAdded
    rmpath(p{1})
end