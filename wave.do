onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /mem_ctrl_tb/INST_MEM_CTRL/FRONT_BUFFER
add wave -noupdate /mem_ctrl_tb/INST_MEM_CTRL/BACK_BUFFER_RDY
add wave -noupdate /mem_ctrl_tb/INST_MEM_CTRL/BACK_BUFFER_BSY
add wave -noupdate -expand -group RAM1 /mem_ctrl_tb/INST_MEM_CTRL/RAM1(0)(0)
add wave -noupdate -expand -group RAM1 /mem_ctrl_tb/INST_MEM_CTRL/RAM1(0)(1)
add wave -noupdate -expand -group RAM1 /mem_ctrl_tb/INST_MEM_CTRL/RAM1(1)(0)
add wave -noupdate -expand -group RAM1 /mem_ctrl_tb/INST_MEM_CTRL/RAM1(1)(1)
add wave -noupdate -group RAM2 /mem_ctrl_tb/INST_MEM_CTRL/RAM2(0)(0)
add wave -noupdate -group RAM2 /mem_ctrl_tb/INST_MEM_CTRL/RAM2(0)(1)
add wave -noupdate -group RAM2 /mem_ctrl_tb/INST_MEM_CTRL/RAM2(1)(0)
add wave -noupdate -group RAM2 /mem_ctrl_tb/INST_MEM_CTRL/RAM2(1)(1)
add wave -noupdate -group RAM3 /mem_ctrl_tb/INST_MEM_CTRL/RAM3(0)(0)
add wave -noupdate -group RAM3 /mem_ctrl_tb/INST_MEM_CTRL/RAM3(0)(1)
add wave -noupdate -group RAM3 /mem_ctrl_tb/INST_MEM_CTRL/RAM3(1)(0)
add wave -noupdate -group RAM3 /mem_ctrl_tb/INST_MEM_CTRL/RAM3(1)(1)
add wave -noupdate /mem_ctrl_tb/INST_MEM_CTRL/R_ADDR
add wave -noupdate /mem_ctrl_tb/INST_MEM_CTRL/W_ADDR
add wave -noupdate /mem_ctrl_tb/INST_MEM_CTRL/R_CLK
add wave -noupdate /mem_ctrl_tb/INST_MEM_CTRL/SYNC
add wave -noupdate /mem_ctrl_tb/TB_BLANK
add wave -noupdate /mem_ctrl_tb/INST_MEM_CTRL/W_CLK
add wave -noupdate /mem_ctrl_tb/INST_MEM_CTRL/W_R
add wave -noupdate /mem_ctrl_tb/INST_MEM_CTRL/R_R
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {0 ns} 0}
quietly wave cursor active 1
configure wave -namecolwidth 377
configure wave -valuecolwidth 74
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 20
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ns
update
WaveRestoreZoom {0 ns} {19 ns}
