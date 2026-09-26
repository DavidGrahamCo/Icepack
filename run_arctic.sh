#!/usr/bin/env bash
#module load anaconda
which conda
#conda activate icepack

#This requires the case directories to exist already, use setupensemble.sh


MODS="${1:?usage: $0 <mods-file>}"
MODS=$(readlink -f "$MODS")


for i in $(seq 1 2); do
  n=$(printf '%04d' "$i")
  (
    cd centralarctic_forced_${n} || exit 1

    ./casescripts/parse_namelist.sh icepack_in "$MODS"
    ./icepack.submit  )
done
