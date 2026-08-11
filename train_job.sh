#!/bin/bash
#PBS -N deepfake_train
#PBS -q workq
#PBS -l select=1:ncpus=4:ngpus=1:mem=32gb
#PBS -l walltime=48:00:00
#PBS -o /home/n_harini/voice_auth_baselines/train.out
#PBS -e /home/n_harini/voice_auth_baselines/train.err

echo "============================================================"
echo "Deepfake / Voice Authentication Training"
echo "============================================================"
echo "Job ID: $PBS_JOBID"
echo "Node: $(hostname)"
echo "Started: $(date)"
echo "============================================================"

cd /home/n_harini/voice_auth_baselines/legacy_model

module load cuda11.6/toolkit/11.6.2

eval "$(micromamba shell hook --shell bash)"
micromamba activate voice_env

echo "Python:"
python --version

echo "PyTorch/CUDA:"
python -c "import torch; print('PyTorch:', torch.__version__); print('Built CUDA:', torch.version.cuda); print('CUDA available:', torch.cuda.is_available()); print('GPU:', torch.cuda.get_device_name(0) if torch.cuda.is_available() else 'None')"

echo "GPU:"
nvidia-smi

echo "============================================================"
echo "Starting training..."
echo "============================================================"

python model_main.py \
    --num_epochs=100 \
    --track=logical \
    --features=spect \
    --lr=0.00005

STATUS=$?

echo "============================================================"
echo "Training finished: $(date)"
echo "Exit status: $STATUS"
echo "============================================================"

exit $STATUS
