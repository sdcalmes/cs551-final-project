onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -format Logic /proc_hier_pbench/DUT/p0/clk
add wave -noupdate -format Logic /proc_hier_pbench/DUT/p0/icache_done
add wave -noupdate -format Logic /proc_hier_pbench/DUT/p0/icache_stall
add wave -noupdate -format Logic /proc_hier_pbench/DUT/p0/icache_hit
add wave -noupdate -format Logic /proc_hier_pbench/DUT/p0/id_memEn
add wave -noupdate -format Logic /proc_hier_pbench/DUT/p0/id_memWrite
add wave -noupdate -format Logic /proc_hier_pbench/DUT/p0/id_regWrite
add wave -noupdate -format Logic /proc_hier_pbench/DUT/p0/decode0/regWrite_1
add wave -noupdate -format Literal -radix hexadecimal /proc_hier_pbench/DUT/p0/id_write_reg
add wave -noupdate -format Literal -radix hexadecimal /proc_hier_pbench/DUT/p0/if_instruction
add wave -noupdate -format Literal -radix hexadecimal /proc_hier_pbench/DUT/p0/id_instruction_w
add wave -noupdate -format Literal -radix hexadecimal /proc_hier_pbench/DUT/p0/decode0/instruction
add wave -noupdate -format Logic /proc_hier_pbench/DUT/p0/wr_stall
add wave -noupdate -format Logic /proc_hier_pbench/DUT/p0/mem_regWrite
add wave -noupdate -format Logic /proc_hier_pbench/DUT/p0/wb_halt
add wave -noupdate -format Literal -radix hexadecimal /proc_hier_pbench/DUT/p0/wb_mem_write_back
add wave -noupdate -format Literal -radix hexadecimal /proc_hier_pbench/DUT/p0/wb_pc_plus
add wave -noupdate -format Literal -radix hexadecimal /proc_hier_pbench/DUT/p0/wb_alu_out
add wave -noupdate -format Logic /proc_hier_pbench/DUT/p0/ex_regWrite
add wave -noupdate -format Literal -radix hexadecimal /proc_hier_pbench/DUT/p0/ex_write_reg
add wave -noupdate -format Literal -radix hexadecimal /proc_hier_pbench/DUT/p0/wb_write_reg
add wave -noupdate -format Literal -radix hexadecimal /proc_hier_pbench/DUT/p0/id_instruction
add wave -noupdate -format Literal -radix hexadecimal /proc_hier_pbench/DUT/p0/ex_instruction
add wave -noupdate -format Logic /proc_hier_pbench/DUT/p0/decode0/wb_regWrite
add wave -noupdate -format Logic /proc_hier_pbench/DUT/p0/decode0/clk
add wave -noupdate -format Logic /proc_hier_pbench/DUT/p0/decode0/rst
add wave -noupdate -format Logic /proc_hier_pbench/DUT/p0/decode0/wr_stall
add wave -noupdate -format Logic /proc_hier_pbench/DUT/p0/decode0/alu_res_sel
add wave -noupdate -format Logic /proc_hier_pbench/DUT/p0/decode0/branch
add wave -noupdate -format Logic /proc_hier_pbench/DUT/p0/decode0/branch_eqz
add wave -noupdate -format Logic /proc_hier_pbench/DUT/p0/decode0/branch_gtz
add wave -noupdate -format Logic /proc_hier_pbench/DUT/p0/decode0/branch_ltz
add wave -noupdate -format Logic /proc_hier_pbench/DUT/p0/decode0/Cin
add wave -noupdate -format Logic /proc_hier_pbench/DUT/p0/decode0/invA
add wave -noupdate -format Logic /proc_hier_pbench/DUT/p0/decode0/invB
add wave -noupdate -format Logic /proc_hier_pbench/DUT/p0/decode0/id_memEn
add wave -noupdate -format Logic /proc_hier_pbench/DUT/p0/decode0/memWrite
add wave -noupdate -format Logic /proc_hier_pbench/DUT/p0/decode0/id_regWrite
add wave -noupdate -format Logic /proc_hier_pbench/DUT/p0/decode0/sign_alu
add wave -noupdate -format Logic /proc_hier_pbench/DUT/p0/decode0/control_err
add wave -noupdate -format Logic /proc_hier_pbench/DUT/p0/decode0/halt
add wave -noupdate -format Logic /proc_hier_pbench/DUT/p0/decode0/createdump
add wave -noupdate -format Logic /proc_hier_pbench/DUT/p0/decode0/regWrite_w
add wave -noupdate -format Logic /proc_hier_pbench/DUT/p0/decode0/memEn_w
add wave -noupdate -format Logic /proc_hier_pbench/DUT/p0/decode0/regWrite
add wave -noupdate -format Logic /proc_hier_pbench/DUT/p0/decode0/regWrite_2
add wave -noupdate -format Logic /proc_hier_pbench/DUT/p0/decode0/memEn
add wave -noupdate -format Logic /proc_hier_pbench/DUT/p0/decode0/memEn_1
add wave -noupdate -format Logic /proc_hier_pbench/DUT/p0/decode0/memEn_2
add wave -noupdate -format Literal /proc_hier_pbench/DUT/p0/decode0/regWrite_nxtState
add wave -noupdate -format Literal /proc_hier_pbench/DUT/p0/decode0/memEn_nxtState
add wave -noupdate -format Literal /proc_hier_pbench/DUT/p0/decode0/write_reg_w
add wave -noupdate -format Literal /proc_hier_pbench/DUT/p0/decode0/sign_ext_low_bits_w
add wave -noupdate -format Logic /proc_hier_pbench/DUT/p0/decode0/i_type_err_w
add wave -noupdate -format Logic /proc_hier_pbench/DUT/p0/decode0/i_type_err
add wave -noupdate -format Literal -radix hexadecimal /proc_hier_pbench/DUT/p0/decode0/sign_extd
add wave -noupdate -format Literal -radix hexadecimal /proc_hier_pbench/DUT/p0/decode0/ALUOp
add wave -noupdate -format Literal -radix hexadecimal /proc_hier_pbench/DUT/p0/decode0/regDst
add wave -noupdate -format Literal -radix hexadecimal /proc_hier_pbench/DUT/p0/decode0/memEn_state
add wave -noupdate -format Literal -radix hexadecimal /proc_hier_pbench/DUT/p0/decode0/regWrite_state
add wave -noupdate -format Literal -radix hexadecimal /proc_hier_pbench/DUT/p0/decode0/sign_ext_low_bits
add wave -noupdate -format Literal -radix hexadecimal /proc_hier_pbench/DUT/p0/decode0/reg2_data
add wave -noupdate -format Literal -radix hexadecimal /proc_hier_pbench/DUT/p0/decode0/reg1_data
add wave -noupdate -format Literal -radix hexadecimal /proc_hier_pbench/DUT/p0/decode0/id_write_reg
add wave -noupdate -format Literal -radix hexadecimal /proc_hier_pbench/DUT/p0/decode0/alu_op
add wave -noupdate -format Literal -radix hexadecimal /proc_hier_pbench/DUT/p0/decode0/set_select
add wave -noupdate -format Literal -radix hexadecimal /proc_hier_pbench/DUT/p0/decode0/pc_dec
add wave -noupdate -format Literal -radix hexadecimal /proc_hier_pbench/DUT/p0/decode0/memToReg
add wave -noupdate -format Literal -radix hexadecimal /proc_hier_pbench/DUT/p0/decode0/ALUSrc_b
add wave -noupdate -format Literal -radix hexadecimal /proc_hier_pbench/DUT/p0/decode0/ALUSrc_a
add wave -noupdate -format Literal -radix hexadecimal /proc_hier_pbench/DUT/p0/decode0/mem_write_back
add wave -noupdate -format Literal -radix hexadecimal /proc_hier_pbench/DUT/p0/decode0/wb_write_reg
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {2101 ns} 0}
WaveRestoreZoom {0 ns} {6728 ns}
configure wave -namecolwidth 340
configure wave -valuecolwidth 39
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
