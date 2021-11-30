clear all;
close all;


%Includes SEGY library http://segymat.sourceforge.net/
addpath(genpath('sub_functions'))


%Do you want control plots? If so, set to FigNum else = -1;
%-----------------------------------------------------------
ControlPlots = 1;
dt = 13.33e-9;vice=1.68e8;
SgyFilePath = '../antr1999/data-stack10-sgy/993023-stp10.sgy';
MatFilePath = '../testdata/993023.mat';
%Parameters for flattening the first arrival
MuteDirectWaveSample = 100;MaxSearchIntervalSample=1200;SampleShiftToFirstOnset=0;
%-----------------------------------------------------------

%Read Input SEGY
%-----------------------------------------------------------
Data = ReadEMRSgy(SgyFilePath,6000,-1,MatFilePath,-1);

%Depth, Time,...;
%-----------------------------------------------------------
[NumberOfSamples NumberOfTraces] = size(Data);Fs=1/dt;
Time = (1:NumberOfSamples)*dt;Depth=Time/2*vice;

%Basic processing flow..
%-----------------------------------------------------------
Data = FlattenEMR(Data, MuteDirectWaveSample,MaxSearchIntervalSample,SampleShiftToFirstOnset,-1);
NF=50;Fpass=5e6;Fstop=15e6;
[DataOut, DepthOut] = DifferentiateEMR(Data,Depth,NF,Fpass,Fstop,Fs,-1);
[DataOut] = NonlinearGain(DataOut(1:1000,:),1.8,1);  %Implenent AGC gain yet. 


