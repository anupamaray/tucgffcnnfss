clear,close all; clc; 
% Script for evaluating performance using the following metrics: 
    % 1) Accuracy
    % 2) Mean accuracy
    % 3) Mean intersection over union
    % 4) Frequency weighted intersection over union


% UNDER CONSTRUCTION: CAN ONLY BE USED FOR INSPECTION OF ANNOTATIONS AND RESULTS


% Do remapping of classifier
    % 0: (Normal case) The number of classes is the same under both train
    % and test.
    % 1: The classifier has been trained on XX classes, that is mapped to
    % YY classe

% Directory of original color images;
dirImagesOrg = '/home/repete/DataFolder/VOC2010/JPEGImages';

% Directory of annotated test images.
dirImagesTest = '../Data/Context59';
dirsImagesTest = dir(fullfile(dirImagesTest,'*.png'));

% Directory of cvs mapping file.
dirCSVfile = '../Data/PascalContextClasses.csv';
[ labelMap ] = loadLabelMappingsFromCSVfile( dirCSVfile );
selectMapping = 2;
labels = labelMap(selectMapping).NewLabelIdsUnique;
labelNames = labelMap(selectMapping).NewLabelNamesUnique;

% Show the most frequent classes that covers XX% of the image
% imageLabelCoverage = 0.95;


dColors = distinguishable_colors(length(labels));

for iImage = 1%:length(dirsImagesTest)
    imgAnnotation = imread(fullfile(dirImagesTest,dirsImagesTest(iImage).name));
    
    % Show only annotated classes
    vecUsedLabels = double(unique(imgAnnotation(:)));
    vecLabelFreq= histc(imgAnnotation(:),vecUsedLabels);
    freqLabelMat = [vecLabelFreq/sum(vecLabelFreq) vecUsedLabels];
    sortFreqLabelMat = flipud(sortrows(freqLabelMat)); 
    
    
    
    
    
    
    imgAnnotationVis = im2double(imgAnnotation);
    figure(1)
    strTmp = strsplit(dirsImagesTest(iImage).name,'.');
    rgbOrg = imread(fullfile(dirImagesOrg,[strTmp{1} '.jpg']));
    subplot(1,3,1); title('Original image')
    imshow(rgbOrg)
    
    subplot(1,3,2); title('Annotated image')
    imshow(imgAnnotationVis*255/length(labels)); 
%     image(imgAnnotation); 
    colormap(dColors)
    lcolorbar(labelNames');
    
    subplot(1,3,3); title('Predicted')
    imshow(imgAnnotationVis*255/length(labels)); 
%     image(imgAnnotation)
    colormap(dColors)
    lcolorbar(labelNames');

    

end
