#!/bin/bash


#GATHER DATAS AND UPSAMPLE TO 1MM FOR NICE VISUALIZATION.
datadir=~/..../flica_output



for mod in VBM FA MO MD MO JD
do
	if [ "$mod" = "VBM" ];
	then
		val=6
	fi
	if [ "$mod" = "JD" ];
	then
		val=7
	fi
	if [ "$mod" = "FA" ];
	then
		val=1
	fi
	if [ "$mod" = "MO" ];
	then
		val=2
	fi
	if [ "$mod" = "MD" ];
	then
		val=3
	fi

	for j in 0 1 2 5 6 23 24 28 54 88
	do
		echo $j
		fslroi $datadir/niftiOut_mi${val}.nii.gz ${mod}_$j.nii.gz $j 1
		tmpimg=${mod}_$j.nii.gz

		if [ "$mod" = "VBM" ];
		then
			flirt -interp nearestneighbour -in $tmpimg -ref $FSLDIR/data/standard/MNI152_T1_1mm_brain.nii.gz -applyisoxfm 1 -out $tmpimg
			fslmaths $tmpimg -mul $FSLDIR/data/standard/MNI152_T1_1mm_brain_mask.nii.gz $tmpimg
		elif [ "$mod" = "JD" ];	
		then
			flirt -interp nearestneighbour -in $tmpimg -ref $FSLDIR/data/standard/MNI152_T1_1mm_brain.nii.gz -applyisoxfm 1 -out $tmpimg
			fslmaths $tmpimg -mul $FSLDIR/data/standard/MNI152_T1_1mm_brain_mask.nii.gz $tmpimg
		else 
			flirt -interp nearestneighbour -in $tmpimg -ref $FSLDIR/data/standard/FMRIB58_FA-skeleton_1mm.nii.gz -applyisoxfm 1 -out $tmpimg
		fi
	done

	fslmerge -t all_${mod}.nii.gz ${mod}_0.nii.gz ${mod}_1.nii.gz ${mod}_2.nii.gz ${mod}_5.nii.gz ${mod}_6.nii.gz ${mod}_23.nii.gz ${mod}_24.nii.gz ${mod}_28.nii.gz ${mod}_54.nii.gz ${mod}_88.nii.gz
	rm ${mod}*
	
done










