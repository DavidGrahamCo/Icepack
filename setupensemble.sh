#!/usr/bin/env bash
#module load anaconda
#conda activate icepack
BARENTS_DATA_DIR="$(cd ../input/forcing/barents_combined && pwd)" || { echo "no barents data"; exit 1; }
SIBCHUK_DATA_DIR="$(cd ../input/forcing/sibchuk_combined && pwd)" || { echo "no sibchuk data"; exit 1; }
CENTRALARCTIC_DATA_DIR="$(cd ../input/forcing/centralarctic_combined && pwd)" || { echo "no central arctic data"; exit 1; }

#Run everything from Icepack root
cd configuration/scripts/options
#Sets up barents cases
for i in $(seq 1 30); do
  n=$(printf '%04d' "$i")
  cat > set_nml.barentsforcing${n} <<EOF
input_lat       = 1.309
input_lon       = 0.698132
data_dir = '${BARENTS_DATA_DIR}'
atm_data_file   = 'ATM_FORCING_${n}.txt'
ocn_data_file   = 'OCN_FORCING_${n}.txt'
EOF
done

cd ../../..
rm -rf barents_forced_*
for i in $(seq 1 30); do
  n=$(printf '%04d' "$i")
  ./icepack.setup --case barents_forced_${n} --mach conda --env linux -s ionetcdf,djdefaultsettings,barentsforcing${n}
  cd barents_forced_${n}
  ./icepack.build
  cd ..
done

echo "Done with barents setup"

cd configuration/scripts/options
#Sets up sibchuk cases
for i in $(seq 1 30); do
  n=$(printf '%04d' "$i")
  cat > set_nml.sibchukforcing${n} <<EOF
input_lat       = 1.3183906501
input_lon       = 3.0446500856
data_dir = '${SIBCHUK_DATA_DIR}'
atm_data_file   = 'ATM_FORCING_${n}.txt'
ocn_data_file   = 'OCN_FORCING_${n}.txt'
EOF
done

cd ../../..
rm -rf sibchuk_forced_*
for i in $(seq 1 30); do
  n=$(printf '%04d' "$i")
  ./icepack.setup --case sibchuk_forced_${n} --mach conda --env linux -s ionetcdf,djdefaultsettings,sibchukforcing${n}
  cd sibchuk_forced_${n}
  ./icepack.build
  cd ..
done

echo "Done with sibchuk setup"

cd configuration/scripts/options
#Sets up arctic cases
for i in $(seq 1 30); do
  n=$(printf '%04d' "$i")
  cat > set_nml.centralarcticforcing${n} <<EOF
input_lat       = 1.53589
input_lon       = 0
data_dir = '${CENTRALARCTIC_DATA_DIR}'
atm_data_file   = 'ATM_FORCING_${n}.txt'
ocn_data_file   = 'OCN_FORCING_${n}.txt'
EOF
done

cd ../../..
rm -rf centralarctic_forced_*
for i in $(seq 1 30); do
  n=$(printf '%04d' "$i")
  ./icepack.setup --case centralarctic_forced_${n} --mach conda --env linux -s ionetcdf,djdefaultsettings,centralarcticforcing${n}
  cd centralarctic_forced_${n}
  ./icepack.build
  cd ..
done

echo "Done with setup"