## LULESH

Official Lulesh implementation

Forked from: https://github.com/LLNL/LULESH

Specific version utilized in this repo: https://github.com/LLNL/LULESH/archive/b56882ba0c1b972631e1e54a8256d2a07893e324.zip

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
