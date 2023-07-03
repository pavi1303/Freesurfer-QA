#!/bin/bash

export SUBJECTS_DIR="$FS_OUTPUT_DIR"
export QA_TOOLS=/mnt/c/QAtools_v1.2
current_date=$(date +'%m%d%Y')
subname=$(find "$FS_OUTPUT_DIR" -maxdepth 1 -type d -regex ".*/[0-9]+.*" -exec basename {} \;)

for subid in "${subname[@]}"; do
$QA_TOOLS/recon_checker -s ${subid} -no-snaps -nocheck-aseg -nocheck-status -nocheck-outputFOF
done
mv "$FS_OUTPUT_DIR/QA"/* "$FS_OUTPUT_DIR/QA_results_$current_date/"
rmdir "$FS_OUTPUT_DIR/QA"
recon_summary_file=$(find "$FS_OUTPUT_DIR/QA_results_$current_date" -maxdepth 1 -name "*summary*") # Get the full path of the .log file from the QA old output
n_sub=$(wc -w <<< "$subname") # Get the number of subjects (This will determine the nubmer of rows that need to be extracted from the .log file)
tail -n +16 "$recon_summary_file" | head -n $((n_sub + 1)) > "$FS_OUTPUT_DIR/QA_results_$current_date/temp.txt" # Create the subset temp.txt file
cat "$FS_OUTPUT_DIR/QA_results_$current_date/temp.txt" | tr -s "\\t" "," > "$FS_OUTPUT_DIR/QA_results_$current_date/qatools_results_old_$current_date.csv" # Convert the .txt to a .csv
rm "$FS_OUTPUT_DIR/QA_results_$current_date/temp.txt"

