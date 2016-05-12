onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -format Logic /proc_hier_pbench/DUT/c0/clk
add wave -noupdate -format Logic /proc_hier_pbench/DUT/c0/rst
add wave -noupdate -format Logic /proc_hier_pbench/DUT/c0/err
add wave -noupdate -format Literal /proc_hier_pbench/DUT/c0/cycle_count
add wave -noupdate -format Logic /proc_hier_pbench/DUT/c0/clk
add wave -noupdate -format Logic /proc_hier_pbench/DUT/c0/rst
add wave -noupdate -format Logic /proc_hier_pbench/DUT/c0/err
add wave -noupdate -format Literal /proc_hier_pbench/DUT/c0/cycle_count
add wave -noupdate -format Logic -radix hexadecimal /proc_hier_pbench/DUT/p0/clk
add wave -noupdate -format Logic -radix hexadecimal /proc_hier_pbench/DUT/p0/if_valid
add wave -noupdate -format Logic -radix hexadecimal /proc_hier_pbench/DUT/p0/id_valid
add wave -noupdate -format Literal -radix hexadecimal /proc_hier_pbench/DUT/p0/if_instruction
add wave -noupdate -format Literal -radix hexadecimal /proc_hier_pbench/DUT/p0/if_pc_plus
add wave -noupdate -format Logic -radix hexadecimal /proc_hier_pbench/DUT/p0/icache_done
add wave -noupdate -format Logic -radix hexadecimal /proc_hier_pbench/DUT/p0/icache_stall
add wave -noupdate -format Logic -radix hexadecimal /proc_hier_pbench/DUT/p0/icache_hit
add wave -noupdate -divider {if flop}
add wave -noupdate -format Logic -radix hexadecimal /proc_hier_pbench/DUT/p0/id_alu_res_sel
add wave -noupdate -format Logic -radix hexadecimal /proc_hier_pbench/DUT/p0/id_branch
add wave -noupdate -format Logic -radix hexadecimal /proc_hier_pbench/DUT/p0/id_branch_eqz
add wave -noupdate -format Logic -radix hexadecimal /proc_hier_pbench/DUT/p0/id_regWrite
add wave -noupdate -format Literal -radix hexadecimal /proc_hier_pbench/DUT/p0/id_instruction_w
add wave -noupdate -format Literal -radix hexadecimal /proc_hier_pbench/DUT/p0/id_sign_ext_low_bits
add wave -noupdate -format Literal -radix hexadecimal /proc_hier_pbench/DUT/p0/id_reg2_data
add wave -noupdate -format Literal -radix hexadecimal /proc_hier_pbench/DUT/p0/id_reg1_data
add wave -noupdate -format Literal -radix hexadecimal /proc_hier_pbench/DUT/p0/id_reg2_sel
add wave -noupdate -format Literal -radix hexadecimal /proc_hier_pbench/DUT/p0/id_reg1_sel
add wave -noupdate -format Literal -radix hexadecimal /proc_hier_pbench/DUT/p0/id_write_reg
add wave -noupdate -format Literal -radix hexadecimal /proc_hier_pbench/DUT/p0/id_alu_op
add wave -noupdate -format Literal -radix hexadecimal /proc_hier_pbench/DUT/p0/id_set_select
add wave -noupdate -format Literal -radix hexadecimal /proc_hier_pbench/DUT/p0/id_pc_dec
add wave -noupdate -format Literal -radix hexadecimal /proc_hier_pbench/DUT/p0/id_memToReg
add wave -noupdate -format Literal -radix hexadecimal /proc_hier_pbench/DUT/p0/id_ALUSrc_b
add wave -noupdate -format Literal -radix hexadecimal /proc_hier_pbench/DUT/p0/id_ALUSrc_a
add wave -noupdate -format Literal -radix hexadecimal /proc_hier_pbench/DUT/p0/id_instruction
add wave -noupdate -format Literal -radix hexadecimal /proc_hier_pbench/DUT/p0/id_pc_plus
add wave -noupdate -format Logic -radix hexadecimal /proc_hier_pbench/DUT/p0/id_rs_valid
add wave -noupdate -format Logic -radix hexadecimal /proc_hier_pbench/DUT/p0/id_rt_valid
add wave -noupdate -divider {ex flop}
add wave -noupdate -format Logic -radix hexadecimal /proc_hier_pbench/DUT/p0/ex_rs_valid
add wave -noupdate -format Literal -radix hexadecimal /proc_hier_pbench/DUT/p0/ex_reg1_sel
add wave -noupdate -format Literal -radix hexadecimal /proc_hier_pbench/DUT/p0/ex_reg1_data
add wave -noupdate -format Literal -radix hexadecimal /proc_hier_pbench/DUT/p0/reg1_forward
add wave -noupdate -format Logic -radix hexadecimal /proc_hier_pbench/DUT/p0/ex_rt_valid
add wave -noupdate -format Literal -radix hexadecimal /proc_hier_pbench/DUT/p0/ex_reg2_sel
add wave -noupdate -format Literal -radix hexadecimal /proc_hier_pbench/DUT/p0/ex_reg2_data
add wave -noupdate -format Literal -radix hexadecimal /proc_hier_pbench/DUT/p0/reg2_forward
add wave -noupdate -format Logic -radix hexadecimal /proc_hier_pbench/DUT/p0/ex_regWrite
add wave -noupdate -format Literal -radix hexadecimal /proc_hier_pbench/DUT/p0/ex_alu_out
add wave -noupdate -format Literal -radix hexadecimal /proc_hier_pbench/DUT/p0/ex_sign_ext_low_bits
add wave -noupdate -format Literal -radix hexadecimal /proc_hier_pbench/DUT/p0/ex_pc_plus
add wave -noupdate -format Literal -radix hexadecimal /proc_hier_pbench/DUT/p0/ex_instruction
add wave -noupdate -format Literal -radix hexadecimal /proc_hier_pbench/DUT/p0/ex_write_reg
add wave -noupdate -format Literal -radix hexadecimal /proc_hier_pbench/DUT/p0/ex_alu_op
add wave -noupdate -format Literal -radix hexadecimal /proc_hier_pbench/DUT/p0/ex_set_select
add wave -noupdate -format Literal -radix hexadecimal /proc_hier_pbench/DUT/p0/ex_pc_dec
add wave -noupdate -format Literal -radix hexadecimal /proc_hier_pbench/DUT/p0/ex_memToReg
add wave -noupdate -format Literal -radix hexadecimal /proc_hier_pbench/DUT/p0/ex_ALUSrc_b
add wave -noupdate -format Literal -radix hexadecimal /proc_hier_pbench/DUT/p0/ex_ALUSrc_a
add wave -noupdate -format Literal -radix hexadecimal /proc_hier_pbench/DUT/p0/pc_decision
add wave -noupdate -divider mem_flop
add wave -noupdate -format Logic -radix hexadecimal /proc_hier_pbench/DUT/p0/mem_regWrite
add wave -noupdate -format Literal -radix hexadecimal /proc_hier_pbench/DUT/p0/mem_sign_ext_low_bits
add wave -noupdate -format Literal -radix hexadecimal /proc_hier_pbench/DUT/p0/mem_reg2_data
add wave -noupdate -format Literal -radix hexadecimal /proc_hier_pbench/DUT/p0/mem_pc_plus
add wave -noupdate -format Literal -radix hexadecimal /proc_hier_pbench/DUT/p0/mem_alu_out
add wave -noupdate -format Literal -radix hexadecimal /proc_hier_pbench/DUT/p0/mem_write_reg
add wave -noupdate -format Literal -radix hexadecimal /proc_hier_pbench/DUT/p0/mem_memToReg
add wave -noupdate -format Literal -radix hexadecimal /proc_hier_pbench/DUT/p0/mem_read_data
add wave -noupdate -divider {wb flop}
add wave -noupdate -format Logic -radix hexadecimal /proc_hier_pbench/DUT/p0/wb_regWrite
add wave -noupdate -format Logic -radix hexadecimal /proc_hier_pbench/DUT/p0/wb_halt
add wave -noupdate -format Literal -radix hexadecimal /proc_hier_pbench/DUT/p0/wb_mem_write_back
add wave -noupdate -format Literal -radix hexadecimal /proc_hier_pbench/DUT/p0/wb_sign_ext_low_bits
add wave -noupdate -format Literal -radix hexadecimal /proc_hier_pbench/DUT/p0/wb_read_data
add wave -noupdate -format Literal -radix hexadecimal /proc_hier_pbench/DUT/p0/wb_pc_plus
add wave -noupdate -format Literal -radix hexadecimal /proc_hier_pbench/DUT/p0/wb_alu_out
add wave -noupdate -format Literal -radix hexadecimal /proc_hier_pbench/DUT/p0/wb_write_reg
add wave -noupdate -format Literal -radix hexadecimal /proc_hier_pbench/DUT/p0/wb_memToReg
add wave -noupdate -divider {New Signals}
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {675 ns} 0}
WaveRestoreZoom {0 ns} {1703 ns}
configure wave -namecolwidth 328
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
