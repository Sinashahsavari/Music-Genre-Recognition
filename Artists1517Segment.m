clc
clear

%% global variables
p = 100;                           % number of AR coefficients. needs to be changed.
n = 3;
Lref = n * 4410;                         % length of reference window
Lslid = n * 4410;                        % length of sliding window

%%
% genre = {'Alternative & Punk' , 'Blues' , 'Childrens' , 'Classical' , 'Comedy & Spoken Word' , 'Country' , 'Easy Listening & Vocals' , 'Electronic & Dance' , 'Folk' , 'Hip-Hop' , 'Jazz' , 'Latin' , 'New Age' , 'R&B & Soul' , 'Reggae' , 'Religious' , 'Rock & Pop' , 'Soundtracks & More' , 'World'};
genre = {'Hip-Hop' , 'Rock & Pop'};

for g = 1:length(genre)
    
    fileList = dir(strcat('Data/1517-Artists/',genre{g}));
    
    for trackNum = 1:(length(fileList) - 2)
        
        tic
            
        [dataOrg,Fs] = audioread(strcat('Data/1517-Artists/',genre{g},'/',fileList(trackNum+2).name));
        
        if size(dataOrg,2) == 2
            dataOrg = mean(dataOrg,2);
        end
        
        data = decimate(dataOrg,10);
        
        winNum = floor(size(data,1) / Lref);
        sigWin = reshape(data(1:winNum*Lref),[Lref,winNum]);
        img = zeros(winNum , winNum);
        
        parfor i = 1 : winNum

            model = ar(sigWin(:,i),p);
            ARcoef = model.A;
            noiseVar = model.NoiseVariance;

            for j = 1 : winNum

                res = filter(ARcoef , 1 , sigWin(:,j) );
                [r , lag] = xcorr(res,'biased');
                img(i,j) = (noiseVar / r(lag == 0) - 1) ^ 2 + 2 * sum((r(lag >= 1) / r(lag == 0)) .^ 2);

            end

        end
        
        img(isnan(img)) = inf;
        imgSym = (img + img')/2;
        
        A = exp(-1 * (imgSym/median(median(imgSym))).^2);
        A = A .* (1 - eye(size(A)));

        D = diag(sum(A,2) + eps);
        L = D - A;
        L_sym = (D^(-0.5)) * L * (D^(-0.5));
        
        k = 5;
        [U , Lambda] = eigs(L_sym,k,'sr');
        T = diag((sum(U.^2,2)).^(-0.5)) * U;
        [es , ord] = sort(diag(Lambda));
        T = T(:,ord);
        idx = kmeans(T,k,'Replicates',10);
        
        save(strcat('Data/1517-Artists/Segments/',genre{g},'/es',num2str(trackNum),'.mat'),'es');
        
        dataOrg = dataOrg(1:winNum*Lref*10);
        idxRep = repelem(idx,Lref*10);
        
        dataOrgMode = dataOrg(idxRep == mode(idx));
        
        num30Sec = floor(length(dataOrgMode) / (Fs * 30));
        
        t = toc;
        
        if num30Sec >= 1 
            
            for i = 1:num30Sec
                audiowrite(strcat('Data/1517-Artists/Segments/',genre{g},'/',num2str(trackNum),'.',num2str(i),'.mp4'),dataOrgMode(((i-1)*(Fs * 30)+1):i*(Fs * 30)),Fs);
            end
            display(strcat('Soundtrack -',fileList(trackNum+2).name,' from genre',{' '},genre{g},{' '},'have been segmented in',{' '},num2str(t),{' '},'seconds!'))
            
        else
            display(strcat('Soundtrack -',fileList(trackNum+2).name,' from genre',{' '},genre{g},{' '},'did not have any cluster longer than 30 seconds!'))
        end
              
    end
    
end