% created by 
% MD. Facihul Azam
% student id: 238949
% dept: Information Technology

clear all;
clc
 %[sd,fs]=audioread('drumorig.mp3');% drum signal
 %[c,fc]=wavread('cello1.wav');% piano signal
 %[sdh,fs]=audioread('dhol.mp3');
 %[vg,fd]=audioread('Adhitia Sofyan - After The Rain.mp3');% guitar + vocal signal
%  [m,fs]=audioread('Flora Matos - Pretin.mp3'); a song with drum and different instruments.
%  m=m(:,1);
 %sd=sd(:,1);
% sdh=sdh(:,1);
% piano=c(:,1);
%vg=vg(:,1);
 [m,fs]=audioread('test.mp3');
%drumOrig=sd(1*44100:14*44100);  % taking 1st 14 second of the music
%dholOrig=sdh(1*44100:14*44100); % taking 1st 14 second of the music
%piano=piano(1*44100:14*44100);  % taking 1st 14 second of the music
%guitarvocal=vg(1*44100:14*44100); % taking 1st 14 second of the music
m=m(:,1);
mix=m(100*44100:110*44100);
 %mix=drumOrig+piano+dholOrig;%+guitarvocal;
 
alpha=0.5; % balance parameter
 gama=0.5;
k=2; % number of iteration
winLength=1024; % windowlength
fftlength=1024; 

[drumSep,harSep,H_hi_kmax,P_hi_kmax]=drumSeperator(mix,fs,alpha,fftlength,winLength,gama,k);


%%%%%%%%%% performance evaluation %%%%%%%%%%%%%%%%%

    zeropd=length(m(:,1))-length(drumSep);
    drumSep=[drumSep zeros(1,zeropd)];
    Psignal= sum((m(:,1).^2));
    %Psignal=sum(drumOrig(:,1).^2);
    %Pnoise=sum((drumOrig(:,1)'-drumSep).^2); 
    Pnoise=sum((m(:,1)'-drumSep).^2); 
    snr=10*log10(Psignal./Pnoise);


sound(drumSep,fs);
    
figure(2)
spectrogram(mix,fftlength);

figure(1)
subplot(1,2,1)
spectrogram(drumSep,fftlength);
title('percussive');
subplot(1,2,2)
spectrogram(harSep,fftlength);
title('harmonic');
sound(harSep,fs);





