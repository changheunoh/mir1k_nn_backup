 addpath('.//rastamat'); 
%  addpath('/Users/choh/Documents/W_Matlab/choh_stft');

myPath.wavePath = '../../Wavfile/';
myPath.labelPath = '../../PitchLabel/';

saveDirName = '16k_dBspec';
eval(['mkdir ', saveDirName]);


fs = 16000;
param.window_size = 512;
param.hop_size = fs*0.01;
param.fft_size = param.window_size;
param.fs = fs;

fileID = fopen('names.txt','w');


use_dB = 1;
use_mfcc = 0;
use_powerSpect=0;

%%


MyDirInfo = dir(myPath.wavePath); %% left : accompaniments, right : vox
cnt_skip =0;
total_num = length(MyDirInfo);
% total_num =503;



for index =1:total_num
    if ( strcmp(MyDirInfo(index).name, '.'))
        cnt_skip = cnt_skip+1;
        continue;
    elseif ( strcmp(MyDirInfo(index).name, '..'))
        cnt_skip = cnt_skip+1;
        continue;
    end
        if(index==3), index=503;  end
    name = MyDirInfo(index).name;  
    
    [spect_mix, spect_vox, spect_acp, VAresult] = PackageMaker_mir1k(name, param, myPath, use_dB, use_mfcc, use_powerSpect);
     
    
%     max_value = max(max(spect_mix));
%     spect_mix = spect_mix ./ max_value;
%     spect_vox = spect_vox ./ max_value;
%     spect_acp = spect_acp ./ max_value;
    
    path_mix = strcat(myPath.wavePath, name);
    myText = [ 'index : ',num2str(index-cnt_skip), 9, 'name : ', name, 9,'path : ', path_mix, '\n'];
    disp( myText(1:end-2) );
    
    variName = [saveDirName,'/data',num2str(index-cnt_skip)];
    fileName = [variName,'.mat'];
    
%     if(use_mfcc)
%         mm_mix = spect_mix;
%         mm_vox = spect_vox;
%         mm_acp = spect_acp;
%         save(fileName,  'mm_mix', 'mm_vox', 'mm_acp', 'VAresult');
%     else        
        save(fileName,  'spect_mix', 'spect_vox', 'spect_acp', 'VAresult');
%     end
    fprintf(fileID,myText,'\n');
end


fclose(fileID);