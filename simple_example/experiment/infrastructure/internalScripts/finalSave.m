if doSave            
    % save final result file
    save(savePath, 'e');    
    % remove temporary file
    delete(savePathIncomplete);    
end