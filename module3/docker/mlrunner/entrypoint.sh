#!/bin/bash

set -euo pipefail

mummi_mlserver_nnodes=1
MUMMI_APP=/opt/clones/mummi-ras

export MUMMI_ROOT=$MUMMI_APP
export MUMMI_RESOURCES=/opt/clones/mummi_resources
export MUMMI_APP
model="/opt/clones/mummi_resources/ml/chonky-model/CG_pos_data_summary_pos_dis_C1_v1.npz"
ws=/opt/clones/mummi-ras/mlserver

# Shared output for validator, sampler, and generator
mldir=/opt/clones/mummi-ras/mlserver
resources="martini3-validator"
complex="ras-rbdcrd-ref-CG.gro"
cmd="mummi-ml start --jobid {{jobid}} --workspace=${ws} --outdir=${outpath} --tag mlrunner --device gpu --plain-http --registry=${registry} --encoder-model ${model} --ml-outdir=${mldir} --feedback --resources ${resources} --complex=${complex}"

mkdir -p /opt/clones/extract
cd /opt/clones/extract
tar -xzvf /opt/clones/model.tar.gz
extracted=$(ls /opt/clones/extract)
cd -
mv /opt/clones/extract/${extracted} /opt/clones/mummi_resources/ml/chonky-model

# nproc is OK to run on an arm instance - will return physical cores
NUM_THREADS=$(nproc)
export OMP_NUM_THREADS=$NUM_THREADS
export KERAS_BACKEND='theano'
umask 007
python $MUMMI_APP/mummi_ras/scripts/create_organization.py

# Trajectory feedback files
here=$(pwd)
feedback=/opt/clones/mummi-ras/feedback-cg2ml
mkdir -p ${feedback}

# We won't have feedback for a single run
# These are named by date, but we are just getting all of them.
# for tag in $(oras repo tags --plain-http $registry/cganalysis)
#  do
#    mkdir -p ${feedback}/${tag}
#    cd ${feedback}/${tag}
#    oras pull --plain-http $registry/cganalysis:$tag
# done
cd $here
echo "$cmd"
$cmd
