onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /img_create_tb/INST_IMG_Create/W_R
add wave -noupdate /img_create_tb/INST_IMG_Create/W_G
add wave -noupdate /img_create_tb/INST_IMG_Create/W_B
add wave -noupdate /img_create_tb/INST_IMG_Create/W_ADDR
add wave -noupdate /img_create_tb/INST_IMG_Create/SYNC
add wave -noupdate /img_create_tb/INST_IMG_Create/W_CLK
add wave -noupdate /img_create_tb/INST_IMG_Create/SYS_CLK
add wave -noupdate /img_create_tb/INST_IMG_Create/RESET
add wave -noupdate /img_create_tb/INST_IMG_Create/W_EN
add wave -noupdate /img_create_tb/INST_IMG_Create/RST_GLOBAL
add wave -noupdate /img_create_tb/INST_IMG_Create/CHAR0
add wave -noupdate /img_create_tb/INST_IMG_Create/CHAR1
add wave -noupdate /img_create_tb/INST_IMG_Create/CHAR2
add wave -noupdate /img_create_tb/INST_IMG_Create/CHAR3
add wave -noupdate /img_create_tb/INST_IMG_Create/CHAR4
add wave -noupdate /img_create_tb/INST_IMG_Create/CHAR5
add wave -noupdate /img_create_tb/INST_IMG_Create/CHAR6
add wave -noupdate /img_create_tb/INST_IMG_Create/CHAR7
add wave -noupdate /img_create_tb/INST_IMG_Create/Count_Char
add wave -noupdate /img_create_tb/INST_IMG_Create/Count_Zeile
add wave -noupdate /img_create_tb/INST_IMG_Create/Count_Clk
add wave -noupdate /img_create_tb/INST_IMG_Create/Count_Convert
add wave -noupdate /img_create_tb/INST_IMG_Create/Count_Convert2
add wave -noupdate /img_create_tb/INST_IMG_Create/Count_Zeile_write
add wave -noupdate /img_create_tb/INST_IMG_Create/Count_Char_write
add wave -noupdate /img_create_tb/INST_IMG_Create/Enable
add wave -noupdate /img_create_tb/INST_IMG_Create/DATA_Input
add wave -noupdate /img_create_tb/INST_IMG_Create/ADDR
add wave -noupdate /img_create_tb/INST_IMG_Create/INST_charmaps_ROM/i_clock
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {480000 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 301
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
WaveRestoreZoom {0 ps} {983416 ps}
