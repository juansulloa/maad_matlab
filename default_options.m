%% Default options for demo_MAAD.m
% ------------------- begin options ---------------------------%

fs=44100;
% -- spectro opt --
spectro_opt.ws=1024;                    % window size
spectro_opt.ovlp=spectro_opt.ws*0.5;    % overlap 
spectro_opt.nfft=spectro_opt.ws;        % size of the nfft
spectro_opt.th=40;                      % threshold of spectrogram in db
spectro_opt.db_scale=1;                 % db scale or not (1 or 0)
spectro_opt.display=0;                  % display option (1 or 0)

% -- preprocesing opt --
preproc_opt.fc=500;     % high pass cutoff frequency in hertz
preproc_opt.forder=1;   % order of the high pass filter
ss_opt.lambda=3;        % over-subtraction factor to compensate variation of noise amplitude.
ss_opt.beta1=0.8;       % >0
ss_opt.beta2=1;         % >0
ss_opt.n_medfilt=32;    % median filter size for noise estimation

% -- filter opt (find_rois)
imfilt_opt.c=0.5;imfilt_opt.l=0.3;    % threshold level
imfilt_opt.std=2;                       % standard deviation of gaussian filter
imfilt_opt.size=[5 5];                  % size of gaussian filter

% -- scatnet opt --
scat_opt='scatnet_op2';
filt_opt.J = 4; % total num of scales
filt_opt.L = 4; % number of rotations
filt_opt.Q = 3; % num scale per octave
filt_opt.sigma_psi=1;
filt_opt.sigma_phi=0.75;  % std dev of the scaling function - def size of low-pass filt

% ------------------- end options ---------------------------%


