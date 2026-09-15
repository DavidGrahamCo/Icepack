#!/usr/bin/env bash
#module load anaconda
which conda
#conda activate icepack

#This requires the case directories to exist already, use setupensemble.sh

#Change the parameters in here (eventually build out file to automatically create and apply namelist.changes)
for i in $(seq 1 30); do
  n=$(printf '%04d' "$i")
  (
    cd centralarctic_forced_${n} || exit 1

    cat > namelist.changes <<EOF
    ksno              = 0.3d0
EOF

    ./casescripts/parse_namelist.sh icepack_in namelist.changes
    ./icepack.submit
  )
done
