#!/usr/bin/env bash
#source /home/dj_gr/miniconda3/etc/profile.d/conda.sh
#module load anaconda
#conda activate icepack
DATA_DIR="$(cd ../input/forcing/barents_combined && pwd)"


#This requires the case directory to exist already
for i in $(seq 1 5); do
  n=$(printf '%04d' "$i")
  (
    cd curc_icepack_test${n}

    cat > namelist.mods <<EOF
data_dir        = '${DATA_DIR}'
atm_data_file   = 'ATM_FORCING_${n}.txt'
ocn_data_file   = 'OCN_FORCING_${n}.txt'
npt             = 105120
EOF

    ./casescripts/parse_namelist.sh icepack_in namelist.mods
    ./icepack.submit
  )
done
