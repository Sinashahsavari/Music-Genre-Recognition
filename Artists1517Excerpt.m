clc
clear

genre = {'Alternative & Punk' , 'Blues' , 'Childrens' , 'Classical' , 'Comedy & Spoken Word' , 'Country' , 'Easy Listening & Vocals' , 'Electronic & Dance' , 'Folk' , 'Hip-Hop' , 'Jazz' , 'Latin' , 'New Age' , 'R&B & Soul' , 'Reggae' , 'Religious' , 'Rock & Pop' , 'Soundtracks & More' , 'World'};

for g = 16:length(genre)
    
    fileList = dir(strcat('Data/1517-Artists/',genre{g}));
    
    for trackNum = 1:(length(fileList) - 2)
    
        [dataOrg,Fs] = audioread(strcat('Data/1517-Artists/',genre{g},'/',fileList(trackNum+2).name));
        
        if size(dataOrg,2) == 2
            dataOrg = mean(dataOrg,2);
        end
        
        num30Sec = floor(length(dataOrg) / (Fs * 30));
        
        for i = 1:num30Sec
            
            audiowrite(strcat('Data/1517-Artists/Excerpts/',genre{g},'/',num2str(trackNum),'.',num2str(i),'.mp4'),dataOrg(((i-1)*(Fs * 30)+1):i*(Fs * 30)),Fs);
            
        end
    
    end
    
end