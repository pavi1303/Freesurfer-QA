#!/bin/bash
echo "Enter the freesurfer input location with nii files: "
read fs_input_dir
fs_output_dir=${fs_input_dir//fs_input/fs_output}
echo "Has QA already been performed? If Yes, enter 1. Else enter 2"
read qa_status
declare -i qa_status
if (( $qa_status == 1 )); then
    qa_folder_name="post"
else
    qa_folder_name="prior"
fi
# ------------------------------------------------------------------------------------------- #
#                               Export the variables again                                    #
# ------------------------------------------------------------------------------------------- #
export SUBJECTS_DIR=$fs_input_dir 
export FS_INPUT_DIR="$fs_input_dir"
export FS_OUTPUT_DIR="$fs_output_dir"
export QA_FOLDER_NAME="$qa_folder_name"
# ------------------------------------------------------------------------------------------- #
#                                freeview screenshots                                         #
# ------------------------------------------------------------------------------------------- #
bash "$FS_SCRIPTS_DIR/freeview_snapshot.sh"
# ------------------------------------------------------------------------------------------- #
#                                SNR results - QA new                                         #
# ------------------------------------------------------------------------------------------- #
bash "$FS_SCRIPTS_DIR/fs_qa_new.sh"
# ------------------------------------------------------------------------------------------- #
#                                SNR results - QA old                                         #
# ------------------------------------------------------------------------------------------- #
bash "$FS_SCRIPTS_DIR/fs_qa_old.sh"
# ------------------------------------------------------------------------------------------- #
#                       Generate the statistics - only after QA                               #
# ------------------------------------------------------------------------------------------- #
if (( $qa_status == 1)); then
    bash "$FS_SCRIPTS_DIR/gen_stats_csv.sh" # Generate the statistics file only if the QA has been completed
else
    :
fi
