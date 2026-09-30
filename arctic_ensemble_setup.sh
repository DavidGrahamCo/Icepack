#!/usr/bin/env bash
CENTRALARCTIC_DATA_DIR="$(cd ../input/forcing/centralarctic_combined && pwd)" || { echo "no central arctic data"; exit 1; }

MEMBERS=5
YEARS=$(seq 2000 2013)

cd configuration/scripts/options

for i in $(seq 1 $MEMBERS); do
  n=$(printf '%04d' "$i")
  for yr in $YEARS; do
    cat > set_nml.centralarcticforcing${n}_${yr} <<EOF
input_lat       = 1.53589
input_lon       = 0
data_dir = '${CENTRALARCTIC_DATA_DIR}'
atm_data_file   = 'ATM_FORCING_${n}_${yr}-$((yr+2)).txt'
ocn_data_file   = 'OCN_FORCING_${yr}-$((yr+2)).txt'
ocn_data_type = 'ISPOL'
year_init = ${yr}
fyear_init = ${yr}
EOF
  done
done

cd ../../..
rm -rf centralarctic_forced_00*

for i in $(seq 1 $MEMBERS); do
  n=$(printf '%04d' "$i")
  for yr in $YEARS; do
    case="centralarctic_forced_${n}_${yr}-$((yr+2))"
    ./icepack.setup --case ${case} --mach conda --env linux -s ionetcdf,djdefaultsettings,centralarcticforcing${n}_${yr},djbuildsettings
    ( cd ${case} && ./icepack.build && cp icepack_in icepack_in_clean )
  done
done

echo "Done with setup"