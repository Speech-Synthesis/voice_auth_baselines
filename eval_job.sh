#!/bin/bash
#PBS -N voice_auth_eval
#PBS -l select=1:ncpus=4:mem=32gb
#PBS -l walltime=02:00:00
#PBS -q workq
#PBS -o /home/n_harini/voice_auth_baselines/logs/eval.out
#PBS -e /home/n_harini/voice_auth_baselines/logs/eval.err

# =============================================================================
# Voice Authentication Spoofing Detection Evaluation - Amrita HPC
# =============================================================================

cd $PBS_O_WORKDIR

# Create log directory
mkdir -p logs

echo "============================================================"
echo "Job Started: $(date)"
echo "Job ID: $PBS_JOBID"
echo "Node: $(hostname)"
echo "============================================================"

# Load CUDA
echo "Loading CUDA module..."
module load cuda11.6/toolkit/11.6.2

# Activate micromamba environment
echo "Activating voice_env environment..."
eval "$(micromamba shell hook --shell bash)"
micromamba activate voice_env

# Environment Information
echo ""
echo "Environment Information"
echo "-----------------------"
python --version
python -c "import torch; print('PyTorch:', torch.__version__)"
python -c "import torch; print('CUDA Available:', torch.cuda.is_available())"

echo ""

# Start Evaluation
echo "============================================================"
echo "Starting Voice Auth Spoofing Detection Evaluation..."
echo "============================================================"

cd legacy_model

# Evaluate with the trained model
# Usage: python model_main.py --eval --model_path=<checkpoint> --eval_output=<output_file>
python model_main.py \
    --eval \
    --model_path=models/model_logical_spect_100_32_5e-05/epoch_99.pth \
    --eval_output=results.txt \
    --track=logical \
    --features=spect

STATUS=$?

echo ""
echo "============================================================"
echo "Job Finished: $(date)"
echo "Exit Status: $STATUS"
echo "============================================================"

exit $STATUS
