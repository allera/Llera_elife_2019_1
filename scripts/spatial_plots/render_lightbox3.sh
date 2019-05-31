#!/bin/bash


for mod in VBM FA MO MD JD 
do
	
		for j in 0 1 2 3 4 5 6 7 8 9 #0 1 2 8 15 48
		do
			echo $j
			fslroi Renormalized_all_${mod}.nii.gz Renormalized_all_${mod}_${j}.nii.gz $j 1
			tmpimg=Renormalized_all_${mod}_${j}.nii.gz

			if [ "$mod" = "VBM" ];
			then
				overlay 0 0 -c $FSLDIR/data/standard/MNI152_T1_1mm.nii.gz -a $tmpimg 2 6 $tmpimg -2.3 -6 ${tmpimg}
				
			elif [ "$mod" = "JD" ];
			then
				overlay 0 0 -c $FSLDIR/data/standard/MNI152_T1_1mm.nii.gz -a $tmpimg 2 6 $tmpimg -2.3 -6 ${tmpimg}	 
				
			else #DTI
				tbss_fill $tmpimg 2 $FSLDIR/data/standard/FMRIB58_FA_1mm.nii.gz dummy.nii.gz -n
				rm $tmpimg
				mv dummy.nii.gz $tmpimg

				#fslmaths $tmpimg -mul $WD/bin_squeleton $tmpimg
				
				overlay 0 0 -c $FSLDIR/data/standard/FMRIB58_FA_1mm.nii.gz 0 8676 $tmpimg 0.05 0.5  $tmpimg -0.05 -0.5 ${tmpimg}
			       

			fi

			fslroi $tmpimg ${tmpimg} 0 -1 0 -1 30 120 #10 70 12 85 20 50

			slicer ${tmpimg} -n -u -S 15 100000 ${mod}_$j.ppm 

			convert ${mod}_${j}.ppm lightbox_${mod}_$j.png
			rm ${mod}_${j}.ppm
			rm $tmpimg 
		done
done
	


			

