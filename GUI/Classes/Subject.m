classdef Subject
    %subject
    
    properties
        % set at initialization
        dirName
        naviListboxLabel
        metadataHistory
        
        % set by metadata entry        
        subjectId % person ID, dog name        
        subjectNumber                
        notes
    end
    
    
    methods
        
        
        function subject = createDirectories(subject, toTrialPath, projectPath)
            subjectDirectory = createDirName(SubjectNamingConventions.DIR_PREFIX, subject.subjectNumber, subject.subjectId, SubjectNamingConventions.DIR_NUM_DIGITS);
            
            createObjectDirectories(projectPath, toTrialPath, subjectDirectory);
                        
            subject.dirName = subjectDirectory;
        end
        
        
        function [] = saveMetadata(subject, toSubjectPath, projectPath, saveToBackup)
            saveObjectMetadata(subject, projectPath, toSubjectPath, SubjectNamingConventions.METADATA_FILENAME, saveToBackup);            
        end
        
        
        function [subjectIdString, subjectNumberString, subjectNotesString] = getSubjectMetadataString(subject)            
            subjectIdString = ['Subject ID: ', subject.subjectId];
            subjectNumberString = ['Subject Number: ', num2str(subject.subjectNumber)];
            subjectNotesString = ['Notes: ', subject.notes];
        end
        
        
        function subject = importLegacyData(subject, toSubjectPath, legacySubjectImportPath, localProjectPath, dataFilename, userName, subjectType)
            % keep looping through importing locations for the subject
            counter = 1;
            
            while true
                
                if counter ~= 1
                    prompt = 'Would you like to import another location?';
                    title = 'Import Next Location';
                    yes = 'Yes';
                    no = 'No';
                    default = yes;
                    
                    response = questdlg(prompt, title, yes, no, default);
                    
                    if strcmp(response, no)
                        break;
                    end
                end
                
                [cancel, rawDataPath, registeredDataPath, positiveAreaPath, negativeAreaPath] = selectLegacyDataPaths(legacySubjectImportPath);
                
                % TODO: could add a path validation here
                
                if ~cancel && (~isempty(rawDataPath) || ~isempty(registeredDataPath) || ~isempty(positiveAreaPath) || ~isempty(negativeAreaPath))
                    paths = {rawDataPath, registeredDataPath, positiveAreaPath, negativeAreaPath};
                    
                    displayImportPath = ''; % we need a path to display to the user on the metadata entry GUIs just to remind them what's going on
                    
                    for i=1:length(paths)
                        if ~isempty(paths{i})
                            displayImportPath = paths{i};
                        end
                    end
                    
                    legacyImportPaths = struct('rawDataPath', rawDataPath, 'registeredDataPath', registeredDataPath, 'positiveAreaPath', positiveAreaPath, 'negativeAreaPath', negativeAreaPath);
                    
                    subject = subject.importLegacyDataTypeSpecific(toSubjectPath, legacyImportPaths, displayImportPath, localProjectPath, dataFilename, userName, subjectType);
                    
                    counter = counter + 1;
                end
            end
        end
        
        
    end
    
end

