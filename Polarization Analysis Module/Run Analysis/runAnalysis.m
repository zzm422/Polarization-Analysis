function [selectStructure, analysisSession] = runAnalysis(dataSession, analysisSession, projectPath, dataPath, savePath, fileName, progressDisplayHandle, selectStructure, selectStructureIndex)
% runAnalysis


readInPath = makePath(projectPath, dataPath);
writePath = makePath(projectPath, savePath);


% ******************
% STEP 1: Compute MM
% ******************



% update status
selectStructure{selectStructureIndex}.isProcessing = true;
selectStructure{selectStructureIndex}.completedAnalysisPath = writePath;

newStatus = StatusTypes.ComputeMM;
selectStructure = updateStatus(newStatus, progressDisplayHandle, selectStructure, selectStructureIndex);

% Compute MM

normalizationType = analysisSession.muellerMatrixNormalizationType;
mmComputationType = analysisSession.muellerMatrixComputationType;

[MM_norm, outOfRangePixelsRatio] = computeMMFromPolarizationData(dataSession, readInPath, normalizationType, mmComputationType);

analysisSession.outOfRangePixelsRatio = outOfRangePixelsRatio;



% **********************
% STEP 2: Write MM Files
% **********************



% update status
newStatus = StatusTypes.WritingMM;
selectStructure = updateStatus(newStatus, progressDisplayHandle, selectStructure, selectStructureIndex);

% Write MM Files
dirName = PolarizationAnalysisNamingConventions.MM_DIR.getSingularProjectTag;
fileNameSection = createFilenameSection(PolarizationAnalysisNamingConventions.MM_FILENAME_LABEL, []);

writeMMFiles(MM_norm, writePath, fileName, dirName, fileNameSection);


if ~analysisSession.muellerMatrixOnly % only continue on if selected
    
    % *******************
    % STEP 3: Validate MM
    % *******************
    
    
    % DON'T THINK WE HAVE ANYTHING TO DO HERE
    
    % update status
    newStatus = StatusTypes.ValidatingMM;
    selectStructure = updateStatus(newStatus, progressDisplayHandle, selectStructure, selectStructureIndex);
    
    
    % *************************
    % STEP 4: Computing Metrics
    % *************************
    
    
    % update status
    newStatus = StatusTypes.ComputingMetrics;
    selectStructure = updateStatus(newStatus, progressDisplayHandle, selectStructure, selectStructureIndex);
    
    [metricResults, M_D, M_delta, M_R] = computeMetrics(MM_norm);
    
    
    % ***************************
    % STEP 5: Write Metrics Files
    % ***************************
    
    
    % update status
    newStatus = StatusTypes.WritingMetrics;
    selectStructure = updateStatus(newStatus, progressDisplayHandle, selectStructure, selectStructureIndex);
    
    % write decomposition MM results
    
    dirName = PolarizationAnalysisNamingConventions.M_D_FILENAME_LABEL;
    fileNameSection = createFilenameSection(PolarizationAnalysisNamingConventions.M_D_MATLAB_VAR_NAME, []);
    
    writeMMFiles(M_D, writePath, fileName, dirName, fileNameSection);
    
    dirName = PolarizationAnalysisNamingConventions.M_DELTA_FILENAME_LABEL;
    fileNameSection = createFilenameSection(PolarizationAnalysisNamingConventions.M_DELTA_MATLAB_VAR_NAME, []);
    
    writeMMFiles(M_delta, writePath, fileName, dirName, fileNameSection);
    
    dirName = PolarizationAnalysisNamingConventions.M_R_FILENAME_LABEL;
    fileNameSection = createFilenameSection(PolarizationAnalysisNamingConventions.M_R_MATLAB_VAR_NAME, []);
    
    writeMMFiles(M_R, writePath, fileName, dirName, fileNameSection);
    
    % write metric files
    
    writeMetricFiles(writePath, fileName, metricResults);
    
    % write stats and histogram files
    
    writeStatsFile(writePath, fileName, metricResults);
    
end

% *****************
% STEP 6: Complete!
% *****************


% update status
newStatus = StatusTypes.Complete;
selectStructure = updateStatus(newStatus, progressDisplayHandle, selectStructure, selectStructureIndex);


end

function selectStructure = updateStatus(newStatusType, progressDisplayHandle, selectStructure, selectStructureIndex)
    selectStructure{selectStructureIndex}.statusType = newStatusType;
    
    % update progress strings
    progressStrings = getProgressStrings(selectStructure);
    
    set(progressDisplayHandle, 'String', progressStrings);
    drawnow;
end






