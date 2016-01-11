function [spect_mix, spect_vox, spect_acp, VAresult] = PackageMaker_mir1k(name, param, myPath, use_dB, use_mfcc, use_powerSpect)

% myPath.wavePath = '/Users/choh/Documents/dataset/MIR-1K_for_MIREX/Dataset_for_MIREX/Wavfile/';
% myPath.labelPath = '/Users/choh/Documents/dataset/MIR-1K_for_MIREX/Dataset_for_MIREX/PitchLabel/';



path_mix = strcat(myPath.wavePath, name);
% path_vox = strcat(path.SrcPath, path.DevOrTest,'/', name, '/vocals.wav'); %% how can i use 'eval' func?
[mixture, Fs_orig] = audioread(path_mix);

accompaniment = mixture(:,1);
vocal = mixture(:,2);


% stereo to mono
if( size(mixture, 2)~=1)
    mixture = mean(mixture, 2);
end


% resample
if(Fs_orig~=param.fs)
    mixture = resample(mixture, param.fs, Fs_orig);
    vocal = resample(vocal, param.fs, Fs_orig);
end
nOverlap = param.window_size  - param.hop_size;

if (use_mfcc)
    sr = param.fs;
    % 'wintime', 0.064, 16000*0.064 = 1024, 'hoptime', 0.010, 10msec
    [mm_mix,~] = melfcc(mixture*3.3752, sr, 'maxfreq', 8000, 'numcep', 20, 'nbands', 40, 'fbtype', 'fcmel', 'dcttype', 1, 'usecmp', 1, 'wintime', 0.064, 'hoptime', 0.010, 'preemph', 0, 'dither', 1);
    [mm_vox,~] = melfcc(vocal*3.3752, sr, 'maxfreq', 8000, 'numcep', 20, 'nbands', 40, 'fbtype', 'fcmel', 'dcttype', 1, 'usecmp', 1, 'wintime', 0.064, 'hoptime', 0.010, 'preemph', 0, 'dither', 1);
    [mm_acp,~] = melfcc(accompaniment*3.3752, sr, 'maxfreq', 8000, 'numcep', 20, 'nbands', 40, 'fbtype', 'fcmel', 'dcttype', 1, 'usecmp', 1, 'wintime', 0.064, 'hoptime', 0.010, 'preemph', 0, 'dither', 1);
    
    spect_mix = mm_mix;
    spect_vox = mm_vox;
    spect_acp = mm_acp;
else
%     [spect_mix, ~, ~] = choh_stft(mixture, param.window_size, param.hop_size, param.fft_size, param.fs);
%     [spect_vox, ~, ~] = choh_stft(vocal, param.window_size, param.hop_size, param.fft_size, param.fs);
%     [spect_acp, ~, ~] = choh_stft(accompaniment, param.window_size, param.hop_size, param.fft_size, param.fs);
        
%     y = abs(specgram(x*32768,NFFT,SAMPRATE,WINDOW,NOVERLAP)).^2;
     WINDOW = [hanning(param.window_size)'];
     
     
     if(use_powerSpect)
         spect_mix = abs(specgram(mixture, param.fft_size, param.fs,WINDOW, nOverlap)).^2;
         spect_vox = abs(specgram(vocal, param.fft_size, param.fs,WINDOW, nOverlap)).^2;
         spect_acp = abs(specgram(accompaniment, param.fft_size, param.fs,WINDOW, nOverlap)).^2;
     else
         spect_mix = abs(specgram(mixture, param.fft_size, param.fs,WINDOW, nOverlap));
         spect_vox = abs(specgram(vocal, param.fft_size, param.fs,WINDOW, nOverlap));
         spect_acp = abs(specgram(accompaniment, param.fft_size, param.fs,WINDOW, nOverlap));
     end
    
    if(use_dB)
        % 
        spect_mix = mag2db(spect_mix);
        spect_vox = mag2db(spect_vox);
        spect_acp = mag2db(spect_acp);    
    end
end

path_label = strcat(myPath.labelPath, name(1:end-3), 'pv');
% /Users/choh/Documents/dataset/MIR-1K_for_MIREX/Dataset_for_MIREX/PitchLabel/Ani_2_01.pv

% disp(path_label);
VAresult = VoiceActivityExtract_mir1k(path_label);
if ( size(spect_mix,2)~=size(VAresult) )
    VAresult(end+1) = VAresult(end);
end

% VAresult=0;

end