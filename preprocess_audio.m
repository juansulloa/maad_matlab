%% PREPROCESSING AUDIO FILE
% [s,im,im2]=preprocess_audio(s,preproc_opt,spectro_opt,ss_opt)
% normalize, high pass filter, calculate spectrogram, and remove
% stationary noise from spectrogram with spectral subtraction

function [s,im,im2]=preprocess_audio(s,fs,preproc_opt,spectro_opt,ss_opt)
%% load options
% -- spectrogram options -- %
w_size=spectro_opt.ws;
noverlap=spectro_opt.ovlp;
nfft=spectro_opt.nfft;
th=spectro_opt.th;
db_scale=spectro_opt.db_scale;
display=spectro_opt.display;
% -- filter option -- %
fc=preproc_opt.fc;
forder=preproc_opt.forder;  % filter order
% -- spectral subtracion options -- %
beta1=ss_opt.beta1;
beta2=ss_opt.beta2;
lambda=ss_opt.lambda;
n_medfilt=ss_opt.n_medfilt;

%% Apply high pass filter
Wn = fc/(fs/2);
[B,A]=butter(forder,Wn,'high');
s=filter(B,A,s);

% normalize audio
s=s/max(abs(s));

%% Get STFT Coefficients
[S,f,t]=spectrogram(s,w_size,noverlap,nfft,fs);

if db_scale==true
    % calculate a minimum threshold down from the maximum amplitude
    bmin=max(abs(S(:)))/10^(th/20); 
    im=20*log10(max(abs(S),bmin)/bmin);
else
    bmin=max(abs(B(:)))/th;  
    im=max(abs(B),bmin)/bmin; 
end

im=flipdim(im,1);
im=scaledata(im,0,1);

%% Remove stationary noise with spectral subtraction
[Nf,Nw]=size(S);

% noise spectrum extraction
absS=abs(S).^2;

mean_profile=mean(absS,2); %average spectrum (assumed to be ergodic)
% estimate noise profile by smoothing the profile to allow peaks to emerge
noise_profile=ordfilt2(mean_profile,round(n_medfilt/2),ones(n_medfilt,1),'symmetric'); % faster than medfilt by a factor of 2
noise_profile(end-2:end)=mean_profile(end-2:end); % remove artifacts of high frequency
noise_spectro=repmat(noise_profile,1,Nw);

% snr estimate
SNR_est=max((absS./noise_spectro)-1,0); % a posteriori

% compute attenuation map
an_lk=max((1-lambda*((1./(SNR_est+1)).^beta1)).^beta2,0); 

% Apply the attenuation map to the STFT coefficients
spectro_ss=an_lk.*S;

% apply db scaling to spectrogram
bmin=max(abs(spectro_ss(:)))/10^(th/20); 
spectro_ss=20*log10(max(abs(spectro_ss),bmin)/bmin); % get spectrogram matrix

im2=flipdim(spectro_ss,1);
im2=scaledata(im2,0,1);