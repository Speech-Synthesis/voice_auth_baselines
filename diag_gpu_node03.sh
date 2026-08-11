#!/bin/bash
#PBS -N diag_gpu_n03
#PBS -l select=1:ncpus=1:ngpus=1:mem=1gb:host=node03
#PBS -l walltime=00:05:00
#PBS -q workq
#PBS -o /home/n_harini/voice_auth_baselines/logs/diag_gpu_node03.out
#PBS -e /home/n_harini/voice_auth_baselines/logs/diag_gpu_node03.err

# =============================================================================
# DIAGNOSTIC: Minimal GPU job on node03 specifically
# Purpose: Test if host=node03 constraint is valid
# =============================================================================

echo "============================================================"
echo "DIAGNOSTIC: GPU minimal job on node03"
echo "============================================================"
echo "Job ID: $PBS_JOBID"
echo "Hostname: $(hostname)"
echo "PBS_O_WORKDIR: $PBS_O_WORKDIR"
echo "Date: $(date)"
echo "============================================================"

echo "Checking CUDA_VISIBLE_DEVICES:"
echo "CUDA_VISIBLE_DEVICES=$CUDA_VISIBLE_DEVICES"

echo ""
echo "Checking nvidia-smi:"
nvidia-smi

echo "============================================================"
echo "SUCCESS: GPU job on node03 executed correctly"
echo "============================================================"
