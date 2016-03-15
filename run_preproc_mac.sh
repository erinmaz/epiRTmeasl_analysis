#!/bin/tcsh
#call from a directory of dicoms for 1 epiRTmeasl run
#requires dicom_hinfo (from AFNI) and bet (from FSL) on your path
#EDIT THE scriptdir variable to point to your copy of epiRTmeasl_analysis
#$1 = output prefix for niftis created by niidicom2
#$2 = minTR in milliseconds
#example: run_preproc output_name 4197


set scriptdir = /home/emazerolle/Dropbox/matlab/epiRTmeasl_analysis

set alldirs = ${scriptdir}:${scriptdir}/spm8:${scriptdir}/spm8/EEGtemplates:${scriptdir}/spm8/apriori:${scriptdir}/spm8/canonical:${scriptdir}/spm8/config:${scriptdir}/spm8/external:${scriptdir}/spm8/external/bemcp:${scriptdir}/spm8/external/ctf:${scriptdir}/spm8/external/eeprobe:${scriptdir}/spm8/external/fieldtrip:${scriptdir}/spm8/external/fieldtrip/connectivity:${scriptdir}/spm8/external/fieldtrip/fileio:${scriptdir}/spm8/external/fieldtrip/forward:${scriptdir}/spm8/external/fieldtrip/inverse:${scriptdir}/spm8/external/fieldtrip/plotting:${scriptdir}/spm8/external/fieldtrip/preproc:${scriptdir}/spm8/external/fieldtrip/specest:${scriptdir}/spm8/external/fieldtrip/src:${scriptdir}/spm8/external/fieldtrip/statfun:${scriptdir}/spm8/external/fieldtrip/trialfun:${scriptdir}/spm8/external/fieldtrip/utilities:${scriptdir}/spm8/external/mne:${scriptdir}/spm8/external/yokogawa:${scriptdir}/spm8/man:${scriptdir}/spm8/man/FieldMap:${scriptdir}/spm8/man/auditory:${scriptdir}/spm8/man/batch:${scriptdir}/spm8/man/biblio:${scriptdir}/spm8/man/bms:${scriptdir}/spm8/man/dartelguide:${scriptdir}/spm8/man/dcm:${scriptdir}/spm8/man/dcm_ir:${scriptdir}/spm8/man/dcm_ir/figures:${scriptdir}/spm8/man/dcm_phase:${scriptdir}/spm8/man/dcm_phase/figures:${scriptdir}/spm8/man/dcm_ssr:${scriptdir}/spm8/man/example_scripts:${scriptdir}/spm8/man/faces:${scriptdir}/spm8/man/faces_group:${scriptdir}/spm8/man/fmri_est:${scriptdir}/spm8/man/fmri_spec:${scriptdir}/spm8/man/images:${scriptdir}/spm8/man/meeg:${scriptdir}/spm8/man/meg_sloc:${scriptdir}/spm8/man/mmn:${scriptdir}/spm8/man/multimodal:${scriptdir}/spm8/man/multimodal/figures:${scriptdir}/spm8/man/pet:${scriptdir}/spm8/man/ppi:${scriptdir}/spm8/man/ppi/figures:${scriptdir}/spm8/matlabbatch:${scriptdir}/spm8/matlabbatch/cfg_basicio:${scriptdir}/spm8/matlabbatch/cfg_basicio/src:${scriptdir}/spm8/matlabbatch/cfg_confgui:${scriptdir}/spm8/matlabbatch/examples:${scriptdir}/spm8/rend:${scriptdir}/spm8/spm_orthviews:${scriptdir}/spm8/src:${scriptdir}/spm8/templates:${scriptdir}/spm8/toolbox:${scriptdir}/spm8/toolbox/ASLtbx:${scriptdir}/spm8/toolbox/Beamforming:${scriptdir}/spm8/toolbox/DARTEL:${scriptdir}/spm8/toolbox/DEM:${scriptdir}/spm8/toolbox/FieldMap:${scriptdir}/spm8/toolbox/HDW:${scriptdir}/spm8/toolbox/LST:${scriptdir}/spm8/toolbox/LST/doc:${scriptdir}/spm8/toolbox/MEEGtools:${scriptdir}/spm8/toolbox/Neural_Models:${scriptdir}/spm8/toolbox/SRender:${scriptdir}/spm8/toolbox/Seg:${scriptdir}/spm8/toolbox/Shoot:${scriptdir}/spm8/toolbox/clinicaltoolbox:${scriptdir}/spm8/toolbox/clinicaltoolbox/Clinical:${scriptdir}/spm8/toolbox/clinicaltoolbox/high_res:${scriptdir}/spm8/toolbox/clinicaltoolbox/tutorial:${scriptdir}/spm8/toolbox/dcm_meeg:${scriptdir}/spm8/toolbox/icc_toolbox:${scriptdir}/spm8/toolbox/icc_toolbox/sample:${scriptdir}/spm8/toolbox/mixture:${scriptdir}/spm8/toolbox/spectral:${scriptdir}/spm8/toolbox/vbm8:${scriptdir}/spm8/tpm

setenv MATLABPATH ${alldirs}
set dicomdir = `pwd`
set file1 = `find $dicomdir/ -type f | xargs head -1;` 
set ldtmp = `dicom_hinfo -tag 0019,10b0 $file1`
set ld = $ldtmp[2]
set titmp = `dicom_hinfo -tag 0019,10ad $file1`
set ti = $titmp[2]
set pld = `echo $ti $ld | awk '{print $1 - $2}'`
set te1tmp = `dicom_hinfo -tag 0018,0081 $file1`
set te1 = $te1tmp[2]
set minTR = $2
set nii_out = $1

mkdir $dicomdir/dicom
mv `find $dicomdir/* -type f` $dicomdir/dicom/.
mkdir $dicomdir/medata
cd $dicomdir/dicom
niidicom2 ${nii_out}
cd ${dicomdir}/medata

set mydir = `pwd`
set mydir2 = `echo \'$mydir\'`
#smoothing hard coded to 5mm
matlab -nosplash -nodesktop -r "asltbx_inputparams(${mydir2},'*.nii','e01',${ld},${pld},${te1},${minTR},5) ; quit"

