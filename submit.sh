#!/bin/bash
#SBATCH --time=03:00:00
#SBATCH --mem=192GB
#SBATCH --gres=gpu:1
#SBATCH --nodes=1
#SBATCH --cpus-per-task=4
#SBATCH -o './logs/%A.out'
#SBATCH -e './logs/%A.err'
#SBATCH --mail-type=fail

if [[ "$HOSTNAME" == *"tiger"* ]]
then
    echo "It's tiger"
    module load anaconda
    source activate 247-main
elif [[ "$HOSTNAME" == *"della-gpu"* ]]
then
    echo "It's della-gpu"
    module load anaconda3/2020.11
    source activate torch-env
else
    module load anacondapy
    source activate srm
fi

echo 'Requester:' $USER
echo 'Node:' $HOSTNAME
echo 'Start time:' `date`
echo "$@"
if [[ -v SLURM_ARRAY_TASK_ID ]]
then
    python "$@" --conversation-id $SLURM_ARRAY_TASK_ID
else
    python "$@"
fi
echo 'End time:' `date`
