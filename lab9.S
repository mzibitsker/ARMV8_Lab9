	.extern printf
	.extern malloc
	.globl acopy, square, riemann, dmax, threeN

// dmax(a,b) returns the maximum of a and b

dmax:
    FCMP D0, D1
    B.LT dubs_1
    B.GT dubs_0


    dubs_0:
     B Done
    dubs_1:
    FMOV D0,D1
Done:
    RET


// riemann(a,b,N) computes a riemann sum of f(x) = x*x on [a,b]

riemann:     // D0 is a, D1 is b, X0 is N
	// b-a
	FSUB D8, D1, D0
	// sum
	FMOV D9, XZR
	// convert N into a double
	SCVTF D10, X0
	// dx = (b-a)/N
	FDIV D8, D8,D10

	// iterator i = 0
	MOV X7, XZR

Test:
	// test if i < N
	CMP X7, X0
	B.LT inner
	B.EQ Done1

inner:
	// double x = a + (i+0.5) * dx
	// convert iterator into double
	SCVTF D11, X7
	// add iterator with 0.5
	FMOV D15, #0.5
	// d12 = .05 + i
	FADD D12, D11, D15
	// d13 =  (i+ 0.5) * dx
	FMUL D13, D12,D8
	// double x = a + (i+0.5) *dx
	FADD D13, D0, D13
	// double y= x*x
	FMUL D14, D13, D13
	// sum = sum + y
	FADD D9, D9, D14
	// increment iterator
	ADD X7, X7, #1

	B Test


Done1:
	FMUL D0,D9,D8
	RET


// square(x) prints x and its square

square:
    MOV X20, X30     // Save return address in X20
    FMUL D1, D0, D0  // Put square of D0 in D1
    LDR X0, =sqstr   // Address of string in X0
    BL printf        // Call printf
    MOV X30, X20     // Restore return address to X30
    RET

sqstr: .asciz "The square of %f is %f\n"
     .balign 4


// threeN(N) prints the 3N+1 sequence starting at N

threeN:


		MOV X21, X0
// first print
        mov x1, x21
		MOV X25, X30     // Save return address in X20
		LDR X0, =sqstr1
		BL printf


    loop:
    	// second print

    	MOV X1, X21



    	LDR X0, =sqstr2
    	BL printf

    	MOV X1, #1
		MOV X3, #2
		MOV X4, #3

    	MOV X0, X21


    	CMP X0, X1
    	B.EQ done2

   	LSL X2,X0, #63
    	LSR X2,X2, #63
    	CMP X2, X1
    	//false
    	B.EQ odd
	B.LT even



even:	
    	UDIV X0, X0,  X3
    	MOV X21, X0
 		B loop

    	//true
    	// 3*N

    odd:
    	MUL X0,X0, X4
 		// 3*n + 1
 		ADD X0, X0, #1
 		MOV X21, X0
 		B loop




    done2:
    	MOV X0, X21
    	MOV X30, X25
    	RET


sqstr1: .asciz "The 3N+1 sequence starting from %lld:\n"
	.balign 4
sqstr2: .asciz "      %lld\n"
	.balign 4

// acopy(a,n) creates a copy of an array, a, of double with length n

acopy:
	// x0 - address of array of doubles
	// X1 - length of the array

     	// save address of array in memory
    	MOV X20, X0 // address of array
      	MOV X21,X1 // length of array

		// move 8 into reg3
		MOV X3, #8
		// multiply n*8 -- size of the block of memory
		MUL X0,x3, x1
		// store the return address
		MOV X22, X30

		// input x0 into malloc function
		BL malloc

		//
		// retstore the return address
		MOV X30, X22

		// store address of the new array in register x23

		MOV X23, X0 // temp value
		MOV X24, X0 // copy of original
		// restore the return address and any other values
		MOV X0, X20
		MOV X1, X21
		MOV X3, #8
		// proceed to copy numbers from the original array into the new array

		// create iterator -- i = 0
		MOV X4, #0
		loop1:
		// test 1
			CMP X4, X1
			B.LT inner2
			B.EQ done3



		inner2:
			// B[i] = A[i]

			// load A[i]
			LDUR D1, [X0, #0]
			// increment array
			ADD X0,X0,X3
			// store A[i] into B[i]

			STUR D1, [X23, #0]
			// increment array

			// increment index
			ADD X4, X4, #1

			B loop1





	done3:
		MOV X0, X24 // put original address of array into x0
		RET



