j	.start	
LBI	r0, -1		
LBI	r1, -1		
LBI	r2, -1		
LBI	r3, -1
LBI	r4, -1
LBI	r5, -1
LBI	r6, -1
LBI	r7, -1	
halt
halt
halt
halt
halt
	
.start:
LBI	r0, 0		
LBI	r1, 0	
LBI	r2, 0	
LBI	r3, 0
LBI	r4, 0	
LBI	r5, 0	
LBI	r6, 0	
LBI	r7, 0	
addi	r0, r0, 5	

.loop:	
st	r0, r1, 0	
ld	r0, r1, 0	
addi	r0, r0, -1	
bnez	r0, .loop
halt			
addi	r0, r0, 1	
