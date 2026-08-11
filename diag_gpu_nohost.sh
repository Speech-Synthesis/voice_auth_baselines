#!/bin/bash
#PBS -N diag_gpu
#PBS -l select=1:ncpus=1:ngpus=1:mem=1gb
#PBS -l walltime=00:05:00
#PBS -q workq
#PBS -o /home/n_harini/voice_auth_baselines/logs/diag_gpu.out
#PBS -e /home/n_harini/voice_auth_baselines/logs/diag_gpu.err

# =============================================================================
# DIAGNOSTIC: Minimal GPU job (no host constraint)
# Purpose: Verify GPU resource assignment works
# =============================================================================

echo "============================================================"
echo "DIAGNOSTIC: GPU minimal job (no host constraint)"
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
echo "SUCCESS: GPU job executed correctly"
echo "============================================================"
