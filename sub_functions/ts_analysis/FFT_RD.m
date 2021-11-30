function [frequency,amplitudes,phase,psd,fft_z] = FFT_RD(delta_t,signal,windowing,auxplot)
    

    %% We need a col vector.
    [a b] = size(signal);
    if a>b
        signal = signal';
    end
    %% Original length of the time series
    L = length(signal);                  

    %% The Nyquist frequency is the highest frequency for a given frequency.
    f_Nyq = 1/(2*delta_t);
    if (windowing==1)
        %Do the FFT with windowing. Amplitudes cannot directly be recovered.
        %% Padding should preferably done with tapering to avoid edge effects.
        NFFT = 2^nextpow2(L);
        f_Rayleigh = 1/(NFFT*delta_t);
        f = 0:f_Rayleigh:f_Nyq;
        display('Using a Hanning Window for now.')
        fft_z = fft(hann(L)'.*signal,NFFT);
%         fft_z = fft(blackman(L)'.*signal,NFFT);
%        fft_z = fft(tukeywin(L)'.*signal,NFFT);
        % The FFT is a complex vector. The amplitudes cannot easily be
        % recovered because of the windowing. This requires some scaling
        % not done here.
        amplitudes = 2*abs(fft_z(1:NFFT/2+1))/L;
        %% This is the power spectral density. This quantity is conserved 
        %% (Parseval analog). Looks similar than amplitudes (maybe log it)
        psd = fft_z.*conj(fft_z)/L;psd=psd(1:NFFT/2+1);
    else
        %Do the FFT without windowing. Amplitudes can be recovered.
        NFFT = 2^nextpow2(L);
        f_Rayleigh = 1/(NFFT*delta_t);
        f = 0:f_Rayleigh:f_Nyq;
        fft_z = fft(signal,NFFT);
        % The FFT is a complex vector. The amplitudes can be recovered using abs()
        % The factor 2/L depends on normalization and on definition of DFT.
        % The DFT is NFFT periodic and hermetian symetric (see above).
        amplitudes = 2*abs(fft_z(1:NFFT/2+1))/L;
        %% This is the power spectral density. This quantity is conserved 
        %% (Parseval analog). Looks similar than amplitudes (maybe log it)
        psd = fft_z.*conj(fft_z)/L;psd=psd(1:NFFT/2+1);
    end
    phase = angle(fft_z(1:NFFT/2+1));
   
    if (auxplot == 1)
        figure()
        subplot(2,1,1)
        plot(f,log10(amplitudes),'r-') %% only the energy will be the same, not necessarily the amplitude.
        ylabel('log10(amplitude)')
        xlabel('Frequency (1/TimeUnit)')
        subplot(2,1,2)
        plot(f,phase,'b-x')
        ylabel('phase')
        xlabel('frequency')
        %plot(f,Phase,'r-x')
    end
    frequency=f;
end
