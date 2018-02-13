function im_out=selblobs(im_bin,min_blob,max_blob)
%Aim: Select blob candidates based on area of blobs. min and max boundaries
% INPUT
%   im_bin: a binary image mask
%   min_blob and max blob: boundaries to select blobs. Blobs with values under
%   min_blob and over max_blob will be removed.
% OUTPUT
%   im_out: image with selected blobs

labels = bwlabel(im_bin);
R = regionprops(im_bin,'Area');
ind = find([R.Area] >= min_blob & [R.Area] <= max_blob);  
im_out = ismember(labels,ind);