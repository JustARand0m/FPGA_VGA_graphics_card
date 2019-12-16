onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /img_create_tb/TB_W_G
add wave -noupdate /img_create_tb/TB_W_ADDR
add wave -noupdate /img_create_tb/TB_W_CLK
add wave -noupdate /img_create_tb/TB_SYS_CLK
add wave -noupdate /img_create_tb/INST_IMG_Create/W_ADDR
add wave -noupdate /img_create_tb/INST_IMG_Create/CHAR0
add wave -noupdate /img_create_tb/INST_IMG_Create/ADDR
add wave -noupdate /img_create_tb/INST_IMG_Create/Count_Char_write
add wave -noupdate /img_create_tb/INST_IMG_Create/Count_Zeile_write
add wave -noupdate /img_create_tb/INST_IMG_Create/Count_Convert
add wave -noupdate /img_create_tb/INST_IMG_Create/Count_Convert2
add wave -noupdate /img_create_tb/INST_IMG_Create/Count_Char
add wave -noupdate /img_create_tb/INST_IMG_Create/Count_Zeile
add wave -noupdate /img_create_tb/INST_IMG_Create/Count_Clk
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {680000 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 267
configure wave -valuecolwidth 100
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
configure wave -timelineunits ps
update
WaveRestoreZoom {0 ps} {777916 ps}
