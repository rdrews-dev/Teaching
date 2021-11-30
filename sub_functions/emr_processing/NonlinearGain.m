function [DataOut] = NonlinearGain(DataIn ,GainExponent,ControlPlot)
    

    [NumberOfSamples NumberOfTraces] = size(DataIn);
    GainMatrix= (repmat((1:NumberOfSamples)-1,NumberOfTraces,1)').^(GainExponent);
    DataOut = DataIn.*GainMatrix;
    
    if ControlPlot>0
        figure(100)
        imagesc(GainMatrix)
        figure(ControlPlot)
        ax1= subplot(2,1,1)
        imagesc(1:NumberOfSamples,1:NumberOfSamples,DataIn);
        caxis(0.1*[min(min(DataIn)),max(max(DataIn))]);colormap(bone)
         ax2= subplot(2,1,2)
        imagesc(1:NumberOfSamples,1:NumberOfSamples,DataOut);
        caxis(0.1*[min(min(DataOut)),max(max(DataOut))]);colormap(bone);
        linkaxes([ax1,ax2]); 
    end

end