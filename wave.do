onerror {resume}
quietly virtual signal -install /mem_ctrl_tb/INST_MEM_CTRL/RAM1 { (context /mem_ctrl_tb/INST_MEM_CTRL/RAM1 )(RAM(0) &RAM(1) &RAM(2) &RAM(3) &RAM(4) &RAM(5) &RAM(6) &RAM(7) &RAM(8) &RAM(9) &RAM(10) &RAM(11) &RAM(12) &RAM(13) &RAM(14) &RAM(15) &RAM(16) &RAM(17) )} RAMs
quietly WaveActivateNextPane {} 0
add wave -noupdate /mem_ctrl_tb/TB_W_ADDR
add wave -noupdate -radix binary /mem_ctrl_tb/TB_W_R
add wave -noupdate /mem_ctrl_tb/TB_W_CLK
add wave -noupdate /mem_ctrl_tb/TB_R_ADDR
add wave -noupdate -radix binary /mem_ctrl_tb/TB_R_R
add wave -noupdate /mem_ctrl_tb/TB_R_CLK
add wave -noupdate -group RAMs -radix binary -childformat {{/mem_ctrl_tb/INST_MEM_CTRL/RAM1/RAM(0)(2) -radix binary} {/mem_ctrl_tb/INST_MEM_CTRL/RAM1/RAM(0)(1) -radix binary} {/mem_ctrl_tb/INST_MEM_CTRL/RAM1/RAM(0)(0) -radix binary}} -subitemconfig {/mem_ctrl_tb/INST_MEM_CTRL/RAM1/RAM(0)(2) {-height 15 -radix binary} /mem_ctrl_tb/INST_MEM_CTRL/RAM1/RAM(0)(1) {-height 15 -radix binary} /mem_ctrl_tb/INST_MEM_CTRL/RAM1/RAM(0)(0) {-height 15 -radix binary}} /mem_ctrl_tb/INST_MEM_CTRL/RAM1/RAM(0)
add wave -noupdate -group RAMs -radix binary /mem_ctrl_tb/INST_MEM_CTRL/RAM1/RAM(1)
add wave -noupdate -group RAMs -radix binary /mem_ctrl_tb/INST_MEM_CTRL/RAM1/RAM(2)
add wave -noupdate -group RAMs -radix binary /mem_ctrl_tb/INST_MEM_CTRL/RAM1/RAM(3)
add wave -noupdate -group RAMs -radix binary /mem_ctrl_tb/INST_MEM_CTRL/RAM1/RAM(4)
add wave -noupdate -group RAMs -radix binary /mem_ctrl_tb/INST_MEM_CTRL/RAM1/RAM(5)
add wave -noupdate -group RAMs -radix binary /mem_ctrl_tb/INST_MEM_CTRL/RAM1/RAM(6)
add wave -noupdate -group RAMs -radix binary /mem_ctrl_tb/INST_MEM_CTRL/RAM1/RAM(7)
add wave -noupdate -group RAMs -radix binary /mem_ctrl_tb/INST_MEM_CTRL/RAM1/RAM(8)
add wave -noupdate -group RAMs -radix binary /mem_ctrl_tb/INST_MEM_CTRL/RAM1/RAM(9)
add wave -noupdate -group RAMs -radix binary /mem_ctrl_tb/INST_MEM_CTRL/RAM1/RAM(10)
add wave -noupdate -group RAMs -radix binary /mem_ctrl_tb/INST_MEM_CTRL/RAM1/RAM(11)
add wave -noupdate -group RAMs -radix binary /mem_ctrl_tb/INST_MEM_CTRL/RAM1/RAM(12)
add wave -noupdate -group RAMs -radix binary /mem_ctrl_tb/INST_MEM_CTRL/RAM1/RAM(13)
add wave -noupdate -group RAMs -radix binary /mem_ctrl_tb/INST_MEM_CTRL/RAM1/RAM(14)
add wave -noupdate -group RAMs -radix binary /mem_ctrl_tb/INST_MEM_CTRL/RAM1/RAM(15)
add wave -noupdate -group RAMs -radix binary /mem_ctrl_tb/INST_MEM_CTRL/RAM1/RAM(16)
add wave -noupdate -group RAMs -radix binary /mem_ctrl_tb/INST_MEM_CTRL/RAM1/RAM(17)
add wave -noupdate /mem_ctrl_tb/INST_MEM_CTRL/RAM1/W_ADDR
add wave -noupdate -radix binary /mem_ctrl_tb/INST_MEM_CTRL/RAM1/D_I
add wave -noupdate /mem_ctrl_tb/INST_MEM_CTRL/RAM1/W_CLK
add wave -noupdate /mem_ctrl_tb/INST_MEM_CTRL/RAM1/RAM(0)
add wave -noupdate /mem_ctrl_tb/INST_MEM_CTRL/RAM1/RAM(1)
add wave -noupdate /mem_ctrl_tb/INST_MEM_CTRL/RAM1/RAM(2)
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {7295 ns} 0}
quietly wave cursor active 1
configure wave -namecolwidth 300
configure wave -valuecolwidth 225
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
configure wave -timelineunits ns
update
WaveRestoreZoom {495 ns} {497 ns}
