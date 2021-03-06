#!/bin/bash

################################################################
## * This script builds available configurations of QMCPACK   ##
##   on Titan, Oak Ridge National Lab.                        ##
##                                                            ##
## * Execute this script in trunk/                            ##
##   ./config/build_titan.sh                                  ##
##                                                            ##
## (c) Scientific Computing Group, NCCS, ORNL.                ##
## Last modified: Mar 21, 2016                                ##
################################################################


# Load required modules (assuming default settings have not been modified)
source $MODULESHOME/init/bash
if (echo $LOADEDMODULES | grep -q pgi)
then
module unload PrgEnv-pgi
fi
if (echo $LOADEDMODULES | grep -q cuda)
then
module unload cudatoolkit
fi
module load PrgEnv-gnu
module load cray-hdf5
module load fftw
module load boost
module load subversion
module load cmake/2.8.11.2


# Set environment variables
export FFTW_HOME=$FFTW_DIR/..


# Set cmake variables, shared for cpu builds
CMAKE_FLAGS="-DCMAKE_C_COMPILER=cc \ 
             -DCMAKE_CXX_COMPILER=CC \
             -D QMC_INCLUDE=/sw/xk7/amdlibm/include \
             -D QMC_EXTRA_LIBS=/sw/xk7/amdlibm/lib/static/libamdlibm.a"


# Configure and build cpu real
echo ""
echo ""
echo "building qmcpack for cpu real"
mkdir build_cpu_real
cd build_cpu_real
cmake $CMAKE_FLAGS .. 
make -j 32
cd ..
ln -s ./build_cpu_real/bin/qmcpack ./qmcpack_cpu_real


# Configure and build cpu complex
echo ""
echo ""
echo "building qmcpack for cpu complex"
mkdir build_cpu_comp
cd build_cpu_comp
cmake -DQMC_COMPLEX=1 $CMAKE_FLAGS .. 
make -j 32
cd ..
ln -s ./build_cpu_comp/bin/qmcpack ./qmcpack_cpu_comp


# load cuda toolkit for gpu build
module load cudatoolkit


# Set cmake variables, shared for gpu builds
CMAKE_FLAGS="-DCMAKE_C_COMPILER=cc \ 
             -DCMAKE_CXX_COMPILER=CC"

# Configure and build gpu real
echo ""
echo ""
echo "building qmcpack for gpu real"
mkdir build_gpu_real
cd build_gpu_real
cmake -DQMC_CUDA=1 $CMAKE_FLAGS .. 
make -j 32
cd ..
ln -s ./build_gpu_real/bin/qmcpack ./qmcpack_gpu_real


