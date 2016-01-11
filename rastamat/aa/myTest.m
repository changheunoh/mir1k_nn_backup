 %%
 addpath('/Users/choh/Documents/W_Matlab/rastamat'); 
 addpath('/Users/choh/Documents/W_Matlab/choh_stft');
 
 
 % Read in an mp3 file, downsampled to 22 kHz mono
%  [d,sr] = audioread('BrianEno_extract.mp3',[1 30*22050],1,2);

%  [d,sr] = audioread('BrianEno_extract.wav');
%   [d,sr] = audioread('sm1_cln.wav');
% [d,sr] = audioread('MOT-what a wonderful world_10sec.wav');
% [d,sr] = audioread('/Users/choh/Documents/dataset/MIR-1K_for_MIREX/Dataset_for_MIREX/Wavfile/yifen_5_11.wav');
% [d,sr] = audioread('/Users/choh/Documents/dataset/MIR-1K_for_MIREX/Dataset_for_MIREX/Wavfile/Ani_1_01.wav');
[d,sr] = audioread('/Users/choh/Documents/dataset/MIR-1K_for_MIREX/Dataset_for_MIREX/Wavfile/fdps_1_14.wav');

    sr_orig = sr;
    d_orig = mean(d,2);
%  sr = sr/2;
 sr = 16000;
 d = resample(d_orig, sr, sr_orig);
 
%  d = resample(d_orig, 22050, 44100);
%  soundsc(d,sr)

 % Convert to MFCCs very close to those genrated by feacalc -sr 22050 -nyq 8000 -dith -hpf -opf htk -delta 0 -plp no -dom cep -com yes -frq mel -filt tri -win 32 -step 16 -cep 20
%  [mm,aspc] = melfcc(d*3.3752, sr, 'maxfreq', 8000, 'numcep', 20, 'nbands', 22, 'fbtype', 'fcmel', 'dcttype', 1, 'usecmp', 1, 'wintime', 0.032, 'hoptime', 0.016, 'preemph', 0, 'dither', 1);
 [mm,aspc] = melfcc(d*3.3752, sr, 'maxfreq', 8000, 'numcep', 20, 'nbands', 40, 'fbtype', 'fcmel', 'dcttype', 1, 'usecmp', 1, 'wintime', 0.032*2, 'hoptime', 0.010, 'preemph', 0, 'dither', 1);
%  [mm,aspc] = mymelfcc(d*3.3752, sr, 'maxfreq', 8000, 'numcep', 20, 'nbands', 40, 'fbtype', 'fcmel', 'dcttype', 1, 'usecmp', 1, 'wintime', 0.032*2, 'hoptime', 0.010, 'preemph', 0, 'dither', 1);
 
 %%
 
 % .. then convert the cepstra back to audio (same options)
%  [im,ispc] = invmelfcc(mm, sr, 'maxfreq', 8000, 'numcep', 20, 'nbands', 22, 'fbtype', 'fcmel', 'dcttype', 1, 'usecmp', 1, 'wintime', 0.032, 'hoptime', 0.016, 'preemph', 0, 'dither', 1);
 [im,ispc] = invmelfcc(mm, sr, 'maxfreq', 8000, 'numcep', 20, 'nbands', 40, 'fbtype', 'fcmel', 'dcttype', 1, 'usecmp', 1, 'wintime', 0.032*2, 'hoptime', 0.010, 'preemph', 0, 'dither', 1);
 
 % listen to the reconstruction
%   soundsc(im,sr)
 
 % compare the spectrograms
 subplot(311)
 specgram(d,512,sr)
%  size(specgram(d,512,sr))
 caxis([-50 30])
 title('original music')
 subplot(312)
 specgram(im,512,sr)
 caxis([-40 40])
 title('noise-excited reconstruction from cepstra')
 % Notice how spectral detail is blurred out e.g. the triangle hits around 6 kHz are broadened to a noise bank from 6-8 kHz.
 % save out the reconstruction
 

%  [spect_mix, ff, tt, dB_spect] = choh_stft(d, 512, sr*0.01, 512, sr);
%  subplot(313) 
%  imagesc(tt,ff,dB_spect);axis xy; colormap(jet)
%  caxis([-50 30])
%  axis xy;

 subplot(313) 
 imagesc(mm)
 axis xy;
 
%  recon = choh_istft(spect_mix, 512, sr*0.01);
%  aaa=specgram(d,512,sr);
 
 max(abs(im))
 
% audiowrite('HoldMeNow.wav', im/4,sr);

%%
% figure, imagesc(20*log10(spect_mix));axis xy; colormap(jet)