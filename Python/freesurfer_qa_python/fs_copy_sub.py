import sys
import os
import shutil
from datetime import datetime
import numpy as np
import pandas as pd

server_dir = r'Z:\NVeADRC'
dest_dir = r'H:\LRCBH\Projects\ADRC QA\freesurfer'

#  STEP 1 : FIND SUBJECTS WHOSE DATA NEEDS TO BE COPIED BASED ON THE LATEST FOLDER
current_date = datetime.today().strftime('%m%d%Y')
adrc_server = [folder.name for folder in os.scandir(server_dir) if folder.is_dir() and 'ADRC' in folder.name
               and 'Phantom' not in folder.name]

adrc_dest = [folder.name for folder in os.scandir(dest_dir) if folder.is_dir() and 'fs_input' in folder.name]
if not adrc_dest:
    adrc_server_copy = adrc_server
else:
    adrc_dest_date = [datetime.strptime(input_folder[-8:], '%m%d%Y') for input_folder in adrc_dest]
    adrc_closest_date_idx = adrc_dest_date.index(min(adrc_dest_date, key=lambda sub: abs(
        sub - datetime.strptime(current_date, '%m%d%Y'))))
    dest_sublist = [img.split('.nii')[0] for img in os.listdir(os.path.join(dest_dir, adrc_dest[adrc_closest_date_idx]))
                    if img.endswith('.nii')]

    server_sublist = []
    adrc_server_modified = []
    for adrc_server_dir in adrc_server:
        t1_folders = [adrc_server_dir[5:9] + '_' + datetime.strptime(loc.name[-8:], '%Y%m%d').strftime('%m%d%Y') for loc
                      in
                      os.scandir(os.path.join(server_dir, adrc_server_dir)) if loc.is_dir() and 'MPRAGE' in loc.name]
        if len(t1_folders) == 1:
            server_sublist.append(t1_folders[0])
            adrc_server_modified.append(adrc_server_dir)
        elif len(t1_folders) > 1:
            for i in range(len(t1_folders)):
                server_sublist.append(t1_folders[i] + '_' + str(i + 1))
                adrc_server_modified.append(adrc_server_dir)

    adrc_server_date = [datetime.strptime(input_folder[5:13], '%m%d%Y') for input_folder in server_sublist]
    adrc_server_closest_date_idx = adrc_server_date.index(min(adrc_server_date, key=lambda sub: abs(
        sub - datetime.strptime(current_date, '%m%d%Y'))))

    if adrc_server_date[adrc_server_closest_date_idx] > datetime.strptime(adrc_dest[adrc_closest_date_idx][-8:],
                                                                          '%m%d%Y'):
        adrc_server_copy = [adrc_server_modified[index] for index in np.array([i for i, e in enumerate(server_sublist)
                                                                               if e not in set(dest_sublist)])]
    else:
        adrc_server_copy = []

    if not adrc_server_copy:
        print("No new ADRC subjects available for freesurfer analysis")
        sys.exit()

#  STEP 2 : COPY THE SUBJECTS FROM THE SERVER TO THE LOCAL MACHINE AND THEN NAME THE FOLDER BASED ON THE CURRENT DATE
dest_loc = os.path.join(dest_dir, 'fs_input_' + current_date)
if not os.path.exists(dest_loc):
    os.makedirs(dest_loc)

mprage_missing = []
date_all = []
input_loc = []
output_loc = []
copy_name_all = []
adrc_server_copy_new = []
for subdir in adrc_server_copy:
    mprage_folders = [loc.name for loc in os.scandir(os.path.join(server_dir, subdir)) if
                      loc.is_dir() and 'MPRAGE' in loc.name]
    sub_str = subdir[5:9]
    if len(mprage_folders) == 1:
        date_str = datetime.strptime(mprage_folders[0][-8:], '%Y%m%d').strftime('%m%d%Y')
        copy_name = sub_str + '_' + date_str + '.nii'
        nii_list = [img for img in os.listdir(os.path.join(server_dir, subdir, mprage_folders[0]))
                    if img.endswith('.nii')]
        if len(nii_list) == 0:
            mprage_missing.append(sub_str)
        source_name = os.path.join(server_dir, subdir, mprage_folders[0], 'output.nii')
        dest_name = os.path.join(dest_loc, copy_name)

        date_all.append(date_str)
        input_loc.append(source_name)
        output_loc.append(dest_name)
        copy_name_all.append(copy_name)
        adrc_server_copy_new.append(subdir)

        shutil.copy(source_name, dest_name)
    elif len(mprage_folders) > 1:
        for i in range(len(mprage_folders)):
            date_str = datetime.strptime(mprage_folders[i][-8:], '%Y%m%d').strftime('%m%d%Y')
            copy_name = sub_str + '_' + date_str + '_' + str(i+1) + '.nii'
            source_name = os.path.join(server_dir, subdir, mprage_folders[i], 'output.nii')
            dest_name = os.path.join(dest_loc, copy_name)

            date_all.append(date_str)
            input_loc.append(source_name)
            output_loc.append(dest_name)
            copy_name_all.append(copy_name)
            adrc_server_copy_new.append(subdir)

            nii_list = [img for img in os.listdir(os.path.join(server_dir, subdir, mprage_folders[i])) if
                        img.endswith('.nii')]
            if len(nii_list) == 0:
                mprage_missing.append(sub_str)
            shutil.copy(source_name, dest_name)

#  STEP 3 : CREATE A .TXT FILE TO RECORD THE SUBJECTS WITH MISSING T1 SCANS WITHIN THEM
copy_info = ['The subjects with missing MPRAGE data are: '] + mprage_missing
file_txt = open(os.path.join(dest_loc, 'fs_copy_info_' + current_date + '.txt'), 'w')
for item in copy_info:
    file_txt.write(item+"\n")
file_txt.close()

# STEP 4 : CREATE A EXCEL FILE THAT WILL RECORD THE DETAILS OF THE SUBJECTS COPIED THAT DAY
copy_name_all = [s.split('.nii')[0] for s in copy_name_all]
data_dict = {'Subject dir': adrc_server_copy_new, 'Freesurfer name': copy_name_all, 'Examdate': date_all,
             'Server location': input_loc, 'Local location': output_loc}
data_pd = pd.DataFrame(data_dict)
data_pd.to_excel(os.path.join(dest_loc, 'fs_data_info_' + current_date + '.xlsx'), index=False)

