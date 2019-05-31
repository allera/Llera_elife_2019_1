#!/bin/bash

#less than 12 minutes

# data_4_flica_dir  must match the one used in script 1!!!!!!!!!!!!!!!!!!!!!!


data_4_flica_dir=/home/..../Flica_HCP500

ref_mask_dir=/home/..../ref_and_mask

HCP=/home/.../S500 


for modality in VBM JD FA MO MD 
do

	echo ${modality}

	output_script=${data_4_flica_dir}/subscripts/downsample_${modality}.sh

	input_image=${data_4_flica_dir}/data4d/${modality}/${modality}.nii.gz

	output_image=${data_4_flica_dir}/data4d/${modality}/${modality}.nii.gz

	if [ "${modality}" == "FA" ] || [ "${modality}" == "MD" ] || [ "${modality}" == "MO" ]; then

		resolution=2
		reference=${ref_mask_dir}/mean_FA_skeleton_mask_2mm.nii.gz
		mask=${ref_mask_dir}/mean_FA_skeleton_mask_2mm.nii.gz

	fi


	if [ "${modality}" == "JD" ] || [ "${modality}" == "VBM" ]; then

		resolution=4
		reference=${ref_mask_dir}/MNI152_T1_4mm_brain_mask.nii.gz
		mask=${ref_mask_dir}/MNI152_T1_4mm_brain_mask.nii.gz

	fi


	echo flirt -applyisoxfm ${resolution} -in ${input_image} -ref ${reference} -out ${output_image} >>  ${output_script} 

	echo >> ${output_script} 

	echo fslmaths ${output_image} -mul ${mask} ${output_image} >>  ${output_script} 

	chmod 744 ${output_script} 
	qsub -l walltime=24:00:00,mem=32gb ${output_script}


		


done


#./script2_downsample.sh

