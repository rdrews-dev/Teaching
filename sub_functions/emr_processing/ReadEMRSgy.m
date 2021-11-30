function Data = ReadEMRSgy(FilePath,TraceStart,TraceStop,MatFilePath,ControlPlot)
    %set TraceEnd = -1 to read it all;
    if exist(MatFilePath)==2
        display('Loading MAT File from previous reading of that file.')
        load(MatFilePath);
    else
        display('Loading SEGY File, saving as MAT file for later.')
        if isfile(FilePath)
            [Data,SegyTraceHeaders,SegyHeader]=ReadSegy(FilePath);
        else
            display('No such file exists.')
            return;
        end
        if TraceStop>0
            Data = Data(:,TraceStart,TraceStop);
        else
            Data = Data(:,TraceStart:end);
        end
        save(MatFilePath,'Data')
    end
    if ControlPlot>0
        QuicklookEMR(Data,0.1*min(min(Data)),0.1*max(max(Data)),ControlPlot);
    end
end