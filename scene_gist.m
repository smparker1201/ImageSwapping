function scene_gist( img_path )
%Computes GIST descriptor. With current settings, the descriptor is 1x480. 
%It should compute the gist for each cell and add the descriptor as a
%field. 

img = imread(img_path);
    
% GIST Parameters:
clear param
param.imageSize = [256 256]; % set a normalized image size
param.orientationsPerScale = [6 6 6 6 6]; % number of orientations per scale (from HF to LF)
param.numberBlocks = 4;
param.fc_prefilt = 4;

% Computing gist:
[gist, param] = LMgist(img, '', param);
size(gist)


% Visualization
figure
subplot(121)
imshow(img)
title('Input image')
subplot(122)
showGist(gist, param)
title('Descriptor')

% Pre-allocate gist:
%Nfeatures = sum(param.orientationsPerScale)*param.numberBlocks^2;
%gist = zeros([Nimages Nfeatures]); 

% Load first image and compute gist:
%img = imread(file{1});
%[gist(1, :), param] = LMgist(img, '', param); % first call
% Loop:
%for i = 2:Nimages
%   img = imread(file{i});
  % gist(i, :) = LMgist(img, '', param); % the next calls will be faster
%end
    


end

