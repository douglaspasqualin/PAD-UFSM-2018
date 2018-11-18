#!/bin/sh

#MPIRUN=mpirun
MPIRUN = /home/dpasqualin/opt/openmpi-4.0.0/bin/mpirun

#Processors  must be a cube of an integer (1, 8, 27, ...)
#PS: The number of OpenMP threads will be used in each processor. 
#For example, 8 processors and 4 threads = 32 threads in total.
NUM_PROC=8

#Length of cube mesh along side
CUBE_SIZE=30

#Number of cycles to run
CYCLES=10000

##########OpenMP / MPI version
echo "Executing OpenMP / MPI version - 1 thread"
OMP_NUM_THREADS=1
for i in `seq 1 30`
do
$MPIRUN -n $NUM_PROC LULESH-OpenMP_MPI/lulesh2.0  -s $CUBE_SIZE -i $CYCLES -q >> output.txt
done

#16 
echo "Executing OpenMP / MPI version - 16 thread"
OMP_NUM_THREADS=2
for i in `seq 1 30`
do
$MPIRUN -n $NUM_PROC LULESH-OpenMP_MPI/lulesh2.0  -s $CUBE_SIZE -i $CYCLES -q >> output.txt
done

#24
echo "Executing OpenMP / MPI version - 24 thread"
OMP_NUM_THREADS=3
for i in `seq 1 30`
do
$MPIRUN -n $NUM_PROC LULESH-OpenMP_MPI/lulesh2.0  -s $CUBE_SIZE -i $CYCLES -q >> output.txt
done

#32
echo "Executing OpenMP / MPI version - 32 thread"
OMP_NUM_THREADS=4
for i in `seq 1 30`
do
$MPIRUN -n $NUM_PROC LULESH-OpenMP_MPI/lulesh2.0  -s $CUBE_SIZE -i $CYCLES -q >> output.txt
done

#40
echo "Executing OpenMP / MPI version - 40 thread"
OMP_NUM_THREADS=5
for i in `seq 1 30`
do
$MPIRUN -n $NUM_PROC LULESH-OpenMP_MPI/lulesh2.0  -s $CUBE_SIZE -i $CYCLES -q >> output.txt
done

#48
echo "Executing OpenMP / MPI version - 48 thread"
OMP_NUM_THREADS=6
for i in `seq 1 30`
do
$MPIRUN -n $NUM_PROC LULESH-OpenMP_MPI/lulesh2.0  -s $CUBE_SIZE -i $CYCLES -q >> output.txt
done




##########DASH version
