#!/bin/bash

current_date=$(date +'%m%d%Y')
qa_tools_dir="/mnt/c/Users/PAVI-HOME/Dropbox/PC/Documents/Github/qatools-python"
qa_output_dir="$FS_OUTPUT_DIR/QA_results_$current_date/${QA_FOLDER_NAME}_QA"
subname=($(find "$FS_OUTPUT_DIR" -maxdepth 1 -type d -regex ".*/[0-9]+.*" -exec basename {} \;))

python3 "$qa_tools_dir/qatools.py" --subjects_dir "$FS_OUTPUT_DIR" --output_dir "$qa_output_dir" --subjects "${subname[@]}"
mv "$qa_output_dir/qatools-results.csv" "$qa_output_dir/qatools_results_new_${QA_FOLDER_NAME}_QA_$current_date.csv"

