%% run after script 1
clear
addpath(genpath('./matlab_filca_toolbox/fsl_matlab'))

datapath='/output script 1/';

mods={'FA','MD','MO','VBM','JD'};

for k=1:5
    mod=mods{k};
    [img,dims,scales,bpp,endian] = read_avw(strcat(datapath,'all_',mod,'.nii.gz'));


    for i=1:dims(4)
        tmp=img(:,:,:,i);
        tmp=tmp(:);
        idx=find(tmp~=0);
        tmp2=tmp(idx);
        tmp2=(tmp2-mean(tmp2))/std(tmp2);
        tmp(idx)=tmp2;
        dum=reshape(tmp,dims(1),dims(2),dims(3));
        img2(:,:,:,i)=dum;

    end

    save_avw(img2,strcat(datapath,'Renormalized_','all_',mod,'.nii.gz'),'f',scales);
    clear img2
    clear img
end




