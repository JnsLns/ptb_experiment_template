% save final result file and delete temporary one.

if doSave                    
    
    % remove any "incomplete" tags from end of file name    
    pat = '.incomplete';
    len = numel(pat);
    while 1
        [p,f,ext] = fileparts(savePath);
        if strcmp(ext, pat)
            savePath = savePath(1:end-len);
        else 
            break
        end
    end
    
    % Modify filename to prevent data from being overwritten if existing.
    c = 0;    
    
    while exist(savePath, 'file')
        c = c + 1;                
        savePath = fullfile(p,[f,'_',num2str(c),ext]);
    end
             
    save(savePath, 'e');    
          
    % remove temporary file
    delete(savePathIncomplete);    
    
end