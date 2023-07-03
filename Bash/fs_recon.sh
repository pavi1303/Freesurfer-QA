#!/bin/sh

cd $FS_INPUT_DIR

ls *.nii | parallel --jobs 20 recon-all -qcache -subjid {.} -i {} -all

# Move all the files and folders except for the .nii files
mv "$FS_INPUT_DIR"/* "$FS_OUTPUT_DIR/"
mv "$FS_OUTPUT_DIR"/*.nii "$FS_INPUT_DIR/"




