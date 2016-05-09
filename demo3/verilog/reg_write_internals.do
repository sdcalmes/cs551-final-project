onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -format Logic /proc_hier_pbench/DUT/c0/clk
add wave -noupdate -format Literal /proc_hier_pbench/DUT/c0/cycle_count
add wave -noupdate -divider {execute values}
add wave -noupdate -format Literal -radix hexadecimal /proc_hier_pbench/DUT/p0/execute0/alu_a_input
add wave -noupdate -format Literal -radix hexadecimal /proc_hier_pbench/DUT/p0/execute0/alu_b_input
add wave -noupdate -format Literal -radix hexadecimal /proc_hier_pbench/DUT/p0/execute0/alu_op
add wave -noupdate -format Literal -radix hexadecimal /proc_hier_pbench/DUT/p0/execute0/alu_out
add wave -noupdate -divider {write_back data}
add wave -noupdate -format Literal -radix hexadecimal /proc_hier_pbench/DUT/p0/write_back/alu_out
add wave -noupdate -format Literal -radix hexadecimal /proc_hier_pbench/DUT/p0/write_back/sign_ext_low_bits
add wave -noupdate -format Literal -radix hexadecimal /proc_hier_pbench/DUT/p0/write_back/memToReg
add wave -noupdate -divider {decode data}
add wave -noupdate -format Logic -radix hexadecimal /proc_hier_pbench/DUT/p0/decode0/wb_regWrite
add wave -noupdate -format Literal -radix hexadecimal /proc_hier_pbench/DUT/p0/decode0/wb_write_reg
add wave -noupdate -format Literal -radix hexadecimal /proc_hier_pbench/DUT/p0/decode0/mem_write_back
add wave -noupdate -divider {Other signals}
add wave -noupdate -format Literal -radix hexadecimal /proc_hier_pbench/DUT/p0/decode0/instruction
add wave -noupdate -format Literal -radix hexadecimal /proc_hier_pbench/DUT/p0/decode0/instruction_1
add wave -noupdate -format Logic -radix hexadecimal /proc_hier_pbench/DUT/p0/decode0/flop_stall
add wave -noupdate -format Literal -radix hexadecimal /proc_hier_pbench/DUT/p0/decode0/reg1_data
add wave -noupdate -format Literal -radix hexadecimal /proc_hier_pbench/DUT/p0/decode0/reg2_data
add wave -noupdate -format Literal -radix hexadecimal /proc_hier_pbench/DUT/p0/execute0/reg1_data
add wave -noupdate -format Literal -radix hexadecimal /proc_hier_pbench/DUT/p0/execute0/reg2_data
add wave -noupdate -divider {inserted signals}
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {1861 ns} 0}
WaveRestoreZoom {0 ns} {6931 ns}
configure wave -namecolwidth 408
configure wave -valuecolwidth 40
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
