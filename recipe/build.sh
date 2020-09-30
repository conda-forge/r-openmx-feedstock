#!/bin/bash
if [[ $target_platform =~ linux.* ]] || [[ $target_platform == win-32 ]] || [[ $target_platform == win-64 ]] || [[ $target_platform == osx-64 ]]; then
  export DISABLE_AUTOBREW=1
  
  # The OpenMx uses this var to toggle debug behavior within
  # its own build system. Conda sets this var also, causing
  # the OpenMx build to crash. Better unset it here so
  # OpenMx can use its own DEBUG_CXXFLAGS
  unset DEBUG_CXXFLAGS

  # OpenMx should not build fortran code with -fopenmp because
  # of this issue: https://github.com/OpenMx/OpenMx/issues/284
  # So take ALL_FFLAGS and ALL_CFFLAGS from Makeconf, remove
  # -fopenmp and append them to the pkg Makevars as overrides
  cat $PREFIX/lib/R/etc/Makeconf | awk '/^ALL_FFLAGS/ || /^ALL_FCFLAGS/ {m=$1;$1=$2=""; printf "override %s = $(filter-out -fopenmp, %s)\n",m,$0}' >> src/Makevars.in
  
  $R CMD INSTALL --build .
else
  mkdir -p $PREFIX/lib/R/library/OpenMx
  mv * $PREFIX/lib/R/library/OpenMx
fi
