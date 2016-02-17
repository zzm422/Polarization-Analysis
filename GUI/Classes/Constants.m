classdef Constants
    %Constants
    %holds constants for polarization anaylsis application
    
    properties (Constant)
        BACKUP_DIR = 'Raw Data Backup [DO NOT ACCESS]';
        
        METADATA_VAR = 'metadata';
        
        TAB = '    '; % used for spacing out folder directory lists
        
        BMP_EXT = '.bmp';
        ND2_EXT = '.nd2';
        MATLAB_EXT = '.mat';
        
        FIGURE_INIT_SIZE_WARNING_ID = 'images:initSize:adjustingMag';
        
        DEFAULT_EYE_TYPE = EyeTypes.Right;
        
        DEFAULT_STAIN = 'Thioflavin S and Dapi';
        
        DEFAULT_SLIDE_MATERIAL = 'Glass';
    end
    
    methods
    end
    
end

