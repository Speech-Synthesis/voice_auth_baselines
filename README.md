# Voice Authentication Spoofing Detection

Deep learning system for detecting spoofed/synthetic speech using ResNet-based CNNs. Based on the ASVspoof 2019 challenge (team UCLANESL).

## Dataset

**ASVspoof 2019 LA** (Logical Access)
- Download: [ASVspoof2019 dataset](https://datashare.is.ed.ac.uk/handle/10283/3336)
- Train: 25,380 samples | Dev: 24,844 samples
- Format: FLAC, 16kHz

Setup symlink:
```bash
cd legacy_model
ln -s /path/to/ASVspoof2019/LA data_logical
```

## Models

| Model | Features | Description |
|-------|----------|-------------|
| SpectrogramModel | Log power spectrogram | Default, best for LA track |
| MFCCModel | MFCC + delta + delta² | Compact features |
| CQCCModel | CQCC | Requires MATLAB preprocessing |

Architecture: 11 ResNet blocks → FC(128) → FC(2) → LogSoftmax

## Environment Setup

```bash
micromamba create -n voice_env python=3.10
micromamba activate voice_env
pip install torch==1.13.1+cu116 torchvision --extra-index-url https://download.pytorch.org/whl/cu116
pip install librosa soundfile tensorboardX scikit-learn joblib h5py
```

## Training

### Local
```bash
cd legacy_model
python model_main.py \
    --num_epochs=100 \
    --track=logical \
    --features=spect \
    --lr=0.00005
```

### HPC (PBS)
```bash
mkdir -p logs
qsub train_job.sh
qstat -u $USER          # monitor
tail -f logs/train.out  # view output
```

**Outputs:**
- Checkpoints: `legacy_model/models/model_logical_spect_100_32_5e-05/epoch_*.pth`
- TensorBoard: `legacy_model/logs/`

## Evaluation

### Local
```bash
cd legacy_model
python model_main.py --eval \
    --model_path=models/model_logical_spect_100_32_5e-05/epoch_99.pth \
    --eval_output=results.txt \
    --track=logical \
    --features=spect
```

### HPC (PBS)
```bash
qsub eval_job.sh
```

### Compute Metrics
```bash
python evaluate_tDCF_asvspoof19.py results.txt /path/to/ASVspoof2019.LA.asv.dev.gi.trl.txt
```

## Score Fusion

Combine multiple model results:
```bash
python fuse_result.py --input FILE1 FILE2 FILE3 --output=fused_results.txt
```

## Project Structure

```
voice_auth_baselines/
├── train_job.sh              # PBS training script
├── eval_job.sh               # PBS evaluation script
├── diag_*.sh                 # PBS diagnostic scripts
├── pbs_diagnostics.sh        # Cluster diagnostics
└── legacy_model/
    ├── model_main.py         # Training/eval entry point
    ├── models.py             # Neural network architectures
    ├── data_utils.py         # Dataset loader
    ├── eval_metrics.py       # EER & t-DCF metrics
    ├── evaluate_tDCF_asvspoof19.py
    ├── fuse_result.py        # Score fusion
    ├── cqcc_extraction.m     # MATLAB CQCC extraction
    └── data_logical/         # Symlink to dataset
```

## Metrics

- **EER** (Equal Error Rate): Point where FAR = FRR
- **t-DCF** (Tandem Detection Cost Function): Combined CM + ASV cost

## References

- [ASVspoof 2019 Challenge](https://www.asvspoof.org/)
- Alzantot et al., "Deep Residual Neural Networks for Audio Spoofing Detection"
