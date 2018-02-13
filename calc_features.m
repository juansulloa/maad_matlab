%% CALCULATE FEATURES FOR SIGNAL AND SPECTROGRAM
% features=calc_features(option,im,rois_ij,rois_tf,fs)
% options:  'lbp'           - local binary patterns
%           'pulse_rate'    - pulse rate or amplitude modulation
% im: spectrogram scaled between 0 and 1.
% rois_ij: regions of interest with coordinates ij
% rois_tf: regions of interest with coordinates time-frequency
% fs:   sampling frequency

function features=calc_features(option,s,im,rois_ij,fs,filt_opt,spectro_opt)

switch option
    % SPECTRAL CENTROID
    case 'spectral_centroid'
        spec_cent=zeros(size(rois_ij,1),1);
        for i=1:size(rois_ij,1)
            im_sel=im(rois_ij.ymin(i):rois_ij.ymin(i)+rois_ij.height(i),rois_ij.xmin(i):rois_ij.xmin(i)+rois_ij.width(i));
            sigma_csum=cumsum(sum(im_sel,2));
            sigma_tot=sigma_csum(end);
            idx=(find(sigma_csum>=sigma_tot/2,1));
            spec_cent(i)=rois_ij.ymin(i)+idx-1;
        end
        % convert to frequency units
        tt=zeros(size(spec_cent,1),1);
        [~,spec_cent]=ij2tf(tt,spec_cent,spectro_opt.ws,spectro_opt.ovlp,spectro_opt.nfft,fs);
        spec_cent=spec_cent*1000; 
        features=spec_cent;
        
    % SCATNET
    case 'scatnet_op2'   
        % create filter bank
        nfilt=filt_opt.J*filt_opt.L;
        scat_opt.oversampling = 2;
        scat_opt.M=1;
        [Wop , ~] = wavelet_factory_2d(size(im), filt_opt, scat_opt);
        
        % use pyramid to analyze sound at multiple scales
        npyr=4;
        features=zeros(size(rois_ij,1),nfilt*npyr); 
        for i_pyr=1:npyr
            if i_pyr==1
                [Sx,~]= scat(im, Wop);
                fh=@(x)imresize(x,size(im),'bilinear');
                Sx{2}.signal=cellfun(fh,Sx{2}.signal,'UniformOutput',0);
            else
                new_size=ceil(size(im)/2^(i_pyr-1));
                im_red=imresize(im,new_size,'bilinear');
                [Sx,~]= scat(im_red, Wop);
                % resize to match rois_ij
                fh=@(x)imresize(x,size(im),'bilinear');
                Sx{2}.signal=cellfun(fh,Sx{2}.signal,'UniformOutput',0);
            end
            
            for i_filt=1:nfilt
                for i=1:size(rois_ij,1)
                im_sel=Sx{2}.signal{i_filt}...
                    (rois_ij.ymin(i):rois_ij.ymin(i)+rois_ij.height(i),rois_ij.xmin(i):rois_ij.xmin(i)+rois_ij.width(i));
                features(i,(i_pyr-1)*nfilt+i_filt)=mean(im_sel(:));
                end
            end
        end        
    %% OTHERWISE 
    otherwise
    disp('Invalid option, no features calculated')
    features=[];
end

