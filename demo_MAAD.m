%% MULTIRESOLUTION ANALYSIS OF ACOUSTIC DATA (MAAD)
% The present script reports basic instructions to run the
% Multiresolution Analysis of Acoustic Diversity (MAAD) on audio
% recordings. This program is free software: you can redistribute it and/or
% modify it under the terms of the GNU General Public License
% http://www.gnu.org/licenses/. While due care has been taken and it is
% believed accurate, its use is solely the responsibilities of the user.
% --
% Written by Juan Sebastian Ulloa 
% Museum national d'Histoire naturelle and Universite Paris-Saclay
% October 2017
%
% Supporting information for article: Ulloa et al. Estimating animal
% acoustic diversity in tropical environments using unsupervised
% multiresolution analysis. Ecological Indicators, under review.
% --
% Basic system requirements are:
%   - Matlab R2014b or later with ScatNet (v 0.2) toolbox. Scatnet toolbox can be downloaded from
%     http://www.di.ens.fr/data/software/scatnet/download/
%   - R version 3.3.2 (2016-10-31) or later with package HDclassif (v 2.0.2)

%--
% To run the analysis you need to switch between two software environments.
% For preprocessing, detection and characterization of ROIs, and
% visualization you need to use a Matlab console. For the clustering step,
% you need to use the R console.

%% LOAD AUDIO AND SYSTEM PARAMETERS
% Open a Matlab console, load audio and default options for the analysis:
run ./default_options.m 
s=audioread('../audio_files/demo.wav');

%% 1. DETECTION OF REGIONS OF INTEREST (ROIs)
% Transform passive acoustic recordings into the time-frequency domain
% using the windowed short-time Fourier transform. The Fourier coefficients
% are filtered to remove noise and to highlight sounds that can be
% delimited in time and frequency, here defined as regions of interest
% (ROIs):
[~,im,im2]=preprocess_audio(s,fs,preproc_opt,spectro_opt,ss_opt);
[~,rois_ij]=find_rois(im2,imfilt_opt);  
% Visualize results:
imshow_rois(im,rois_ij,[]);

%% 2. CHARACTERIZATION OF ROIs
% Characterize ROIs with features in the time-frequency domain using 2D
% wavelets and the median frequency.
shape_features=calc_features('scatnet_op2',s,im,rois_ij,fs,filt_opt,[]);
frequency_feature=calc_features('spectral_centroid',s,im,rois_ij,fs,[],spectro_opt); 

%% SAVE OUTPUT TO CSV FILE
% Organize the features in a table and save the output to a csv file. The
% csv file is used to transfer the data to the R software environment.
rois_features=table(shape_features,frequency_feature);
writetable(rois_features,'../output/rois_features.csv','Delimiter',',');

%% Cluster ROIs
% Cluster the ROIs into homogeneous groups based on their attributes. This
% step requires to open a R console and run the script cluster_rois.R

%% LOAD AND PLOT RESULTS
rois_group=readtable('../output/rois_group.csv');
imshow_rois(im,rois_ij,table2array(rois_group));
