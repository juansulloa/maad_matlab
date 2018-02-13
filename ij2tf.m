%% Image spectrogram to time-frequency units
% Convert pixels of spectrogram to time-frequency units
% [t,f]=ij2tf(i,j,ws,ovlp,nfft,fs)
% i     : x value
% j     : y value
% ws    : window size of spectrogram
% ovlp  : number of samples overlaped
% nfft  : number of samples for fft
% fs    : sample frequency
% Output
% t     : time in seconds
% f     : frequency in kilohertz

function [t,f]=ij2tf(i,j,ws,ovlp,nfft,fs)

findex = psdfreqvec('npts',nfft,'Fs',fs,'Range','half');
findex=flipud(findex);
f=findex(j)/1000;

t=((i-1)*(ws-ovlp)+ws/2)/fs;