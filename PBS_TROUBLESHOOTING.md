# PBS Job Troubleshooting Guide

## Problem Summary

Jobs submitted with `host=node03` constraint immediately fail with:
- `Exit_status = -18` (PBS internal resource setup failure)
- `run_count = 21` (maximum retries before auto-hold)
- No `exec_host` assigned
- No output files generated
- System hold applied

## Root Cause Analysis

**Exit status -18** in PBS typically indicates:
1. Resource assignment failure (cgroups/GPU device binding)
2. Prologue script failure
3. Invalid resource request syntax
4. Node-level hook failure

**Evidence pointing to `host=node03` or GPU resource issue:**
- `pbs_cgroups` hook error visible on node02
- Jobs fail before any user script executes
- Interactive GPU access works fine (not a driver issue)

## Diagnostic Steps

### Step 1: Create logs directory
```bash
mkdir -p /home/n_harini/voice_auth_baselines/logs
```

### Step 2: Release held jobs (clean slate)
```bash
# Check held jobs
qstat -u $USER

# Delete held jobs
qdel 91243.amritahpc
qdel 91244.amritahpc

# Or delete all your jobs
qdel $(qstat -u $USER | awk 'NR>2 {print $1}')
```

### Step 3: Run PBS diagnostics
```bash
cd /home/n_harini/voice_auth_baselines
bash pbs_diagnostics.sh > pbs_diag_output.txt 2>&1
cat pbs_diag_output.txt
```

### Step 4: Test jobs in order

**Test A: CPU-only (baseline)**
```bash
qsub diag_cpu_only.sh
# Wait for completion, check:
cat logs/diag_cpu.out
cat logs/diag_cpu.err
```

**Test B: GPU without host constraint**
```bash
qsub diag_gpu_nohost.sh
# Wait for completion, check:
cat logs/diag_gpu.out
cat logs/diag_gpu.err
```

**Test C: GPU with host=node03 (if Test B works)**
```bash
qsub diag_gpu_node03.sh
# If this fails but Test B worked, host= syntax is the problem
```

**Test D: GPU with vnode=node03 (alternative syntax)**
```bash
qsub diag_gpu_vnode.sh
# If this works, use vnode= instead of host=
```

### Step 5: Monitor jobs
```bash
# Watch job status
watch -n 5 'qstat -u $USER'

# Check job details
qstat -f <job_id>

# Check if job got assigned a node
qstat -f <job_id> | grep -E "(exec_host|exec_vnode|job_state|Exit_status|comment)"
```

## Expected Outcomes

| Test | Result | Diagnosis |
|------|--------|-----------|
| A fails | - | PBS fundamentally broken, contact admin |
| A works, B fails | - | GPU resource (ngpus) misconfigured, contact admin |
| A+B work, C fails | - | `host=` syntax invalid, remove it or use `vnode=` |
| A+B+C work | - | Original job has different issue (check walltime, mem) |
| A+B fail, D works | - | Use `vnode=` syntax instead of `host=` |

## Solution Based on Test Results

### If GPU jobs work WITHOUT host constraint:

Use `train_job_fixed.sh` which removes the `host=node03` constraint:
```bash
cp train_job_fixed.sh train_job.sh
qsub train_job.sh
```

### If you need a specific node, use vnode syntax:

Edit train_job.sh to use:
```bash
#PBS -l select=1:ncpus=4:ngpus=1:mem=32gb:vnode=node03
```

### If all GPU jobs fail:

This requires administrator intervention. Send this to your HPC admin:

---

**To: HPC Administrator**
**Subject: GPU jobs failing with Exit_status=-18 before execution**

PBS GPU jobs are failing immediately with:
- Exit_status = -18
- run_count reaches 21 before auto-hold
- No exec_host assigned
- No output files generated

Observed:
- node02 shows: "offlined by hook 'pbs_cgroups' due to hook error"
- Interactive GPU access (nvidia-smi, PyTorch CUDA) works correctly
- CPU-only PBS jobs [work/fail - fill in after testing]

Resource request:
```
#PBS -l select=1:ncpus=4:ngpus=1:mem=32gb
```

Please check:
1. pbs_cgroups hook configuration for GPU devices
2. ngpus resource mapping to physical GPU devices
3. Node prologue/epilogue scripts
4. /var/spool/pbs/mom_logs on GPU nodes
5. GPU device cgroup permissions

---

## Files Created

| File | Purpose |
|------|---------|
| `diag_cpu_only.sh` | Test basic PBS execution |
| `diag_gpu_nohost.sh` | Test GPU without node constraint |
| `diag_gpu_node03.sh` | Test GPU with host=node03 |
| `diag_gpu_vnode.sh` | Test GPU with vnode=node03 |
| `pbs_diagnostics.sh` | Gather PBS configuration info |
| `train_job_fixed.sh` | Training script without host constraint |

## Quick Commands Reference

```bash
# Submit job
qsub <script.sh>

# Check job status
qstat -u $USER

# Detailed job info
qstat -f <job_id>

# Delete job
qdel <job_id>

# Release held job (if you want to retry)
qrls <job_id>

# Check nodes
pbsnodes -a

# Check queue
qstat -Qf workq
```
