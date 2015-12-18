% this function separate a music signal i to two componenets: harmonic and persussive 
% created by 
% MD. Facihul Azam
% student id: 238949
% dept: Information Technology

function [drumSep,harSep,H_hi_kmax,P_hi_kmax]=drumSeperator(mixture,fs,alpha,fftlength,winLength,gama,k)

windowvalues =sqrt(hann(winLength));
overlap_samples=winLength/2;

%%%%%%%%%%%%%%%%% STFT %%%%%%%%% 
spectrogramFreqs=linspace(1,fs,fftlength);
[F_hi]=spectrogram(mixture,windowvalues,overlap_samples,spectrogramFreqs,fs);

W_hi=abs(F_hi.^(2*gama));
[m,n]=size(W_hi);
%%%%% zeropadding%%%%%%%
W_hi=[zeros(m,1) W_hi zeros(m,1)];
W_hi=[zeros(1,n+2);W_hi;zeros(1,n+2)];
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
H_hi=W_hi/2;
P_hi=W_hi/2;
%%%%%%%%%%%%%%%%%%% UPDATE values%%%%%%%%%%%%%
Kmax=k;

del=zeros(m+2,n+2);
for p=1:Kmax-1
    for h=2:m+1
     for k=2:n+1    
     del(h,k)=(alpha*(H_hi(h,k-1)-2*H_hi(h,k)+H_hi(h,k+1))/4)-((1-alpha)*(P_hi(h-1,k)-2*P_hi(h,k)+P_hi(h+1,k))/4);
     end
    end
    H_hi=min(max(H_hi+del,0),W_hi);
    P_hi=W_hi-H_hi;
end
%%%%%%%%%%%%%padded zeros removing%%%%
rows=[1,m+2];col=[1,n+2];
H_hi(rows,:)=[];
H_hi(:,col)=[];
P_hi(rows,:)=[];
P_hi(:,col)=[];
W_hi(rows,:)=[];
W_hi(:,col)=[];
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
H_hi_kmax_1=H_hi;
P_hi_kmax_1=P_hi;
%%%%%%%%binarize the results%%%%%%%%%%
H_hi_kmax=zeros(m,n);
P_hi_kmax=zeros(m,n);
for p=1:m
    for l=1:n
      if H_hi_kmax_1(p,l)< P_hi_kmax_1(p,l) 
          H_hi_kmax(p,l) = 0; 
          P_hi_kmax(p,l) = W_hi(p,l); 
      else
          H_hi_kmax(p,l)=W_hi(p,l);
          P_hi_kmax(p,l) = 0;
      end
     end
end

%%%%%%%%%  Timedomain signal genarating%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
len = fftlength + (n-1)*overlap_samples;

drumSep=zeros(1,len);
harSep=zeros(1,len);

    for p = 0:overlap_samples:(overlap_samples*(n-1))
        currentP_hi = P_hi_kmax(:,1+p/overlap_samples);
        phaseSpectrum=angle(F_hi(:,1+p/overlap_samples));
        
        fullSpectrumP= currentP_hi.*exp(1i.*phaseSpectrum);
        currentH_hi = H_hi_kmax(:,1+p/overlap_samples);
        fullSpectrumH= currentH_hi.*exp(1i.*phaseSpectrum);
        
       timedomainframeH = ifft(fullSpectrumH,fftlength,'symmetric');
       timedomainframep = ifft(fullSpectrumP,fftlength,'symmetric');
       harSep((p+1):(p+fftlength)) =  harSep((p+1):(p+fftlength)) + (timedomainframeH.*windowvalues)';
       drumSep((p+1):(p+fftlength)) = drumSep((p+1):(p+fftlength)) + (timedomainframep.*windowvalues)';
    end

end






