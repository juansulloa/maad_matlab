function rois_out=roisij_roistf(rois_in,ws,ovlp,nfft,fs)

rois_out=rois_in;
[rois_out.xmin, rois_out.ymin]=ij2tf(rois_in.xmin,rois_in.ymin,ws,ovlp,nfft,fs);
rois_in.height=nfft/2+1-rois_in.height;
[rois_out.width, rois_out.height]=ij2tf(rois_in.width,rois_in.height,ws,ovlp,nfft,fs);

rois_out.height=rois_out.height*1000;
rois_out.ymin=rois_out.ymin*1000;