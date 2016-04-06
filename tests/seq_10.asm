// Test provided by Karu 
//SEQ test 8.  Test when rd, rs, and rt are the same register
//
// Michael McKinley (mckinley)

lbi r0, 0
lbi r1, 0xff
slbi r1, 0xff
seq r3, r0, r1
lbi r1, 0xef
slbi r1, 0xff
seq r3, r1, r1
lbi r1, 0xdf
slbi r1, 0xff
seq r3, r1, r1
lbi r1, 0xcf
slbi r1, 0xff
seq r3, r1, r1
lbi r1, 0xbf
slbi r1, 0xff
seq r3, r0, r1
lbi r1, 0xaf
slbi r1, 0xff
seq r3, r1, r1
lbi r1, 0x9f
slbi r1, 0xff
seq r3, r0, r1
lbi r1, 0x8f
slbi r1, 0xff
seq r3, r1, r1
lbi r1, 0x7f
slbi r1, 0xff
seq r3, r0, r1
lbi r1, 0x6f
slbi r1, 0xff
seq r3, r1, r1
lbi r1, 0x5f
slbi r1, 0xff
seq r3, r0, r1
lbi r1, 0x4f
slbi r1, 0xff
seq r3, r1, r1
lbi r1, 0x3f
slbi r1, 0xff
seq r3, r0, r1
lbi r1, 0x2f
slbi r1, 0xff
seq r3, r1, r1
lbi r1, 0x1f
slbi r1, 0xff
seq r3, r0, r1
lbi r1, 0x0f
slbi r1, 0xff
seq r3, r1, r1
lbi r1, 0xfe
slbi r1, 0xff
seq r3, r0, r1
halt
