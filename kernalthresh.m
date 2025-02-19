%  Kernal Thresholding  
% For data (dataset.dff) organized as rows of single neuron calcium traces in df/f format to find threshold for each cell using Kernal thresholding. 1st Kernal presumed to be baseline noise. Does not assume any level of neuronal activity, i.e. can have neuronal below activation threshold for entire recording.
%output is dataset.spike based on individual neuronal thresholds

for i = 1:size(dataset.dff,1) % dataset.dff = for individual neuronal calcium traces 
                clear m5 fmirror atest
                [f1,x1] = ksdensity(dataset.dff(i,:));
                inc = x1(2)-x1(1);
                x1(101:200) = x1(100)+(linspace(inc,inc*100,100));
                m1 = find(f1==max(f1));
                fmirror = f1(1:m1);
                fmirror(m1+1:m1+m1) = flip(f1(1:m1));
	%fmirror isolates only the first kernal which should represent baseline/noise 
                for j = 2:length(fmirror)
                    atest(j) = trapz(x1(1:j),fmirror(1:j));
                end
                p90 = prctile(atest,90);
                m5 = find(abs(atest-p90)==(min(abs(atest-p90))));
                threshks(i) = x1(m5(end));
	%find single cell threshold > than 90th percentile of first kernal
            end
            dataset.spike = dataset.dff>threshks.';
