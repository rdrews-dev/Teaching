function [] = QuicklookEMR(Data,clim1,clim2,FigNum)
    
    [NumberOfSamples NumberOfTraces] = size(Data);
    figure(FigNum)
    imagesc(1:NumberOfSamples,1:NumberOfSamples,Data);
    caxis([clim1,clim2]);colormap(bone);
    ylabel('SampleNumber');xlabel('TraceNumber');

end