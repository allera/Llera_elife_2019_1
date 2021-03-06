#!/bin/bash

#run in HCP500
data_4_flica_dir=/home/..../Flica_HCP500
subjects_list=/home/..../HCP500_subjects_list_clean.txt


HCP=/home/..../S500 


mkdir ${data_4_flica_dir}

cp ${subjects_list} ${data_4_flica_dir}

mkdir ${data_4_flica_dir}/data4d

mkdir ${data_4_flica_dir}/path2_cluster_data

mkdir ${data_4_flica_dir}/subscripts

for modality in FA MO MD VBM JD PA CT
do

	echo ${modality}

	#build files containg the subject files to be concatenated into 4d volumes
	for subj in $(cat ${subjects_list})
	do
		if [ "${modality}" == "FA" ] || [ "${modality}" == "MD" ] || [ "${modality}" == "MO" ]; then

			echo ${HCP}/${subj}/T1w/Diffusion/TBSS/${modality}_skeletonised_${subj}.nii.gz >> ${data_4_flica_dir}/path2_cluster_data/paths2_${modality}.txt
		fi

		if [ "${modality}" == "VBM" ]; then

			echo ${HCP}/${subj}/T1w/VBM/VBM_${subj}_s4.nii.gz >> ${data_4_flica_dir}/path2_cluster_data/paths2_${modality}.txt
		fi

		if [ "${modality}" == "JD" ]; then

			echo ${HCP}/${subj}/MNINonLinear/xfms/NonlinearRegJacobians.nii.gz >> ${data_4_flica_dir}/path2_cluster_data/paths2_${modality}.txt
		fi

		if [ "${modality}" == "PA" ]; then

			echo ${HCP}/${subj}/T1w/FS_recon_all_fsaverage/surf/rh.thickness.fwhm10.fsaverage.mgh >> ${data_4_flica_dir}/path2_cluster_data/paths2_rh_thickness.txt

			echo ${HCP}/${subj}/T1w/FS_recon_all_fsaverage/surf/lh.thickness.fwhm10.fsaverage.mgh >> ${data_4_flica_dir}/path2_cluster_data/paths2_lh_thickness.txt
		fi

		if [ "${modality}" == "CT" ]; then

			echo ${HCP}/${subj}/T1w/FS_recon_all_fsaverage/surf/rh.area.pial.fwhm10.fsaverage.mgh >> ${data_4_flica_dir}/path2_cluster_data/paths2_rh_pial_area.txt

			echo ${HCP}/${subj}/T1w/FS_recon_all_fsaverage/surf/lh.area.pial.fwhm10.fsaverage.mgh >> ${data_4_flica_dir}/path2_cluster_data/paths2_lh_pial_area.txt
			
		fi

	done

	#make folder per feature
	mkdir ${data_4_flica_dir}/data4d/${modality}


	#build scripts to concatenate each subject data into 4 dim vols (concat_modality.sh)
	if [ "${modality}" == "CT" ]; then 

		echo mri_concat --o ${data_4_flica_dir}/data4d/CT/rh_thickness_whm10_fsaverage.mgh --f ${data_4_flica_dir}/path2_cluster_data/paths2_rh_thickness.txt >>  ${data_4_flica_dir}/subscripts/concat_${modality}_1.sh

		echo mri_concat --o ${data_4_flica_dir}/data4d/CT/lh_thickness_whm10_fsaverage.mgh --f ${data_4_flica_dir}/path2_cluster_data/paths2_lh_thickness.txt >>  ${data_4_flica_dir}/subscripts/concat_${modality}_2.sh

	elif [ "${modality}" == "PA" ]; then

		echo mri_concat --o ${data_4_flica_dir}/data4d/PA/rh_pial_area_whm10_fsaverage.mgh --f ${data_4_flica_dir}/path2_cluster_data/paths2_rh_pial_area.txt >>  ${data_4_flica_dir}/subscripts/concat_${modality}_1.sh

		echo mri_concat --o ${data_4_flica_dir}/data4d/PA/lh_pial_area_whm10_fsaverage.mgh --f ${data_4_flica_dir}/path2_cluster_data/paths2_lh_pial_area.txt >>  ${data_4_flica_dir}/subscripts/concat_${modality}_2.sh

	
	elif [ "${modality}" == "FA" ] || [ "${modality}" == "MD" ] || [ "${modality}" == "MO" ] || [ "${modality}" == "VBM" ] || [ "${modality}" == "JD" ]; then

		echo fslmerge -t ${data_4_flica_dir}/data4d/${modality}/${modality}.nii.gz `cat ${data_4_flica_dir}/path2_cluster_data/paths2_${modality}.txt` >>  ${data_4_flica_dir}/subscripts/concat_${modality}.sh
	
	fi



	if [ "${modality}" == "CT" ] || [ "${modality}" == "PA" ]; then 

		chmod 744 ${data_4_flica_dir}/subscripts/concat_${modality}_1.sh
		qsub -l walltime=24:00:00,mem=32gb ${data_4_flica_dir}/subscripts/concat_${modality}_1.sh

		chmod 744 ${data_4_flica_dir}/subscripts/concat_${modality}_2.sh
		qsub -l walltime=24:00:00,mem=32gb ${data_4_flica_dir}/subscripts/concat_${modality}_2.sh

	elif [ "${modality}" == "FA" ] || [ "${modality}" == "MD" ] || [ "${modality}" == "MO" ] || [ "${modality}" == "VBM" ] || [ "${modality}" == "JD" ]; then

		chmod 744 ${data_4_flica_dir}/subscripts/concat_${modality}.sh
		qsub -l walltime=24:00:00,mem=32gb ${data_4_flica_dir}/subscripts/concat_${modality}.sh
	
	fi



done


#./script1_gather_data_4_flica.sh

