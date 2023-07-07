#!/bin/bash

current_date=$(date +'%m%d%Y')
stats_output_dir="$FS_OUTPUT_DIR/QA_results_$current_date/stats_csv"
mkdir -p $stats_output_dir
subname=($(find "$FS_OUTPUT_DIR" -maxdepth 1 -type d -regex ".*/[0-9]+.*" -exec basename {} \;))
export SUBJECTS_DIR="$FS_OUTPUT_DIR"

# White matter parcellation
asegstats2table --subjects "${subname[@]}" -d comma --meas volume --skip --statsfile wmparc.stats --all-segs --tablefile "$stats_output_dir/wmparc_volume.csv"
asegstats2table --subjects "${subname[@]}" -d comma --meas mean --skip --statsfile wmparc.stats --all-segs --tablefile "$stats_output_dir/wmparc_mean.csv"

# aseg stats
asegstats2table --subjects "${subname[@]}" -d comma --meas volume --skip --tablefile "$stats_output_dir/aseg_volume.csv"
asegstats2table --subjects "${subname[@]}" -d comma --meas mean --skip --statsfile aseg.stats --all-segs --tablefile "$stats_output_dir/aseg_mean.csv"

# Volume, area, thickness and mean curvature measurements based on the Desikan-Killiany Atlas
aparcstats2table --subjects "${subname[@]}" --hemi lh -d comma -m volume --skip --tablefile "$stats_output_dir/aparc_volume_lh.csv"
aparcstats2table --subjects "${subname[@]}" --hemi lh -d comma -m area --skip --tablefile "$stats_output_dir/aparc_area_lh.csv"
aparcstats2table --subjects "${subname[@]}" --hemi lh -d comma -m thickness --skip --tablefile "$stats_output_dir/aparc_thickness_lh.csv"
aparcstats2table --subjects "${subname[@]}" --hemi lh -d comma -m meancurv --skip --tablefile "$stats_output_dir/aparc_meancurv_lh.csv"
aparcstats2table --subjects "${subname[@]}" --hemi rh -d comma -m volume --skip --tablefile "$stats_output_dir/aparc_volume_rh.csv"
aparcstats2table --subjects "${subname[@]}" --hemi rh -d comma -m area --skip --tablefile "$stats_output_dir/aparc_area_rh.csv"
aparcstats2table --subjects "${subname[@]}" --hemi rh -d comma -m thickness --skip --tablefile "$stats_output_dir/aparc_thickness_rh.csv"
aparcstats2table --subjects "${subname[@]}" --hemi rh -d comma -m meancurv --skip --tablefile "$stats_output_dir/aparc_meancurv_rh.csv"

# Volume, area, thickness and mean curvature measurements based on the Broadmann Area exvivo paracellation
# aparcstats2table --subjects "${subname[@]}" --hemi lh -d comma -p BA_exvivo -m volume --skip --tablefile "$stats_output_dir/BA_volume_lh.csv"
# aparcstats2table --subjects "${subname[@]}" --hemi lh -d comma -p BA_exvivo -m area --skip --tablefile "$stats_output_dir/BA_area_lh.csv"
# aparcstats2table --subjects "${subname[@]}" --hemi lh -d comma -p BA_exvivo -m thickness --skip --tablefile "$stats_output_dir/BA_thickness_lh.csv"
# aparcstats2table --subjects "${subname[@]}" --hemi lh -d comma -p BA_exvivo -m meancurv --skip --tablefile "$stats_output_dir/BA_meancurv_lh.csv"
# aparcstats2table --subjects "${subname[@]}" --hemi rh -d comma -p BA_exvivo -m volume --skip --tablefile "$stats_output_dir/BA_volume_rh.csv"
# aparcstats2table --subjects "${subname[@]}" --hemi rh -d comma -p BA_exvivo -m area --skip --tablefile "$stats_output_dir/BA_area_rh.csv"
# aparcstats2table --subjects "${subname[@]}" --hemi rh -d comma -p BA_exvivo -m thickness --skip --tablefile "$stats_output_dir/BA_thickness_rh.csv"
# aparcstats2table --subjects "${subname[@]}" --hemi rh -d comma -p BA_exvivo -m meancurv --skip --tablefile "$stats_output_dir/BA_meancurv_rh.csv"

# # Volume, area, thickness and mean curvature measurements based on the Destrieux Atlas (a2009s)
# aparcstats2table --subjects "${subname[@]}" --hemi lh -d comma -p aparc.a2009s -m volume --skip --tablefile "$stats_output_dir/a2009s_volume_lh.csv"
# aparcstats2table --subjects "${subname[@]}" --hemi lh -d comma -p aparc.a2009s -m area --skip --tablefile "$stats_output_dir/a2009s_area_lh.csv"
# aparcstats2table --subjects "${subname[@]}" --hemi lh -d comma -p aparc.a2009s -m thickness --skip --tablefile "$stats_output_dir/a2009s_thickness_lh.csv"
# aparcstats2table --subjects "${subname[@]}" --hemi lh -d comma -p aparc.a2009s -m meancurv --skip --tablefile "$stats_output_dir/a2009s_meancurv_lh.csv"
# aparcstats2table --subjects "${subname[@]}" --hemi rh -d comma -p aparc.a2009s -m volume --skip --tablefile "$stats_output_dir/a2009s_volume_rh.csv"
# aparcstats2table --subjects "${subname[@]}" --hemi rh -d comma -p aparc.a2009s -m area --skip --tablefile "$stats_output_dir/a2009s_area_rh.csv"
# aparcstats2table --subjects "${subname[@]}" --hemi rh -d comma -p aparc.a2009s -m thickness --skip --tablefile "$stats_output_dir/a2009s_thickness_rh.csv"
# aparcstats2table --subjects "${subname[@]}" --hemi rh -d comma -p aparc.a2009s -m meancurv --skip --tablefile "$stats_output_dir/a2009s_meancurv_rh.csv"
#done

fs_output_parent="$(dirname "$FS_OUTPUT_DIR")"
fs_output_last_date=$(basename "$FS_OUTPUT_DIR" | tail -c 9)
stats_copy_dir="$fs_output_parent/stats_csv/$fs_output_last_date"
mkdir -p $stats_copy_dir
cp -R "$stats_output_dir"/* "$stats_copy_dir"
