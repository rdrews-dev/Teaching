function [DataOut] = FlattenRES(DataIn, MuteDirectWavePixels,MaxSearchIntervalPixles,SampleShiftToFirstOnset,ControlPlot)
    %Maximum search. Goes almost everywhere. Check
    %Step2_Sgy2FlatSurface if some linear interpolation is required.
    
    display('Aligning first arrivals from the surface...')
    [NumberOfSamples NumberOfTraces] = size(DataIn);
    for tr=1:NumberOfTraces
        [MagnitudeMaximum(tr) SampleNumberMaximum(tr)] = ...
        max(DataIn(MuteDirectWavePixels:MaxSearchIntervalPixles,tr));
    end
    SampleNumberMaximum = ...
    SampleNumberMaximum+MuteDirectWavePixels;
    SampleNumberMaximum = SampleNumberMaximum-SampleShiftToFirstOnset;
    
    %Apply static offset and move surface return to first sample95
    %------------------------------------------------------------
    DataOut= DataIn*0.0;
    for tr=1:NumberOfTraces
        TraceFromSurface = DataIn(SampleNumberMaximum(tr):end,tr);
        DataOut(1:length(TraceFromSurface),tr) = TraceFromSurface;
    end

    if ControlPlot>0
        QuicklookEMR(DataOut,0.1*min(min(DataOut)),0.1*max(max(DataOut)),ControlPlot);
    end
end