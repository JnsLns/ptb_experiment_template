
 


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%% I AM HERE... 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%





% TODO:
% - might have to initialize e.results first in case it is not initialized
% to table before (does that happen anywhere? preparations?)
% - append content of fields of struct out to table e.results as a new
% row.
% - keep in mind that current trial row from 'trials' should be part of the
% new results row as well.
% - Does the below prototype take care of sorting everything correctly,
% also with the trial data appended? Does it work?
% - what about boolean data type in table? what about table? seems to work,
% but correctly??


if curTrial == 3
   sca
   ShowCursor();
   a = 1;
end
    

% initialize results table
if ~isfield(e, 'results')
    e.results = table();
end

% working prototype... must be tested more :
newResultsRow = struct2table(out, 'AsArray', true);
newResultsRow = [newResultsRow, trials(curTrial,:)];
e.results = forceAppendTable(e.results, newResultsRow);



 % THIS IS OLD AND PROBABLY NOT NEEDED ANYMOE

% %%%% Store results in e.results
% 
% % write from fields of struct 'out' to new results row
% for fName = fieldnames(out)'
%     f = fName{1};               
%     newResRow(e.s.resCols.(f)) = out.(f);    
% end
% 
% % write from current trial row to new results row
% for fName = fieldnames(triallistCols)'
%     f = fName{1};
%     newResRow(e.s.resCols.(f)) = trials(curTrial, triallistCols.(f));   
% end
% 
% % append row to results matrix
% e.results(end+1, :) = newResRow;
