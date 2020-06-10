/* main.c simple program to run assembler subroutines */

#include <stdio.h>
#include <string.h>

/* Prototypes (declarations without definitions) of the subroutines that
 * are defined in assembly language.  All parameters and return values
 * are 64-bit values, either of type long long int or pointers to
 * arrays or strings.  */

// find the maximum of two double values
double dmax( double a, double b );

// computer a riemann sum for the function f(x) = x*x
double riemann( double a, double b, long long int N);

// Print a number and its square.
void square(double x);

// Print the 3N+1 sequence for N
void threeN(unsigned long long int N);

// Create a new array that is a copy of an existing array with a given length
double *acopy( double a[], long long int length);


int main(void) {

	printf("\nTesting dmax().\n");
	double x = dmax(3.14, 2.78);
	printf("The max of %f and %f is %f\n", 3.14, 2.78, x);
	double y = dmax(x,17.42);
	printf("The max of %f and %f is %f\n", x, 17.42, y);

	printf("\nTesting riemann().\n");
	x = riemann( 0, 1, 4 );
	printf("riemann(0,1,4) = %f\n", x);
	y = riemann( 1, 3, 1000 );
	printf("riemann(1,3,1000) = %f\n", y);

	printf("\nTesting square().\n");
	square(3.14);
	square(2.17);

	printf("\nTesting threeN().\n");
	threeN(3);

	printf("\nTesting acopy().\n");
	double original[] = { 3.14, 2.71828, 1.68, 0, -17.42};
	double *copy = acopy(original, 5);
	printf("Orignal is at %p; copy is at %p\n", original, copy);
	printf("The contents of the original and of the copy:\n");
	for (int i = 0; i < 5; i++) {
		printf("%10.5g %10.5g\n", original[i], copy[i]);
	}

    return 0;
}
