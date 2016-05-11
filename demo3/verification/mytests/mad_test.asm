
lbi r0, 16          
lbi r1, 1           
lbi r2, 2           
lbi r3, 4           
lbi r4, 8           
lbi r5, 16          

.loop:
rol r1, r1, r0     
rol r2, r2, r0     
rol r3, r3, r0     
rol r4, r4, r0   
rol r5, r5, r0   
addi r0, r0, -1  
bnez r0, .loop   

roli r1, r1, 8      
roli r2, r2, 8      
roli r3, r3, 8      
roli r4, r4, 8      
roli r5, r5, 8      
add r1, r1, r2      
add r1, r1, r3      
add r1, r1, r4      
add r1, r1, r5      
addi r1, r1, 1      
roli r1, r1, 11     

lbi r0, U.DataArea
slbi r0, L.DataArea 
st r1, r0, 0        

lbi  r1, 6           
addi r4,r1,0         

.addloop:
ld r2, r5, 0
ld r3, r5, 2
addi r5, r5, 4
jal .Add32 
addi r6, r6, -1
bnez r6, .addloop

lbi r6, -1
xor r0, r0, r6
xor r1, r1, r6

lbi r6, 0x10  

.subloop:
ld r2, r5, 0
ld r3, r5, 2
addi r5, r5, 4
jal .Add32 
addi r6, r6, -1
bnez r6, .subloop

lbi r7, U.DataArea
slbi r7, L.DataArea
st r0, r7, 4   
st r1, r7, 6  

halt

.Add32:
sco r4, r1, r3
add r1, r1, r3
add r0, r0, r2
add r0, r0, r4
jr r7, 0        // return

halt
halt
halt

.DataArea:
halt          // 0x0001
halt          // 0x02d0
halt          // 0xffff
halt          // 0xffff


