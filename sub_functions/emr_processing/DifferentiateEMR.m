function [DataOut, DepthOut] = DifferentiateEMR(Data,DepthIn,Nf,Fpass,Fstop,Fs,ControlPlots)
 %This filter turns the signal back into a 'waveform' and accounts for 
 %the logarithmic amplifiers. Classic differentiation is done in Disco
 %with [-1 0 1] filter. Here, the passband, stopband frequencies can
 %be used as a noise filter. However, it can cause filter ripples which 
 %shift, e.g., the bed reflection which should be picked in the raw data.
 
 %The filter delays also changes the output file size.
 display('Differentiating EMR waveform to account for the logarithmic amplifiers...')
 d = designfilt('differentiatorfir','FilterOrder',Nf, ...
        'PassbandFrequency',Fpass,'StopbandFrequency',Fstop, ...
        'SampleRate',Fs);
 FilterDelay = mean(grpdelay(d));
 DataOut = filter(d,Data); 
 DataOut(1:2*FilterDelay,:) = [];
 DepthOut = DepthIn(1:end-FilterDelay);
 DepthOut(1:FilterDelay) = [];
 if ControlPlots>0
      figure(ControlPlots)
      ax1=subplot(2,1,1);
      imagesc(Data);colormap('bone');caxis(0.1*[min(min(Data)) max(max(Data))]);title('Input Data');
      ax2=subplot(2,1,2);
      imagesc(DataOut);colormap('bone');caxis(0.1*[min(min(DataOut)) max(max(DataOut))]);title('Output Data');
      linkaxes([ax1,ax2]);  
      figure()
      fvtool(d,'MagnitudeDisplay','zero-phase','Fs',Fs)
      figure()
      pwelch(Data(:,100),[],[],[],Fs)
 end
 
end