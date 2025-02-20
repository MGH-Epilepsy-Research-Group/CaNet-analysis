% Defining network events of synchrnous activit that is above chance level compared to activity matched but temporally shuffled surrogate datasets from calcium spike data. Dataset.spike is the calcium data that was previously converted to spike data via Kernal thresholding.
             
             for it = 1:1000 %iterate 1000 times 
             for k = 1:size(dataset.spike,1)
                 randpos = randperm(length(dataset.spike(k,:)));
                 randat(k,:) = dataset.spike(k,randpos);
                 randat = double(randat); 
             end
             randmean(it,:) = mean(randat);
             end
             netthresh = prctile(randmean(:),99);
             neton = mean(dataset.spike)>netthresh; 
           %neton = average response more co-active than chance level determined from shuffled spike maps
             network_events = [];
             %output is network_events which stores start and end time of each network event
             if ~isempty(find(neton==1))
                 if(find(diff(neton)==1,1)>find(diff(neton)==-1,1))
                     neton(1,1:find(diff(neton)==-1,1)) = 0; 
                 end
                 network_events(1:length(find(diff(neton)==1)),1) = find(diff(neton)==1)+1;
                 network_events(1:length(find(diff(neton)==-1)),2) = find(diff(neton)==-1)+1;
                 if length(find(diff(neton)==1))>length(find(diff(neton)==-1))
                     network_events(end,2) = length(neton);
                 end
                 
             end

