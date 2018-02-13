%im_bin=double_th(im,c,l)
%Threshold estimation (from Oliveira et al, 2015)
% c: to set the first threshold
% l: amount to set second thrshold lower. From 0 to 1. ex: 0.1 = 10 %

function im_bin=double_th(im,c,l)

th=quantile(im(im>0),0.75)+iqr(im(im>0))*1.5*c;
im_t1=im>th;
im_t2=im>th-th*l; % 
im_t3=im.*im_t1;

% find index of regions which meet the criteria
conncomp_t2 = bwconncomp(im_t2);
rprops=regionprops(conncomp_t2,im_t3,'MeanIntensity'); 
rprops=cat(1, rprops.MeanIntensity); 
ind=find(rprops>0);

labels = bwlabel(im_t2);
im_bin = ismember(labels,ind); % filter labels that are not in t1