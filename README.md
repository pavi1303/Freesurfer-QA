## Table of Contents
- [Introduction](#Introduction)
- [Requirements](#Requirements)
- [Bash scripts](#Bash-scripts)
- [Python scripts](#Python-scripts)
- [Usage](#Usage)
- [References](#References)
- [Contact and software version](#Contact-and-software-version)

# Introduction
<a name="Introduction"></a>
Contains all the bash scripts and python scripts to perform the Freesurfer QA analysis, generate screenshots, calculate SNR, and generate the various stats measures.

# Requirements
<a name="Requirements"></a>
1. [Freesurfer v6 and later](https://surfer.nmr.mgh.harvard.edu/pub/dist/)
2. Python 3 any stable version.
3. [QA-tools python](https://github.com/Deep-MI/fsqc) and its dependencies
4. [QAtools](https://surfer.nmr.mgh.harvard.edu/fswiki/QATools) and its dependencies
   
## Bash scripts
<a name="Bash-scripts"></a>
### Main script
1. ***freesurfer_run_part1.sh*** - Runs the Freesurfer recon-all pipeline and then records the presence of any hard failures.
2. ***freesurfer_run_part2.sh*** - This performs the QA analysis (old and new), takes screenshots, and then generates the stats file that hosts all the volumetric measurements. This forms two folders - prior or post QA depending on the status of the QA completion.
### Auxiliary scripts
1. ***fs_recon.sh*** - Runs the Freesurfer recon-all pipeline for all the NIFTI images in the input folder.
2. ***fs_hard_failure_check.sh*** - Extracts the recon-all-status.log file for all the subjects run through the Freesurfer pipeline and appends the result to a .txt file.
3. ***freeview_snapshot.sh*** - Scroll through all the subjects to generate screenshots of different processes in the recon-all pipeline (intensity normalization, skull stripping, white matter segmentation, cortical segmentation, etc.). This uses the latest freeview tool to create and save the screenshots instead of using Tksurfer or Tkmedit.
4. ***fs_qa_new.sh*** - This uses the latest [QA-tools python](https://github.com/Deep-MI/fsqc) to compute the various features like SNR, number of holes, etc., The screenshots module is not used since we already obtain them using freeview, only the features are calculated.
5. ***fs_qa_old.sh*** - Calculates the SNR and similar features using the old [QAtools](https://surfer.nmr.mgh.harvard.edu/fswiki/QATools) that was originally developed for Freesurfer V5.3. This tool is currently deprecated but I'm calculating the features to see how far off they're compared to the newer python equivalent used in *fs_qa_new.sh*
6. ***gen_stats_csv.sh*** - This creates a csv file with all the volumetric measurements (area, curvature, volume). This file is only run after the QA process and thus will be present only in the post QA folder. 

## Python scripts
<a name="Python-scripts"></a>
1. ***fs_copy_sub.py*** - This was developed for personal conversion of the T1 scans located and naming them according to the convention **studyID_examdate.nii**. These subjects were all placed in a folder named **fs_input_todaysdate** which formed the input folder for the bash scripts. This script also creates a *Microsoft Excel file* that will host the original name, converted name, and exam date of the respective NIFTI files. You will not need this file unless you encounter a similar conversion scenario.
2. ***gen_QA_html.py*** - This generates one HTML file with the results of the screenshots generated by *freeview_snapshot.sh*. This is for visual QA to analyze the effectiveness of the automated Freesurfer pipeline and to decide/intervene necessarily.

## Usage
<a name="Usage"></a>
### STEP 1
Run the freesurfer_run_part1.sh script. Here, provide the user location of the NIFTI files that need to be run through Freesurfer. This will perform the recon-all pipeline for all the NIFTI files in that directory and will check and save the status of hard failures as a .txt file. 
### STEP 2
The next step is to run the freesurfer_run_part2.sh. This script has two user-defined inputs - (1) same NIFTI files directory used in step 1, and (2) Enter 1 if the QA process has been completed or enter 2 if it has not been completed yet. This status variable dictates the prior_QA or post_QA naming convention in the QA folder. Initially enter 2 and then obtain the results for the prior QA analysis.
### STEP 3
The next step is to perform a soft failure check and adjustment (check intensity normalization, skull stripping, white matter, and cortical/subcortical segmentations) and edit the white edit segmentations if needed which is completely subjective. After this, the freesurfer_run_part2.sh is run again and now the user input (2) is 1. This will form the post_QA analysis results. 
### STEP 4
The last step is to form one QA HTML file per subject for both prior and post-QA. Here, input the location of the folder that has all the screenshots generated by freeview tool in Freesurfer. The process of integrating this within bash to make it more seamless from start to stop is being pursued and will be updated in the near future.
## Example folder structure
## Input directory
![Input file structure with NIFTI files](https://github.com/pavi1303/Freesurfer-QA/blob/main/images/input%20structure.png)
## Output directory
### Overall output structure showing prior, post QA results and stats csv for post QA
![Overall output structure](https://github.com/pavi1303/Freesurfer-QA/blob/main/images/Overall%20output%20structure%201.png)
### recon-all output structure
![Overall output structure](https://github.com/pavi1303/Freesurfer-QA/blob/main/images/recon-all%20output%20structure.png)
### Overall QA output structure showing the calculated features, screenshots, and HTML for both prior and post QA
![Overall QA output structure](https://github.com/pavi1303/Freesurfer-QA/blob/main/images/Overall%20output%20structure%202.png)
### Freeview tool snapshot structure
![Freeview snapshot structure](https://github.com/pavi1303/Freesurfer-QA/blob/main/images/Freeview%20snapshot%20structure.png)
### QA HTML structure
![QA HTML structure](https://github.com/pavi1303/Freesurfer-QA/blob/main/images/QA%20html%20structure.png)
### stats csv structure
![stats structure](https://github.com/pavi1303/Freesurfer-QA/blob/main/images/stats%20structure.png)
## References
<a name="References"></a>
1. [Freesurfer wiki](https://surfer.nmr.mgh.harvard.edu/fswiki) - Contains all the necessary information including installation instructions, tutorials, and other relevant documentation.
2. [Recon-all output description](https://surfer.nmr.mgh.harvard.edu/fswiki/ReconAllTableStableV6.0) - Holds a detailed description of all the input and output files obtained at every step of the recon-all pipeline. It has been updated only until v6 on the Freesurfer website.
3. [QAtools](https://surfer.nmr.mgh.harvard.edu/fswiki/QATools) - QA tools originally developed for Freesurfer v5.3 and is currently deprecated. Nevertheless, it performs a comprehensive QA analysis.
4. [QA-tools python](https://github.com/Deep-MI/fsqc) - Latest QA tools for Freesurfer > v6 based on python. It doesn't provide a comprehensive set of screenshots unlike the [QAtools](https://surfer.nmr.mgh.harvard.edu/fswiki/QATools).

## Contact and software version
<a name="Contact-and-software-version"></a>
1. If you have any questions, or suggestions you might have please reach out to pavithran.giriprakash@gmail.com
2. Freesurfer 7.3.2 and Python 3.8.10 were used in the above process. 
