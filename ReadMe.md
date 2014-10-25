In this file i will list the steps to run my GPU project.

The Code is available in the directory code.

The global memory implementation is in cudaglobalmemory.cu

The shared memory implementation is in cudasharedmemory.cu

The files can be compiled using mvcc -o <exe_name> <fileName>

cudaglobalmemory.cu accepts INPUT_MATRIX_SIZE as a parameter.

cudasharedmemory.cu accepts INPUT_MATRIX_SIZE and <NUM_THREADS> as a parameters.