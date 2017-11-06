#!/bin/bash
#----------------------------------------------------
# Sample SLURM job script
#   for TACC Stampede2 KNL nodes
#
#   *** Serial Job on Normal Queue ***
#
# Last revised: 27 Jun 2017
#
# Notes:
#
#   -- Copy/edit this script as desired.  Launch by executing
#      "sbatch knl.serial.slurm" on a Stampede2 login node.
#
#   -- Serial codes run on a single node (upper case N = 1).
#        A serial code ignores the value of lower case n,
#        but slurm needs a plausible value to schedule the job.
#
#   -- For a good way to run multiple serial executables at the
#        same time, execute "module load launcher" followed
#        by "module help launcher".

#----------------------------------------------------

#SBATCH -J mash-n2v-200      # Job name
#SBATCH -o mash-n2v-200.o%j  # Name of stdout output file
#SBATCH -e mash-n2v-200.e%j  # Name of stderr error file
#SBATCH -p normal            # Queue (partition) name
#SBATCH -N 1                 # Total # of nodes (must be 1 for serial)
#SBATCH -n 1                 # Total # of mpi tasks (should be 1 for serial)
#SBATCH -t 00:10:00          # Run time (hh:mm:ss)
#SBATCH --mail-user=jklynch@email.arizona.edu
#SBATCH --mail-type=all      # Send email at begin and end of job
#SBATCH -A iPlant-Collabs    # Allocation name (req'd if you have more than 1)

module list
pwd
date

module load python3

source $WORK/venv/n2v/bin/activate

node2vec \
    --input ../all-imicrobe-dist_similarity_limit_200.edgelist \
    --output all-imicrobe-dist_similarity_limit_200.emb \
    --weighted

# ---------------------------------------------------