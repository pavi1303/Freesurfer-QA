#!/bin/bash

# exec 2>/dev/null
export SUBJECTS_DIR="$FS_OUTPUT_DIR"
current_date=$(date +'%m%d%Y')

slice_start=35
slice_end=45

echo "Forming snapshots for the subjects in  $FS_OUTPUT_DIR"
subname=($(find "$FS_OUTPUT_DIR" -maxdepth 1 -type d -regex ".*/[0-9]+.*" -exec basename {} \;))
for subid in "${subname[@]}";do
	# Create the required directories if they do not exist
	dir=("${FS_OUTPUT_DIR}/QA_results_$current_date/${QA_FOLDER_NAME}_QA/QA_screenshots/$subid/whitematter"\
	 "${FS_OUTPUT_DIR}/QA_results_$current_date/${QA_FOLDER_NAME}_QA/QA_screenshots/$subid/skullstrip"\
	  "${FS_OUTPUT_DIR}/QA_results_$current_date/${QA_FOLDER_NAME}_QA/QA_screenshots/$subid/normalized"\
	   "${FS_OUTPUT_DIR}/QA_results_$current_date/${QA_FOLDER_NAME}_QA/QA_screenshots/$subid/aseg"\
	    "${FS_OUTPUT_DIR}/QA_results_$current_date/${QA_FOLDER_NAME}_QA/QA_screenshots/$subid/talaraich"\
		 "${FS_OUTPUT_DIR}/QA_results_$current_date/${QA_FOLDER_NAME}_QA/QA_screenshots/$subid/inflated"\
		  "${FS_OUTPUT_DIR}/QA_results_$current_date/${QA_FOLDER_NAME}_QA/QA_screenshots/$subid/curv"\
		   "${FS_OUTPUT_DIR}/QA_results_$current_date/${QA_FOLDER_NAME}_QA/QA_screenshots/$subid/parc")

    for folder in "${dir[@]}";do
		if [ -d "${folder}" ]; then
  			rm -rf "${folder}"
		fi
        mkdir -p "${folder}"
    done
	cd "${FS_OUTPUT_DIR}/$subid"
	echo "Taking screenshots for subject: $subid" 

	for ((slice = slice_start; slice <= slice_end; slice += 5));do
		# WHITE MATTER SEGMENTATION (CORONAL)
		xvfb-run -a -e /dev/null freeview -v mri/T1.mgz mri/brainmask.mgz:opacity=0.3 mri/wm.mgz:opacity=0.5\
		-f surf/lh.white:edgecolor=yellow:edgethickness=4 surf/lh.pial:edgecolor=red:edgethickness=4 surf/rh.white:edgecolor=yellow:edgethickness=4 surf/rh.pial:edgecolor=red:edgethickness=4\
		-viewport coronal -ras 0 0 0 -slice 128 128 $slice -layout 1 -cc -nocursor -ss ${dir[0]}/wm-c-$slice.png -quit
	done 
	for ((slices = slice_start; slices <= slice_end; slices += 10));do
		# SKULL STRIPPED IMAGES (CORONAL)
		xvfb-run -a -e /dev/null freeview mri/brainmask.mgz:opacity=1.0 -viewport coronal -ras 0 0 0 -slice 128 128 $slices -layout 1 -nocursor -ss ${dir[1]}/skullstrip-c-$slices.png -quit 
		# INTENSITY NORMALIZED IMAGES (CORONAL)
		xvfb-run -a -e /dev/null freeview -v mri/T1.mgz:opacity=1.0 -viewport coronal -ras 0 0 0 -slice 128 128 $slices -layout 1 -nocursor -ss ${dir[2]}/in-c-$slices.png -quit
		# AUTOMATIC SUBCORTICAL SEGMENTATION
		xvfb-run -a -e /dev/null freeview -v mri/brainmask.mgz:opacity=0.3 mri/aseg.mgz:opacity=0.8 -viewport coronal -ras 0 0 0 -slice 128 128 $slices -layout 1 -nocursor -ss ${dir[3]}/aseg-c-$slices.png -quit
	done

	# TALARAICH SPACE IMAGE - APPLYING TRANSFORMATION
	mri_convert mri/brainmask.mgz mri/brainmask_talaraich.mgz --apply_transform mri/transforms/talairach.xfm
	xvfb-run -a -e /dev/null freeview -v mri/brainmask_talaraich.mgz:opacity=1.0 -viewport coronal -ras 0 0 0 -slice 128 128 128 -layout 1 -nocursor -ss ${dir[4]}/talaraich-c-128.png -quit
	xvfb-run -a -e /dev/null freeview -v mri/brainmask_talaraich.mgz:opacity=1.0 -viewport sagittal -ras 0 0 0 -slice 128 128 128 -layout 1 -nocursor -ss ${dir[4]}/talaraich-s-128.png -quit
	xvfb-run -a -e /dev/null freeview -v mri/brainmask_talaraich.mgz:opacity=1.0 -viewport axial -ras 0 0 0 -slice 128 128 128 -layout 1 -nocursor -ss ${dir[4]}/talaraich-a-128.png -quit

	# INFLATED SURFACE - 3D VIEW
	xvfb-run -a -e /dev/null freeview -f surf/lh.inflated:curvature_method=off -viewport 3d -ras 0 0 0 -layout 1 -nocursor -ss ${dir[5]}/lh_lat.png -quit
	xvfb-run -a -e /dev/null freeview -f surf/lh.inflated:curvature_method=off -cam azimuth 180 -viewport 3d -ras 0 0 0 -layout 1 -nocursor -ss ${dir[5]}/lh_med.png -quit
	xvfb-run -a -e /dev/null freeview -f surf/lh.inflated:curvature_method=off -cam elevation -90 -viewport 3d -ras 0 0 0 -layout 1 -nocursor -ss ${dir[5]}/lh_inf.png -quit
	xvfb-run -a -e /dev/null freeview -f surf/rh.inflated:curvature_method=off -cam azimuth 180 -viewport 3d -ras 0 0 0 -layout 1 -nocursor -ss ${dir[5]}/rh_lat.png -quit
	xvfb-run -a -e /dev/null freeview -f surf/rh.inflated:curvature_method=off -viewport 3d -ras 0 0 0 -layout 1 -nocursor -ss ${dir[5]}/rh_med.png -quit
	xvfb-run -a -e /dev/null freeview -f surf/rh.inflated:curvature_method=off -cam elevation 270 -viewport 3d -ras 0 0 0 -layout 1 -nocursor -ss ${dir[5]}/rh_inf.png -quit

	# INFLATED SURFACE WITH CURV - 3D VIEW
	xvfb-run -a -e /dev/null freeview -f surf/lh.inflated:curvature=surf/lh.curv -viewport 3d -ras 0 0 0 -layout 1 -nocursor -ss ${dir[6]}/lh_lat.png -quit
	xvfb-run -a -e /dev/null freeview -f surf/lh.inflated:curvature=surf/lh.curv -cam azimuth 180 -viewport 3d -ras 0 0 0 -layout 1 -nocursor -ss ${dir[6]}/lh_med.png -quit
	xvfb-run -a -e /dev/null freeview -f surf/lh.inflated:curvature=surf/lh.curv -cam elevation -90 -viewport 3d -ras 0 0 0 -layout 1 -nocursor -ss ${dir[6]}/lh_inf.png -quit
	xvfb-run -a -e /dev/null freeview -f surf/rh.inflated:curvature=surf/rh.curv -cam azimuth 180 -viewport 3d -ras 0 0 0 -layout 1 -nocursor -ss ${dir[6]}/rh_lat.png -quit
	xvfb-run -a -e /dev/null freeview -f surf/rh.inflated:curvature=surf/rh.curv -viewport 3d -ras 0 0 0 -layout 1 -nocursor -ss ${dir[6]}/rh_med.png -quit
	xvfb-run -a -e /dev/null freeview -f surf/rh.inflated:curvature=surf/rh.curv -cam elevation 270 -viewport 3d -ras 0 0 0 -layout 1 -nocursor -ss ${dir[6]}/rh_inf.png -quit

	# PARC - 3D VIEW
	xvfb-run -a -e /dev/null freeview -f surf/lh.orig:annot=label/lh.aparc.annot -viewport 3d -ras 0 0 0 -layout 1 -nocursor -ss ${dir[7]}/parc_lh_lat.png -quit
	xvfb-run -a -e /dev/null freeview -f surf/lh.orig:annot=label/lh.aparc.annot -cam azimuth 180 -viewport 3d -ras 0 0 0 -layout 1 -nocursor -ss ${dir[7]}/parc_lh_med.png -quit
	xvfb-run -a -e /dev/null freeview -f surf/lh.orig:annot=label/lh.aparc.annot -cam elevation -90 -viewport 3d -ras 0 0 0 -layout 1 -nocursor -ss ${dir[7]}/parc_lh_inf.png -quit
	xvfb-run -a -e /dev/null freeview -f surf/rh.orig:annot=label/rh.aparc.annot -cam azimuth 180 -viewport 3d -ras 0 0 0 -layout 1 -nocursor -ss ${dir[7]}/parc_rh_lat.png -quit
	xvfb-run -a -e /dev/null freeview -f surf/rh.orig:annot=label/rh.aparc.annot -viewport 3d -ras 0 0 0 -layout 1 -nocursor -ss ${dir[7]}/parc_rh_med.png -quit
	xvfb-run -a -e /dev/null freeview -f surf/rh.orig:annot=label/rh.aparc.annot -cam elevation 270 -viewport 3d -ras 0 0 0 -layout 1 -nocursor -ss ${dir[7]}/parc_rh_inf.png -quit
	
	echo "Completed taking screenshots for subject: $subid" 
	find "${FS_OUTPUT_DIR}/QA_results_$current_date/${QA_FOLDER_NAME}_QA/QA_screenshots/$subid" -type d -empty -delete
done

# COMMENTS
# aseg-templh and aseg-temprh ss has not been included in this script since idk what those represent. Also, they are in sagittal orientation.


