#include <cuda.h>
#include <stdio.h>
#include <math.h>

#include <stdlib.h>
#include <sys/time.h>
float *A,*L,*U,*input;
void arrayInit(int n);
void verifyLU(int n);
void updateLU(int n);
void freemem(int n);

__global__ void scale( float *a, int size, int c) {
	int index=c,k=0;//size=b

		for(k=index+1;k<size;k++) {
			a[size*index + k] = (float) a[size*index + k] / a[size*index + index];
		}

}
__global__ void reduce( float *a, int size, int c) {
	int tid = blockIdx.x;	//Handle the data at the index
	int index=c,j=0;//size=b

	for(j=index+1;j<size;j++) {
		a[((tid+index+1)*size + j)] = (float)(a[((tid+index+1)*size + j)] - (float)a[((tid+index+1)*size+index)] * a[((index*size) + j)]);
	}

}

int main(int argc,char **argv){
	float *dev_a;
	int i,p,q,n=0;
	struct timeval bef,aft;
 	long duration=0;

	n = atoi(argv[1]); // obtain the size of matrix

A = (float *) malloc(sizeof(float) * n * n);
L = (float *) malloc(sizeof(float) * n * n);
U = (float *) malloc(sizeof(float) * n * n);
input = (float *) malloc(sizeof(float*) * n * n);

	
	//allocate the memory on the GPU
	cudaMalloc ((void**)&dev_a,n * n * sizeof(float));
	
	arrayInit(n);	// initialize the array

	//copy the arrays 'a' and 'b' to the GPU
	cudaMemcpy( dev_a, A, n * n * sizeof(float), cudaMemcpyHostToDevice);
	gettimeofday(&bef,NULL);
	for(i = 0;i<n;i++) {
	scale<<<1, 1>>> (dev_a, n, i);
	reduce<<<n-i-1,1>>>(dev_a, n, i);
	}
	gettimeofday(&aft,NULL);
	duration = aft.tv_sec - bef.tv_sec;
 	printf("%ld --- %d  \n",duration,n);

	//copy the array 'c' back from the GPU to the CPU
	cudaMemcpy( A, dev_a, n * n * sizeof(float),cudaMemcpyDeviceToHost );
								
	//update the array and display the results

	printf("\n");	
	updateLU(n);

	//free the memory allocated on the GPU
	cudaFree( dev_a );
	
	return 0;
}
void updateLU(int n) {
	int i=0,j=0;
	for(i=0;i<n;i++) {
		for(j=i+1;j<n;j++) {
			U[i*n + j] = A[i*n + j];
		}
	}
	for(i=0;i<n;i++) {
		for(j=0;j<i+1;j++) {
			L[i*n + j] = A[i*n + j];
		}
	}

	verifyLU(n);
}
void arrayInit(int n) {
	int i=0,j=0;

	/* Initialize the Random Number Generator*/

	for(i=0;i<n;i++) {
		for(j=0;j<n;j++) {
			A[i*n + j] = (rand() % 5) + 1.0;
			input[i*n + j] = A[i*n + j];
			L[i*n + j] = 0.0f;
			if(i == j) {
				U[i*n + j] = 1.0f;
			}
			else {
				U[i*n + j] = 0.0f;
			}

	}
	}
}
/*
 * Performs the Multiplication of Lower and Upper Matricies and verify
 * the result of the reconstructed Matrix.
 */
void verifyLU(int n) {
int i=0,j=0,k=0;
float sum=0,error=0;
for(i=0;i<n;i++) {

	for(j=0;j<n;j++) {
		for(k=0;k<n;k++) {
			sum += L[i*n + k]*U[k*n + j];
		}
		A[i*n + j] = sum;
		error += input[i*n + j] - A[i*n + j];
		sum=0;
	}
}
//printf(" The error is %lf \n",error);
/* PRINT OUT VERIFIED MATRIX */
 printf("\n REST MATX \n");
/*
for(i=0;i<n;i++) {
	for(j=0;j<n;j++) {
		printf("%lf  ",A[i*n + j]);
	}
	printf("\n");
}

for(i=0;i<n;i++) {
	for(j=0;j<n;j++) {
		printf("%lf  ",input[i*n + j]);
	}
	printf("\n");
}
*/
if(error != error || error < 1 || error > -1) {
printf("Success \n”);
}
}
void freemem(int n) {
  int i=0;
for (i = 0; i < n; i++) {
  float * pt = A;
float * ptl = L;
float * ptu = U;  
 free(pt);
 free(ptl);
 free(ptu); 
	}

}
