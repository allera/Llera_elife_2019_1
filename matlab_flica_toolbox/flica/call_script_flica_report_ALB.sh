#!/bin/bash

path2flica=/home/mrstats/alblle/Toolboxes/flica
path2flica_output=/home/mrstats/alblle/Projects/linked_ICA_HCP_500/report_corr_flica_output_100ICAS_2
path2freesurfer=/opt/freesurfer/5.3/bin/freesurfer

#export FREESURFER_HOME=$path2freesurfer
#source $FREESURFER_HOME/SetUpFreeSurfer.sh

$path2flica/flica_report.sh $path2flica_output



#use as:
#qsub -l walltime=24:00:00,mem=32gb /home/mrstats/alblle/Projects/linked_ICA_HCP_500/call_script_flica_report_ALB.sh


#flica_average_autodetect.sh  --> lines 27 to 37 --> addpath to fs installation, /.../freesurfer/subjects/  
#surfaces_to_volumes.sh  --> lines 13 to 17 --> addpath to fs installation, /.../freesurfer/subjects/  
#render_surfaces_asssembles.sh  --> lines 31,41,49 waitfor_quite not found, use wait instead. (simply type wait and comment waitfor-wuite line.)
