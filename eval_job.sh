#!/bin/bash
#PBS -N voice_auth_baselines_job
#PBS -q gpu
#PBS -l select=1:ncpus=8:ngpus=1:mem=32gb
#PBS -l walltime=02:00:00
#PBS -o logs/eval.out
#PBS -e logs/eval.err
cd $PBS_O_WORKDIR
module load cuda/11.6
eval "$(micromamba shell hook --shell bash)"
micromamba activate myproject
python run_evaluation.py
