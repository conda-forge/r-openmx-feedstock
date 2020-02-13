#!/bin/bash
if [[ $target_platform =~ linux.* ]] || [[ $target_platform == win-32 ]] || [[ $target_platform == win-64 ]] || [[ $target_platform == osx-64 ]]; then
  export DISABLE_AUTOBREW=1
  
  # The OpenMx uses this var to toggle debug behavior within
  # its own build system. Conda sets this var also, causing
  # the OpenMx build to crash. Better unset it here so
  # OpenMx can use its own DEBUG_CXXFLAGS
  unset DEBUG_CXXFLAGS
  
  $R CMD INSTALL --build .
else
  mkdir -p $PREFIX/lib/R/library/OpenMx
  mv * $PREFIX/lib/R/library/OpenMx
fi
