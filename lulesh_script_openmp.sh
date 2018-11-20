#!/bin/sh

#Length of cube mesh along side
CUBE_SIZE=30

#Number of cycles to run
CYCLES=1000

#delete outputfile
rm -f output2.txt

#Number of threads to run
threads=(1 8 16 24 32 40 48)

############OpenMP / MPI
echo "Executing OpenMP version"
LULESH_EXEC=LULESH-OpenMP_MPI/lulesh2.0
IDX=-1
for i in `seq 0 209`
do
  if [ `expr $i % 30` == 0 ] ; then
    IDX=$((IDX + 1))
    export OMP_NUM_THREADS=${threads[IDX]}
    echo "running  - ${threads[IDX]} - $i" 
  fi 
  $LULESH_EXEC  -s $CUBE_SIZE -i $CYCLES -q >> output2.txt 
done




