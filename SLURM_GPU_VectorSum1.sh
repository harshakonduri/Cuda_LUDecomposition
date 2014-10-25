#!/bin/bash
#SBATCH --partition=debug
#SBATCH --gres=gpu:2
#SBATCH --nodes=1
#SBATCH --tasks-per-node=1
#SBATCH --job-name=Vector_Sum1
#SBATCH --time=00:10:00
#SBATCH --mail-user=sreehars@buffalo.edu
#SBATCH --output=Result_Vector_Sum1.out
#SBATCH --error=Result_Vector_Sum1.out

echo "SLURM Environment Variables:"
echo "Job ID = "$SLURM_JOB_ID
echo "Job Name = "$SLURM_JOB_NAME
echo "Job Node List = "$SLURM_JOB_NODELIST
echo "Number of Nodes = "$SLURM_NNODES
echo "Tasks per node = "$SLURM_NTASKS_PER_NODE
echo "CPUs per task = "$SLURM_CPUS_PER_TASK
echo "/scratch/jobid = "$SLURMTMPDIR
echo "Submit Host = "$SLURM_SUBMIT_HOST
echo "Submit Directory = "$SLURM_SUBMIT_DIR
echo 
echo

ulimit -s unlimited
#
./shar 800
#
echo "All Done!"
