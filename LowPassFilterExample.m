%clear all
close all
addpath('sub_functions/')

Data = load('../testdata/XYShirase_GPS.txt');
Time = Data(:,6)-Data(1,6);
Elevation = Data(:,5) - mean(Data(:,5));


%% Resample with Anti-Aliasing filter. Alternatively this can also be done with "linear" or "spline"
%% y = resample(x,tx,fs,p,q) interpolates the input signal [x at tx] to an intermediate uniform grid with a sample spacing of (p/q)/fs. 
%% The function then filters the result to upsample it by p and downsample it by q, resulting in a final sample rate of fs. 
%% For best results, ensure that fs × q/p is at least twice as large as the highest frequency component of x.
%% Here we only use it to get it to a regular gridding.
TargetDt = 0.04/24.0; %Every 24 minutes.
Fs = 1/TargetDt;
HighestFrequency = 1/24.0;
[y,ty] = resample(Elevation,Time,Fs,2,1);
if 1==2
    figure(1)
    plot(Time,Elevation,'o',ty,y,'.-')
end

%LowPass Filtering with cut-off frequency of 2.5 per day.
[yf] = LowPass_RD(y,ty,TargetDt,2.5,0.9,0);
%FFT before and after.
%%% only the energy (psd) will be the same, not necessarily the amplitude.
[frequency,amplitudes,phase,psd,fft_z] = FFT_RD(TargetDt,y,1,0);
[frequencyf,amplitudesf,phasef,psdf,fft_zf] = FFT_RD(TargetDt,yf,1,0);

%Plot results
lw=2;
figure()
subplot(3,1,1)
plot(Time,Elevation,'b.');hold on
plot(ty,yf,'r-','LineWidth',lw)
xlim([8 10.5]); box off;
ylabel('Tidal Deflection (m)');set(gca, 'XTick', [8, 10.5]);
%ax1 = gca; ax1.XAxis.Visible = 'off';
subplot(3,1,2)
plot(ty,y,'b','LineWidth',lw);hold on
plot(ty,yf,'r-','LineWidth',lw)
xlabel('Time (Days)')
ylabel('Tidal Deflection (m)')
xlim([0 45])
box off;
subplot(3,1,3)
plot(frequencyf,psdf,'r-','LineWidth',lw); hold on; %% only the energy will be the same, not necessarily the amplitude.
plot(frequency,psd,'b-','LineWidth',lw)
xlim([0 5])
ylabel('Proxy Amplitudes (PSD)')
xlabel('Frequency (1/day)')
text(0.,70,'(c)')
box off;

axes('Position',[.65 .2 .25 .14])
box on
plot(frequency,psd,'b-','LineWidth',lw);box off;hold on
plot(frequencyf,psdf,'r-','LineWidth',lw); 
set(gca, 'XTick', [1.5, 5]);
%ax1 = gca; ax1.XAxis.Visible = 'off';
xlim([1.5, 5])
ylim([0, 0.1])

ExportFigRd('Output.pdf',20,15,12)

