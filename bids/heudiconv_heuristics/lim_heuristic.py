# Heuristics file 
# Author: Finn Lennartsson 
# Date: 2021-03-15

import os

def create_key(template, outtype=('nii.gz',), annotation_classes=None):
    if template is None or not template:
        raise ValueError('Template must be a valid format string')
    return template, outtype, annotation_classes

def infotodict(seqinfo):
    """Heuristic evaluator for determining which runs belong where

    allowed template fields - follow python string module:

    item: index within category
    subject: participant id
    seqitem: run number during scanning
    subindex: sub index within group
    """
    # ANATOMY
    t1w = create_key('sub-{subject}/anat/sub-{subject}_run-00{item:01d}_T1w')
    t2w = create_key('sub-{subject}/anat/sub-{subject}_run-00{item:01d}_T2w')
    t2wspc = create_key('sub-{subject}/anat/sub-{subject}_acq-spc_run-00{item:01d}_T2w')
    
    # DWI
    dwi_ap = create_key('sub-{subject}/dwi/sub-{subject}_dir-AP_run-00{item:01d}_dwi')
    
    # fMRI
    
    # FMAPs
    fmap_dwi_pa = create_key('sub-{subject}/fmap/sub-{subject}_acq-dwi_dir-PA_run-00{item:01d}_epi')

    # SBRefs
    
    info = {t1w: [], t2w: [], t2wspc: [], dwi_ap: [], fmap_dwi_pa: []}
    last_run = len(seqinfo)

    for idx, s in enumerate(seqinfo):
        """
        The namedtuple `s` contains the following fields:

        * total_files_till_now
        * example_dcm_file
        * series_id
        * dcm_dir_name
        * unspecified2
        * unspecified3
        * dim1
        * dim2
        * dim3
        * dim4
        * TR
        * TE
        * protocol_name
        * is_motion_corrected
        * is_derived
        * patient_id
        * study_description
        * referring_physician_name
        * series_description
        * image_type
        """
        # ANATOMY
        # 3D T1w
        if ('t1_mprage_sag' in s.series_description) and ('NORM' in s.image_type): # takes normalized images:
            info[t1w].append(s.series_id) # append if multiple series meet criteria
        # T2w
        if ('t2_tse_tra_1mm' in s.series_description) and ('NORM' in s.image_type): # takes normalized images:
            info[t2w].append(s.series_id) # append if multiple series meet criteria
        # 3D T2w space
        if ('t2_spc_sag_iso' in s.series_description) and ('NORM' in s.image_type): # takes normalized images:
            info[t2wspc].append(s.series_id) # append if multiple series meet criteria
        # FLAIR
        
        # DIFFUSION
        # dir AP
        if ((s.dim4 == 67) or (s.dim3 == 2948)) and ('DTI_b800_AP' in s.series_description) and ('ORIGINAL' in s.image_type):
            info[dwi_ap].append(s.series_id) # append if multiple series meet criteria
          
        # rs-fMRI

        # FMAPs
        # DWI dir-PA - NOTE that we have to place these here as they cannot easily by put in the BIDS /dwi folder
        if ('DTI_b000_PA' in s.series_description) and ('ORIGINAL' in s.image_type):
            info[fmap_dwi_pa].append(s.series_id) # append if multiple series meet criteria

        # SBRefs

        
    return info
