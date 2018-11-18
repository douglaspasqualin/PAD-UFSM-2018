#!/bin/sh

#MPIRUN=mpirun
MPIRUN=/home/dpasqualin/opt/openmpi-4.0.0/bin/mpirun

#Processors  must be a cube of an integer (1, 8, 27, ...)
#PS: The number of OpenMP threads will be used in each processor. 
#For example, 8 processors and 4 threads = 32 threads in total.
NUM_PROC=8

#Length of cube mesh along side
CUBE_SIZE=30

#Number of cycles to run
CYCLES=1

#delete outputfile
rm -f output.txt

############OpenMP / MPI
echo "Executing OpenMP / MPI version"
LULESH_EXEC=LULESH-OpenMP_MPI/lulesh2.0
THREADS=1
export OMP_NUM_THREADS=$THREADS
echo "running  - $THREADS"
for i in `seq 1 180`
do
  if [ `expr $i % 30` == 0 ] && [  "$i" -lt "180" ] ; then
    THREADS=$((THREADS + 1))
    export OMP_NUM_THREADS=$THREADS
    echo "running  - $THREADS"
  fi 
  $MPIRUN -n $NUM_PROC $LULESH_EXEC  -s $CUBE_SIZE -i $CYCLES -q >> output.txt 
done


##########DASH version
echo "Executing DASH version"
LULESH_EXEC=LULESH-DASH/build/lulesh
THREADS=1
export OMP_NUM_THREADS=$THREADS
echo "running  - $THREADS"
for i in `seq 1 180`
do
  if [ `expr $i % 30` == 0 ] && [  "$i" -lt "180" ] ; then
    echo "ok - $THREADS"
    THREADS=$((THREADS + 1))
    export OMP_NUM_THREADS=$THREADS
  fi 
  $MPIRUN -n $NUM_PROC $LULESH_EXEC  -s $CUBE_SIZE -i $CYCLES -px 2 -py 2 -pz 2 -q >> output.txt 
done

