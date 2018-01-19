#!/bin/tcsh
# 
# batch script to run pf.wrf
#
#BSUB -P UCSM0002
#BSUB -a poe         #select poe - optional
#BSUB -W 12:00        #wall clock time
#BSUB -n 528        #number of tasks
#BSUB -R "span[ptile=16]"   # run 16 mpi tasks per node
#BSUB -J SP2_grey     #job name
#BSUB -o CO.pfclm.out      #out file
#BSUB -e CO.pfclm.err      #error file
#BSUB -q regular  #queue name

cd /glade/scratch/mforrest/Thesis/PFCLM/grey_SP3

tclsh COPFCLM.tcl 
mpirun.lsf $PARFLOW_DIR/bin/parflow CO.2008.grey.pfclm


