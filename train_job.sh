#!/bin/bash
#PBS -N voice_auth_train
#PBS -l select=1:ncpus=4:mem=32gb
#PBS -l walltime=48:00:00
#PBS -q workq
#PBS -o /home/n_harini/voice_auth_baselines/logs/train.out
#PBS -e /home/n_harini/voice_auth_baselines/logs/train.err

# =============================================================================
# Voice Authentication Spoofing Detection Training - Amrita HPC
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

# Fix libstdc++ compatibility (use micromamba's newer version)
export LD_LIBRARY_PATH=$CONDA_PREFIX/lib:$LD_LIBRARY_PATH

# Environment Information
echo ""
echo "Environment Information"
echo "-----------------------"

python --version

python -c "import torch; print('PyTorch:', torch.__version__)"
python -c "import torch; print('CUDA Available:', torch.cuda.is_available())"
python -c "import torch; print('CUDA Version:', torch.version.cuda)"

python - <<'EOF'
import torch
if torch.cuda.is_available():
    print("GPU:", torch.cuda.get_device_name(0))
else:
    print("GPU: Not Available")
EOF

echo ""

# GPU Status
echo "GPU Status"
echo "----------"
nvidia-smi
echo ""

# Start Training
echo "============================================================"
echo "Starting Voice Auth Spoofing Detection Training..."
echo "============================================================"

cd legacy_model

python model_main.py \
    --num_epochs=100 \
    --track=logical \
    --features=spect \
    --lr=0.00005

STATUS=$?

echo ""
echo "============================================================"
echo "Job Finished: $(date)"
echo "Exit Status: $STATUS"
echo "============================================================"

exit $STATUS
