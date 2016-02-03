classdef Eye
    % Eye
    % metadata about an eye
        
    properties
        dirName
        
        eyeId
        eyeType % EyeTypes
        
        eyeNumber
        
        dissectionDate
        dissectionDoneBy
        
        quarters
        
        notes
    end
    
    methods
        function eye = loadEye(eye, toEyePath, eyeDir)
            eyePath = makePath(toEyePath, eyeDir);

            % load metadata
            vars = load(makePath(eyePath, EyeNamingConventions.METADATA_FILENAME), Constants.METADATA_VAR);
            eye = vars.metadata;

            % load dir name
            eye.dirName = eyeDir;
            
            % load quarters
            quarterDirs = getMetadataFolders(eyePath, QuarterNamingConventions.METADATA_FILENAME);
            
            numQuarters = length(quarterDirs);
            
            eye.quarters = createEmptyCellArray(Quarter, numQuarters);
            
            for i=1:numQuarters
                eye.quarters{i} = eye.quarters{i}.loadQuarter(eyePath, quarterDirs{i});
            end
        end
        
        function eye = importEye(eye, eyeProjectPath, eyeImportPath, projectPath, localPath, dataFilename)  
            dirList = getAllFolders(eyeImportPath);
            
            importQuarterNumbers = getNumbersFromFolderNames(dirList);
                            
            filenameSection = createFilenameSection(EyeNamingConventions.DATA_FILENAME_LABEL, num2str(eye.eyeNumber));
            dataFilename = strcat(dataFilename, filenameSection);
            
            for i=1:length(dirList)
                indices = findInArray(importQuarterNumbers{i}, eye.getQuarterNumbers());
                
                if isempty(indices) % new quarter
                    quarter = Quarter;
                    
                    quarter = quarter.enterMetadata(importQuarterNumbers{i});
                    
                    % make directory/metadata file
                    quarter = quarter.createDirectories(eyeProjectPath, projectPath, localPath);
                    
                    saveToBackup = true;
                    quarter.saveMetadata(makePath(eyeProjectPath, quarter.dirName), projectPath, localPath, saveToBackup);
                else % old quarter
                    quarter = eye.getQuarterByNumber(importQuarterNumbers{i});
                end
                
                quarterProjectPath = makePath(eyeProjectPath, quarter.dirName);
                quarterImportPath = makePath(eyeImportPath, dirList{i});
                
                quarter = quarter.importQuarter(quarterProjectPath, quarterImportPath, projectPath, localPath, dataFilename);
                
                eye = eye.updateQuarter(quarter);
            end
        end
        
        function eye = updateQuarter(eye, quarter)
            quarters = eye.quarters;
            numQuarters = length(quarters);
            updated = false;
            
            for i=1:numQuarters
                if quarters{i}.quarterNumber == quarter.quarterNumber
                    eye.quarters{i} = quarter;
                    updated = true;
                    break;
                end
            end
            
            if ~updated
                eye.quarters{numQuarters + 1} = quarter;
            end            
        end
        
        function quarter = getQuarterByNumber(eye, number)
            quarters = eye.quarters;
            
            quarter = Quarter.empty;
            
            for i=1:length(quarters)
                if quarters{i}.quarterNumber == number
                    quarter = quarters{i};
                    break;
                end
            end
        end
        
        function quarterNumbers = getQuarterNumbers(eye)
            quarterNumbers = zeros(length(eye.quarters), 1); % want this to be an matrix, not cell array
            
            for i=1:length(eye.quarters)
                quarterNumbers(i) = eye.quarters{i}.quarterNumber;                
            end
        end
        
        function nextQuarterNumber = getNextQuarterNumber(eye)
            lastQuarterNumber = max(eye.getQuarterNumbers());
            nextQuarterNumber = lastQuarterNumber + 1;
        end
                
        function eye = enterMetadata(eye, suggestedEyeNumber)
            
            %Call to EyeMetadataEntry GUI
            [eyeId, eyeType, eyeNumber, dissectionDate, dissectionDoneBy, notes] = EyeMetadataEntry(eye, suggestedEyeNumber);
            
            %Assigning values to Eye Properties
            eye.eyeId = eyeId;
            eye.eyeType = eyeType;
            eye.eyeNumber = eyeNumber;
            eye.dissectionDate = dissectionDate;
            eye.dissectionDoneBy = dissectionDoneBy;
            eye.notes = notes;
   
        end
        
        function eye = createDirectories(eye, toSubjectPath, projectPath, localPath)
            dirSubtitle = eye.eyeType.displayString;
            
            eyeDirectory = createDirName(EyeNamingConventions.DIR_PREFIX, num2str(eye.eyeNumber), dirSubtitle);
            
            createObjectDirectories(projectPath, localPath, toSubjectPath, eyeDirectory);
                        
            eye.dirName = eyeDirectory;
        end
        
        function [] = saveMetadata(eye, toEyePath, projectPath, localPath, saveToBackup)
            saveObjectMetadata(eye, projectPath, localPath, toEyePath, EyeNamingConventions.METADATA_FILENAME, saveToBackup);            
        end
        
        function eye = wipeoutMetadataFields(eye)
            eye.dirName = '';
            eye.quarters = [];
        end
    end
    
end

