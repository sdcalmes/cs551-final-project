onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -format Logic /proc_hier_pbench/DUT/p0/clk
add wave -noupdate -format Logic /proc_hier_pbench/DUT/p0/icache_done
add wave -noupdate -format Logic /proc_hier_pbench/DUT/p0/icache_stall
add wave -noupdate -format Logic /proc_hier_pbench/DUT/p0/icache_hit
add wave -noupdate -format Literal -radix hexadecimal /proc_hier_pbench/DUT/p0/if_pc_plus
add wave -noupdate -format Literal -radix hexadecimal /proc_hier_pbench/DUT/p0/if_instruction
add wave -noupdate -format Logic /proc_hier_pbench/DUT/p0/id_regWrite
add wave -noupdate -format Literal -radix hexadecimal /proc_hier_pbench/DUT/p0/id_write_reg
add wave -noupdate -format Literal -radix hexadecimal /proc_hier_pbench/DUT/p0/id_instruction_w
add wave -noupdate -format Literal -radix hexadecimal /proc_hier_pbench/DUT/p0/id_pc_plus
add wave -noupdate -format Logic /proc_hier_pbench/DUT/p0/ex_regWrite
add wave -noupdate -format Literal -radix hexadecimal /proc_hier_pbench/DUT/p0/ex_write_reg
add wave -noupdate -format Literal -radix hexadecimal /proc_hier_pbench/DUT/p0/ex_instruction
add wave -noupdate -format Literal -radix hexadecimal /proc_hier_pbench/DUT/p0/ex_pc_plus
add wave -noupdate -format Logic /proc_hier_pbench/DUT/p0/mem_regWrite
add wave -noupdate -format Literal -radix hexadecimal /proc_hier_pbench/DUT/p0/mem_write_reg
add wave -noupdate -format Logic /proc_hier_pbench/DUT/p0/wb_regWrite
add wave -noupdate -format Literal -radix hexadecimal /proc_hier_pbench/DUT/p0/wb_write_reg
add wave -noupdate -format Literal -radix hexadecimal /proc_hier_pbench/DUT/p0/wb_pc_plus
add wave -noupdate -format Logic /proc_hier_pbench/DUT/p0/flop_stall
add wave -noupdate -format Logic /proc_hier_pbench/DUT/p0/wb_halt
add wave -noupdate -format Logic /proc_hier_pbench/DUT/p0/decode0/wb_regWrite
add wave -noupdate -format Logic /proc_hier_pbench/DUT/p0/decode0/clk
add wave -noupdate -format Logic /proc_hier_pbench/DUT/p0/decode0/rst
add wave -noupdate -divider {decode block}
add wave -noupdate -format Logic /proc_hier_pbench/DUT/p0/decode0/wb_regWrite
add wave -noupdate -format Literal -radix hexadecimal /proc_hier_pbench/DUT/p0/decode0/wb_write_reg
add wave -noupdate -format Literal -radix hexadecimal /proc_hier_pbench/DUT/p0/decode0/mem_write_back
add wave -noupdate -format Literal -radix hexadecimal /proc_hier_pbench/DUT/p0/decode0/instruction
add wave -noupdate -format Literal /proc_hier_pbench/DUT/p0/decode0/instruction_1
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {3566 ns} 0}
WaveRestoreZoom {0 ns} {6931 ns}
configure wave -namecolwidth 391
configure wave -valuecolwidth 43
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
