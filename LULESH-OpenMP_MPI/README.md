## LULESH

Official Lulesh implementation

Forked from: https://github.com/LLNL/LULESH

### Prerequisites
- Edit the MakeFile
- Change the variable CXX to point for the version that you wish to use
- Example: 
- `CXX = $(MPICXX)` to use MPI + OpenMP
- `CXX = $(SERCXX)` to use OpenMP only


### Compiling
Just type 

`make`

### Running
Verify the parameters in the run.sh and just type

`./run.sh`
