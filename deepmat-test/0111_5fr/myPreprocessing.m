%% record randperm

fileID = fopen('randIndex.txt','w');
use_merge = true; 
nFrame = 5;  % only used when 'use_merge==true'
use_skip = false;
use_semiSkip = 3; % only used when 'use_skip==true'
use_testset =false;
dataPath = '../../16k_dBspec/data';

%% data set pre-processing 

data = [];
data_label = [];
endPointer = 0;
numSongs = 500; 
myrandindex = randperm(500);

reverseStr='';
fprintf(fileID,['data','\n'],'\n');
for song_index = 1:numSongs
%     temp_index = song_index;
    temp_index = myrandindex(song_index);


    filename = [dataPath,num2str(temp_index),'.mat'];
    loading = load(filename);

    temp_mm = (loading.spect_mix)';    
    temp_label = loading.VAresult; 
    
    if (use_merge)
        [mergedFrame, mergedLabel] = myMergeFrame(temp_mm, temp_label, nFrame, use_skip, use_testset, use_semiSkip);
        temp_mm = mergedFrame;
        temp_label = mergedLabel;
    end
    
    
    temp_size = size(temp_mm,1);
    if(temp_size~=size(temp_label)), temp_label=temp_label(1:temp_size);    end
    temp_subspace = endPointer + 1:endPointer + temp_size;
    
    data(temp_subspace , :) = temp_mm;
    data_label(temp_subspace , 1) = (temp_label==1);

    
    
        
    myText = [ num2str(song_index),9, num2str(temp_index),9,...
        'index : ', num2str(endPointer + 1),9,num2str(endPointer + temp_size), '\n'];
    fprintf(fileID,myText,'\n');
    
    endPointer = endPointer + temp_size;
    
%     disp([song_index temp_index]);
            percentDone = 100 * song_index / numSongs;
          msg = sprintf('Percent done: %3.2f', percentDone); %Don't forget this semicolon
          fprintf([reverseStr, msg]);
          reverseStr = repmat(sprintf('\b'), 1, length(msg));
end
disp(' ');

save data data
save data_label data_label

fclose(fileID);

%%
%%
%%
%%

