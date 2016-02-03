clear all;
close all;

% Set directory and file paths
matLabelsPath_input = '../Data/trainval/'; % Location of *.mat-files
imageLabelsPath_output = '../Data/LabelImages/'; % Location of output images

% Look up all *.mat-files
files = dir(fullfile(matLabelsPath_input,'*.mat'));

% Create output directory
mkdir(imageLabelsPath_output);

% Load label look up table
oldLabels = 1:459;
newLabels = randi(59,1,459);

% Automtically set the required bit depth according to the maximum label
% value.
bitDepth = 8;
if (log2(max(newLabels)+1) > bitDepth)
    bitDepth = 16;
end

% Loop through all mat files, relabel each labled image and save it as a
% png image.
tic;
for i = 1:length(files);
    % Display progress
    [~, filename,~] = fileparts(files(i).name);
    disp(['Processing (' num2str(i) '/' num2str(length(files)) ') : ' files(i).name ' --> ' filename '.png']);
    
    % Load mat-file
    load(fullfile(matLabelsPath_input,files(i).name));
    
    % Map labels from original labels to desired labels
    LabelVector = reshape(LabelMap,[],1);
    RelabelVector = interp1(oldLabels', newLabels', double(LabelVector),'nearest');
    RelabelMap = reshape(RelabelVector, size(LabelMap));
    
    % Cast relabeled image to either uint8 or uint16 according to the
    % required bit depth
    if (bitDepth == 8)
        RelabelMap = uint8(RelabelMap);
    elseif (bitDepth == 16)
        RelabelMap = uint16(RelabelMap);
    else
        error('Unknown bit depth');
    end
    % Write label image
    imwrite(RelabelMap, fullfile(imageLabelsPath_output,[filename, '.png']));
    
    % Rinse and repeat
end;

disp('Done');
toc