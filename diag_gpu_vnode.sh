#!/bin/bash
#PBS -N diag_gpu_vn
#PBS -l select=1:ncpus=1:ngpus=1:mem=1gb:vnode=node03
#PBS -l walltime=00:05:00
#PBS -q workq
#PBS -o /home/n_harini/voice_auth_baselines/logs/diag_gpu_vnode.out
#PBS -e /home/n_harini/voice_auth_baselines/logs/diag_gpu_vnode.err

# =============================================================================
# DIAGNOSTIC: Minimal GPU job using vnode= syntax
# Purpose: Test if vnode=node03 is correct syntax instead of host=node03
# =============================================================================

echo "============================================================"
echo "DIAGNOSTIC: GPU minimal job with vnode=node03"
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
echo "SUCCESS: GPU job with vnode syntax executed correctly"
echo "============================================================"
