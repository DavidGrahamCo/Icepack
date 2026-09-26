#!/usr/bin/env bash
#module load anaconda
#conda activate icepack
CENTRALARCTIC_DATA_DIR="$(cd ../input/forcing/centralarcticspinup && pwd)" || { echo "no central arctic data"; exit 1; }

#Run everything from Icepack root
cd configuration/scripts/options

#Sets up arctic cases

for i in $(seq 1 10); do
  n=$(printf '%04d' "$i")
  cat > set_nml.centralarcticforcing${n} <<EOF
input_lat       = 1.53589
input_lon       = 0
data_dir = '${CENTRALARCTIC_DATA_DIR}'
atm_data_file   = 'ATM_FORCING_${n}.txt'
ocn_data_file   = 'notused'
qdp_fixed = -10
sss_fixed = 34
EOF
done
#Bottom two are a fixed ocean forcing, from david

    
cd ../../..
rm -rf centralarctic_forced_00*
for i in $(seq 1 10); do
  n=$(printf '%04d' "$i")
  ./icepack.setup --case centralarctic_forced_${n} --mach conda --env linux -s ionetcdf,djdefaultsettings,centralarcticforcing${n},djbuildsettings
  cd centralarctic_forced_${n}
  ./icepack.build
  cd ..
done

echo "Done with setup"
