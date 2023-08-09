#!/bin/bash

#========== Configuration ==================

# Location for temp clones
temp_dir=${SCRATCH}/temp_soconda

# Location for installs
install_dir=/global/common/software/sobs/perlmutter/conda_envs

# Module file directory
module_dir=/global/common/software/sobs/perlmutter/soconda/modulefiles

#===========================================

version=$1
if [ "x${version}" = "x" ]; then
    echo "usage:  $0 <soconda branch/tag/hash>"
    exit 1
fi

# Location for clone repo
mkdir -p "${temp_dir}"
today=$(date +%Y%m%d)
clone_dir="${temp_dir}/${today}"

# The name of env
env_name="${install_dir}/soconda"

# The full version
env_version="${today}_${version}"

# Make sure the module dir exists
mkdir -p "${module_dir}"

# Get specified commit
echo "Making shallow clone of ${version} in ${clone_dir}"

if [ -d "${clone_dir}" ]; then
    rm -rf "${clone_dir}"
fi

git clone --depth=1 --single-branch --branch=${version} https://github.com/tskisner/soconda.git "${clone_dir}"

# Load the NERSC anaconda base

# Build things from the temp directory

pushd "${clone_dir}" 2>&1 >/dev/null
mkdir -p "build"
pushd "build" 2>&1 >/dev/null

export MPICC="cc"

eval "${clone_dir}/soconda.sh" \
    -e "${env_name}" \
    -v "${env_version}" \
    -m "${module_dir}" \
    -i "${clone_dir}/deploy/init_nersc_lmod" 2>&1 >log

popd 2>&1 >/dev/null
popd 2>&1 >/dev/null

