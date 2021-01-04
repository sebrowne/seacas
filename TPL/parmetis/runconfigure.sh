#! /usr/bin/env bash

### The following assumes you are building in a subdirectory of ACCESS Root
if [ "X$ACCESS" == "X" ] ; then
  ACCESS=$(cd ../../..; pwd)
  echo "ACCESS set to ${ACCESS}"
fi
INSTALL_PATH=${INSTALL_PATH:-${ACCESS}}

SHARED="${SHARED:-YES}"
if [[ "$SHARED" == "ON" || "$SHARED" == "YES" ]]
then
  USE_SHARED="1"
else
  USE_SHARED="0"
fi

MPI="${MPI:-YES}"
if [ "$MPI" == "YES" ]
then
  if [ "$CRAY" == "YES" ]
  then
    export CC=cc
  else
    export CC=mpicc
  fi
else
   echo "MPI Must be YES"
   exit 1
fi

METIS_PATH=${ACCESS}/TPL/metis/metis-5.1.0
make config cc=${CC} prefix=${INSTALL_PATH} shared=${USE_SHARED} metis_path=${METIS_PATH} gklib_path=${METIS_PATH}/GKlib

echo ""
echo "         MPI: ${MPI}"
echo "    COMPILER: ${CC}"
echo "      ACCESS: ${ACCESS}"
echo "INSTALL_PATH: ${INSTALL_PATH}"
echo ""
