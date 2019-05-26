clear
% %% Set up:
addpath([getenv('FSLDIR') '/etc/matlab/'])
addpath([getenv('/usr/share/fsl/') '/etc/matlab/'])
addpath(genpath('/home/mrstats/alblle/Toolboxes/flica'))
addpath(genpath('/opt/freesurfer/5.3/matlab'))

%MAKE directory to save results
WD=pwd;
outdir=strcat(WD,'/flica_output/')
if ~exist(outdir, 'dir')
  mkdir(outdir);
end

%% Load Y from data files
Yfiles={['/home/mrstats/alblle/Projects/linked_ICA_HCP_500/HCP_4_FLICA/all_FA_sk_2mm.nii.gz']
['/home/mrstats/alblle/Projects/linked_ICA_HCP_500/HCP_4_FLICA/all_MD_sk_2mm.nii.gz']
['/home/mrstats/alblle/Projects/linked_ICA_HCP_500/HCP_4_FLICA/all_MO_sk_2mm.nii.gz']
['/home/mrstats/alblle/Projects/linked_ICA_HCP_500/HCP_4_FLICA/?h.thick.fsaverage.10mm.mgh']
['/home/mrstats/alblle/Projects/linked_ICA_HCP_500/HCP_4_FLICA/?h.pial.area.fsaverage.10mm.mgh']
['/home/mrstats/alblle/Projects/linked_ICA_HCP_500/HCP_4_FLICA/all_VBM.nii.gz']
['/home/mrstats/alblle/Projects/linked_ICA_HCP_500/ICA_jacobians/jacobians/all_jac_dets.nii.gz']
};

transformsIn = {'','','',''; 'log','','',''; '','','','';'','','',''; 'log','','',''; '','','',''; '','','',''};  % Log-transform MD and area. 
[Y,fileinfo] = flica_load(Yfiles, transformsIn);
fileinfo.shortNames = {'FA','MD','MO','Thickness','Area','VBM','JD'};


%% Set non-default options
% To see a list of options: run flica_parseoptions, with no arguments.
opts = struct();
opts.num_components = 100;
opts.maxits = 3000;


opts.calcFits = 'all'; % Be more careful, check F increases every iteration.
opts.plotConvergence=0;
opts.plotEta=0;
%% Run FLICA
Morig = flica(Y, opts);
%save(strcat(outdir,'Morig'),'Morig');

[M,weights] = flica_reorder(Morig); % Sort components sensibly
save(strcat(outdir,'M'),'M');
save(strcat(outdir,'weights'),'weights');



%% save everything!

flica_save_everything(outdir, M, fileinfo);



