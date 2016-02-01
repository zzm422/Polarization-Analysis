function [ ] = createObjectDirectories(projectDirectory, localDirectory, toPath, newDirectory)
% createObjectDirectories
% creates needed directories for an object (subject, eye, location, etc.)


% create project directories
parentPath = makePath(projectDirectory, toPath);
mkdir(parentPath, newDirectory);

% create backup directories
parentPath = makePath(projectDirectory, Constants.BACKUP_DIR, toPath);
mkdir(parentPath, newDirectory);

% create local directories
parentPath = makePath(localDirectory, toPath);
mkdir(parentPath, newDirectory);


end

