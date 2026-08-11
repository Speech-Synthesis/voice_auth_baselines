#!/bin/bash
#PBS -N diag_cpu
#PBS -l select=1:ncpus=1:mem=1gb
#PBS -l walltime=00:05:00
#PBS -q workq
#PBS -o /home/n_harini/voice_auth_baselines/logs/diag_cpu.out
#PBS -e /home/n_harini/voice_auth_baselines/logs/diag_cpu.err

# =============================================================================
# DIAGNOSTIC: Minimal CPU-only job
# Purpose: Verify basic PBS job execution works
# =============================================================================

echo "============================================================"
echo "DIAGNOSTIC: CPU-only minimal job"
echo "============================================================"
echo "Job ID: $PBS_JOBID"
echo "Hostname: $(hostname)"
echo "PBS_O_WORKDIR: $PBS_O_WORKDIR"
echo "PBS_NODEFILE: $PBS_NODEFILE"
echo "Date: $(date)"
echo "User: $(whoami)"
echo "PWD: $(pwd)"
echo "============================================================"
echo "SUCCESS: CPU job executed correctly"
echo "============================================================"
