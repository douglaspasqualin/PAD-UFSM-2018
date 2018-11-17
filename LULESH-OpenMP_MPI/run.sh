#Parameters
# -q              : quiet mode - suppress all stdout
# -i <iterations> : number of cycles to run
# -s <size>       : length of cube mesh along side
# -r <numregions> : Number of distinct regions (def: 11)
# -b <balance>    : Load balance between regions of a domain (def: 1)
# -c <cost>       : Extra cost of more expensive regions (def: 1)
# -f <numfiles>   : Number of files to split viz dump into (def: (np+10)/9)
# -p              : Print out progress
# -v              : Output viz file (requires compiling with -DVIZ_MESH
# -h              : This message

#OpenMP version
#OMP_NUM_THREADS=48 ./lulesh2.0 -i 8 -s 64 -p

#Mpi
OMP_NUM_THREADS=6 /home/dpasqualin/opt/openmpi-4.0.0/bin/mpirun -n 8 ./lulesh2.0  -s 30 -i 1000 -q

