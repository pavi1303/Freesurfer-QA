#!/bin/bash

current_date=$(date +'%m%d%Y')
filename="recon_status_hard_failures_$current_date.txt"
mkdir -p "$FS_OUTPUT_DIR/QA_results_$current_date"
if [ -f "$FS_OUTPUT_DIR/QA_results_$current_date/$filename" ]; then
  rm "$FS_OUTPUT_DIR/QA_results_$current_date/$filename"
fi
touch "$FS_OUTPUT_DIR/QA_results_$current_date/$filename" 
for D in $(find $FS_OUTPUT_DIR -maxdepth 1 -type d -regex ".*/[0-9]+.*");do
  subdir="${D}/scripts" 
  if [ -d "$subdir" ]
  then
    recon_status_file="${subdir}/recon-all-status.log"
    recon_status=$(tail -n 1 "$recon_status_file")
    echo "$recon_status">>"$FS_OUTPUT_DIR/QA_results_$current_date/$filename"
  else
    :
  fi 
done
