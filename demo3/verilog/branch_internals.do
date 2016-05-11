onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -format Logic /proc_hier_pbench/DUT/c0/clk
add wave -noupdate -format Literal /proc_hier_pbench/DUT/c0/cycle_count
add wave -noupdate -format Logic -radix hexadecimal /proc_hier_pbench/DUT/p0/execute0/branch
add wave -noupdate -format Logic -radix hexadecimal /proc_hier_pbench/DUT/p0/execute0/branch_eqz
add wave -noupdate -format Logic -radix hexadecimal /proc_hier_pbench/DUT/p0/execute0/alu_z
add wave -noupdate -format Literal -radix hexadecimal /proc_hier_pbench/DUT/p0/execute0/branch_address
add wave -noupdate -format Literal -radix hexadecimal /proc_hier_pbench/DUT/p0/execute0/alu_result
add wave -noupdate -format Literal -radix hexadecimal /proc_hier_pbench/DUT/p0/execute0/alu_b_input
add wave -noupdate -format Literal -radix hexadecimal /proc_hier_pbench/DUT/p0/execute0/alu_a_input
add wave -noupdate -format Literal -radix hexadecimal /proc_hier_pbench/DUT/p0/execute0/pc_decision
add wave -noupdate -format Literal -radix hexadecimal /proc_hier_pbench/DUT/p0/execute0/alu_out
add wave -noupdate -format Literal -radix hexadecimal /proc_hier_pbench/DUT/p0/execute0/pc_dec
add wave -noupdate -format Literal -radix hexadecimal /proc_hier_pbench/DUT/p0/execute0/pc_plus
add wave -noupdate -format Literal -radix hexadecimal /proc_hier_pbench/DUT/p0/execute0/instruction
add wave -noupdate -format Logic /proc_hier_pbench/DUT/p0/flop_stall
add wave -noupdate -divider {New signals}
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {6466 ns} 0}
WaveRestoreZoom {0 ns} {8716 ns}
configure wave -namecolwidth 364
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
