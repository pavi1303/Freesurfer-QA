#!/bin/sh

# ------------------------------------------------------------------------------------------- #
#           Getting the location of the nifti files to be run through freesurfer              #
# ------------------------------------------------------------------------------------------- #
echo "Enter the freesurfer input location with nii files: "
read fs_input_dir
# ------------------------------------------------------------------------------------------- #
#                Create the fs_output_dir automatically if it doesn't exist                   #
# ------------------------------------------------------------------------------------------- #
fs_output_dir=${fs_input_dir//fs_input/fs_output}
mkdir -p "$fs_output_dir"
# ------------------------------------------------------------------------------------------- #
#     Export the variables required to be called by other scripts throughout this script      #
# ------------------------------------------------------------------------------------------- #
export SUBJECTS_DIR=$fs_input_dir 
export FS_INPUT_DIR="$fs_input_dir"
export FS_OUTPUT_DIR="$fs_output_dir"
# ------------------------------------------------------------------------------------------- #
#                         Run the freesurfer recon-all process                                #
# ------------------------------------------------------------------------------------------- #
bash "$FS_SCRIPTS_DIR/fs_recon.sh" 
# ------------------------------------------------------------------------------------------- #
#                               Check for hard failures                                       #
# ------------------------------------------------------------------------------------------- #
bash "$FS_SCRIPTS_DIR/fs_hard_failure_check.sh"
