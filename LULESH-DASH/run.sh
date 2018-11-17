#Parameters
# [-q ]        Quiet mode, suppress all output
# [-i  <int> ] Number of cycles to run
# [-s  <int> ] Specifiy number of local elements (s^3)
# [-px <int> ] Number of procs in x dimension
# [-py <int> ] Number of procs in y dimension
# [-pz <int> ] Number of procs in z dimension
# [-r  <int> ] Number of distinct regions
# [-b  <int> ] Load balance between regions of a domain
# [-c  <int> ] Extra cost of more expensive regions
# [-p ]        Print out progress
# [-v ]        Write an output file for VisIt
# [-h ]        Print help message

#MPIRUN = "/home/dpasqualin/opt/openmpi-4.0.0/bin/mpirun"

OMP_NUM_THREADS=6 /home/dpasqualin/opt/openmpi-4.0.0/bin/mpirun -n 8 ./build/lulesh -i 10 -px 2 -py 2 -pz 2 -s 128 -p
