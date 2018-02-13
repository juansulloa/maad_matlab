function [im_blobs,rois_ij]=find_rois(im,imfilt_opt)
% Find regions of interest in STFT coffecient matrix
% im: STFT coefficient matrix
% imfilt_opt: options for binary filter


%% Gaussian 2D low pass filter
fh = fspecial('gaussian',imfilt_opt.size,imfilt_opt.std);
im_out=imfilter(im,fh);
im_out=scaledata(im_out,0,1);
% Binarize matrix
im_bin=double_th(im_out,imfilt_opt.c,imfilt_opt.l);

%% Post processing
%select candidates by size of blob
min_blob = 5;max_blob = 10^5;
im_blobs=selblobs(im_bin,min_blob,max_blob);

% Get pixel indices and rois
[B,L,N,A] = bwboundaries(im_blobs,'noholes');
xx=cellfun(@(x) [min(x(:,2)) min(x(:,1)) max(x(:,2))-min(x(:,2)) max(x(:,1))-min(x(:,1))],B,'UniformOutput',0);
rois=cell2mat(xx); 

% Organize results in a dataset
xmin=rois(:,1);ymin=rois(:,2);width=rois(:,3);height=rois(:,4);
rois_ij=dataset(xmin,ymin,width,height);

