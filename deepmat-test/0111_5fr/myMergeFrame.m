function [mergedFrame, mergedLabel] = myMergeFrame(temp_mm, temp_label, nFrame, use_skip, use_testset, use_semiSkip)

size_mm = size(temp_mm, 1);

indexPointer = 0;
mergedFrame = [];
mergedLabel = [];
skipFlag = 0;

for ii=1:(size_mm-nFrame+1)  
    
    if(use_skip)
        if(skipFlag>0)
            skipFlag = skipFlag -1;
            continue; 
        end
    end
    
    myAccumLabel = 0;
    for jj=1:nFrame
        myAccumLabel = myAccumLabel+temp_label(ii+jj-1);
    end
    
    if(myAccumLabel==0)
        tempMergedFrame = [];
        for kk=1:nFrame
            tempMergedFrame(end+1,:) = temp_mm(ii+kk-1,:);
        end
        tempMergedFrame = reshape(tempMergedFrame', [1, nFrame*size(temp_mm,2)]);
        mergedFrame(indexPointer + 1,:) = tempMergedFrame;
        mergedLabel(indexPointer + 1,:) = 0;
        
        indexPointer = indexPointer+1;
        skipFlag = nFrame -1;
        
    elseif(myAccumLabel==nFrame)
        tempMergedFrame = [];
        for kk=1:nFrame
            tempMergedFrame(end+1,:) = temp_mm(ii+kk-1,:);
        end        
        tempMergedFrame = reshape(tempMergedFrame', [1, nFrame*size(temp_mm,2)]);
        mergedFrame(indexPointer + 1,:) = tempMergedFrame;
        mergedLabel(indexPointer + 1,:) = 1;
        
        indexPointer = indexPointer+1;
        skipFlag = nFrame -1;
        
    elseif(use_testset)
        tempMergedFrame = [];
        for kk=1:nFrame
            tempMergedFrame(end+1,:) = temp_mm(ii+kk-1,:);
        end        
        tempMergedFrame = reshape(tempMergedFrame', [1, nFrame*size(temp_mm,2)]);
        mergedFrame(indexPointer + 1,:) = tempMergedFrame;        
        if(myAccumLabel>=nFrame/2)
            mergedLabel(indexPointer + 1,:) = 1;
        else
            mergedLabel(indexPointer + 1,:) = 0;
        end
        
        indexPointer = indexPointer+1;
    end
    
    if(use_semiSkip~=0)
        skipFlag = use_semiSkip;
    else
        skipFlag = nFrame -1;
    end

end