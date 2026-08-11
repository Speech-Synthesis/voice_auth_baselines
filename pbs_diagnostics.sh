#!/bin/bash
# =============================================================================
# PBS Cluster Diagnostic Script
# Run this interactively on the HPC login node (NOT as a PBS job)
# Usage: bash pbs_diagnostics.sh > pbs_diag_output.txt 2>&1
# =============================================================================

echo "============================================================"
echo "PBS CLUSTER DIAGNOSTICS"
echo "Date: $(date)"
echo "User: $(whoami)"
echo "============================================================"

echo ""
echo "============================================================"
echo "1. PBS Server Status"
echo "============================================================"
qstat -B 2>&1 || echo "qstat -B failed"

echo ""
echo "============================================================"
echo "2. Queue Configuration (workq)"
echo "============================================================"
qstat -Qf workq 2>&1 || echo "qstat -Qf workq failed"

echo ""
echo "============================================================"
echo "3. All Nodes Status"
echo "============================================================"
pbsnodes -a 2>&1 || echo "pbsnodes -a failed"

echo ""
echo "============================================================"
echo "4. Node Resources (detailed)"
echo "============================================================"
pbsnodes -av 2>&1 | head -200 || echo "pbsnodes -av failed"

echo ""
echo "============================================================"
echo "5. Current Jobs"
echo "============================================================"
qstat -a 2>&1 || echo "qstat -a failed"

echo ""
echo "============================================================"
echo "6. Your Held Jobs (detailed)"
echo "============================================================"
qstat -u $(whoami) -f 2>&1 | grep -A 50 "Job Id" || echo "No jobs or qstat failed"

echo ""
echo "============================================================"
echo "7. Server Resources (if permitted)"
echo "============================================================"
qmgr -c "print server" 2>&1 | head -100 || echo "qmgr print server failed (may need admin)"

echo ""
echo "============================================================"
echo "8. Queue Resources (if permitted)"
echo "============================================================"
qmgr -c "print queue workq" 2>&1 || echo "qmgr print queue failed (may need admin)"

echo ""
echo "============================================================"
echo "9. Node Resources (if permitted)"
echo "============================================================"
qmgr -c "print node @default" 2>&1 | head -100 || echo "qmgr print node failed (may need admin)"

echo ""
echo "============================================================"
echo "10. Check GPU Resource Definition"
echo "============================================================"
pbsnodes -a 2>&1 | grep -E "(^[a-z]|ngpus|state|comment)" || echo "grep failed"

echo ""
echo "============================================================"
echo "11. Check for PBS Hooks"
echo "============================================================"
qmgr -c "print hook" 2>&1 | head -50 || echo "qmgr print hook failed (may need admin)"

echo ""
echo "============================================================"
echo "12. Check valid resource names"
echo "============================================================"
qmgr -c "print resource" 2>&1 | head -50 || echo "qmgr print resource failed (may need admin)"

echo ""
echo "============================================================"
echo "13. Test resource request syntax (dry run)"
echo "============================================================"
echo "Testing: select=1:ncpus=1:mem=1gb"
qsub -l select=1:ncpus=1:mem=1gb -l walltime=00:01:00 -- /bin/hostname 2>&1 && echo "Submitted successfully" || echo "Failed to submit"

echo ""
echo "============================================================"
echo "14. Check pbs_mom logs (if accessible)"
echo "============================================================"
ls -la /var/spool/pbs/mom_logs/ 2>&1 | tail -5 || echo "Cannot access mom_logs"

echo ""
echo "============================================================"
echo "15. Check PBS accounting logs (if accessible)"
echo "============================================================"
ls -la /var/spool/pbs/server_logs/ 2>&1 | tail -5 || echo "Cannot access server_logs"

echo ""
echo "============================================================"
echo "DIAGNOSTICS COMPLETE"
echo "============================================================"
