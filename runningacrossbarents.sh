#!/usr/bin/env bash
#source /home/dj_gr/miniconda3/etc/profile.d/conda.sh
#module load anaconda
#conda activate icepack
DATA_DIR="$(cd ../input/forcing/barents_combined && pwd)"
cd configuration/scripts/options
#Run everything from Icepack root

for i in $(seq 1 5); do
  n=$(printf '%04d' "$i")
  cat > set_nml.barentsforcing${n} <<EOF
input_lat       = 1.309
input_lon       = 0.698132
data_dir = '${DATA_DIR}'
atm_data_file   = 'ATM_FORCING_${n}.txt'
ocn_data_file   = 'OCN_FORCING_${n}.txt'
EOF
done

cd ../../..
rm -rf curc_icepack_test*
for i in $(seq 1 5); do
  n=$(printf '%04d' "$i")
  ./icepack.setup --case curc_icepack_test${n} --mach conda --env linux -s restcdf,histcdf,ionetcdf,barentsforcing${n}
  cd curc_icepack_test${n}
  ./icepack.build
  ./icepack.submit
  cd ..
done