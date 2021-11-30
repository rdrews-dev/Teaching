    function [DataFiltered] = LowPass_RD(Data,Time,delta_t,cutoff,transitionband, auxplots)
    %Function based on;
    %https://tomroelandts.com/articles/how-to-create-a-simple-low-pass-filter
    %
    % secs_per_day = 24*3600;
    % delta_t=60;fs = 1/delta_t;
    % Time = 0:delta_t:5*secs_per_day;f1 = 1/secs_per_day;f2=4.5/secs_per_day;
    % Data = 1*sin(2*pi*f1*Time)+0.4*sin(2*pi*f2*Time+pi/3) + randn(size(Time))/10;
    % 
    % [DataFiltered] = LowPass_RD(Data,Time,delta_t,(f1+f2)/2,0.9,1);

    
    Nobs = length(Data);fs=1/delta_t;
    fc = cutoff*1/fs;  % Cutoff frequency as a fraction of the sampling rate: fc*fs = cutoff in Hz
    b = transitionband*fc;   %    % Transition band, as a function of cutoff.
    
    
    N = ceil((4 / b));

    % Make sure that N is odd.
    if mod(N,2)==0
        display('Filterl length is even, change to odd')
        N=N+1;
    else
        display('Filter length is odd. Fine.') 

    end
    n = 1:N;

    % Compute sinc filter.
    h = sinc(2 * fc * (n - (N - 1) / 2));

    % Compute Blackman window.
    w = 0.42 - 0.5 * cos(2 * pi * n / (N - 1)) + ...
        0.08 * cos(4 * pi * n / (N - 1));

    % Multiply sinc filter by window.
    h = h .* w;

    % Normalize to get unity gain.
    h = h / sum(h);

    %%% Filter delay of FIR (linear phase)(N – 1) / (2 * Fs)
    %%% The delay is because in multiplication T*h and h = M(w)e^{Iphi} the
    %%% phase is changed.
    DataFiltered = conv(Data,h);
    TimeDelay = (N-1)/(2*fs);BinDelay=TimeDelay/delta_t;
    %Tf=Tf(N/2:end-N/2);
    DataFiltered=DataFiltered(BinDelay:end-BinDelay-1);

        if auxplots==1
            figure()
            plot(Time,Data);hold on
            plot(Time,DataFiltered,'r-')

            [frequency,amplitudes,phase,psd,fft_z] = FFT_RD(delta_t,Data,1,1);
            [frequency,amplitudes,phase,psd,fft_z] = FFT_RD(delta_t,DataFiltered,1,1);
        end
    end