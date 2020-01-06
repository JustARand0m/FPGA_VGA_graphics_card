onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /integration_tb/TB_BLANK
add wave -noupdate /integration_tb/TB_R_R
add wave -noupdate /integration_tb/TB_R_G
add wave -noupdate /integration_tb/TB_R_B
add wave -noupdate -radix decimal /integration_tb/TB_R_ADDR
add wave -noupdate /integration_tb/TB_R_CLK
add wave -noupdate /integration_tb/TB_SYNC
add wave -noupdate /integration_tb/TB_W_R
add wave -noupdate /integration_tb/TB_W_G
add wave -noupdate /integration_tb/TB_W_B
add wave -noupdate -radix decimal /integration_tb/TB_W_ADDR
add wave -noupdate /integration_tb/TB_W_CLK
add wave -noupdate /integration_tb/TB_RESET
add wave -noupdate /integration_tb/TB_W_EN
add wave -noupdate /integration_tb/TB_FRAME_COUNTER
add wave -noupdate /integration_tb/TB_HS
add wave -noupdate /integration_tb/TB_VS
add wave -noupdate /integration_tb/TB_C_H
add wave -noupdate /integration_tb/TB_C_V
add wave -noupdate /integration_tb/MAX_ADDR
add wave -noupdate /integration_tb/ISNT_IMG_CREATE/DATA_Input
add wave -noupdate -radix decimal /integration_tb/ISNT_IMG_CREATE/ADDR
add wave -noupdate -radix decimal /integration_tb/ISNT_IMG_CREATE/COUNT_Sek
add wave -noupdate -radix decimal /integration_tb/ISNT_IMG_CREATE/W_ADDR
add wave -noupdate /integration_tb/ISNT_IMG_CREATE/W_R
add wave -noupdate /integration_tb/ISNT_IMG_CREATE/W_EN
add wave -noupdate /integration_tb/ISNT_IMG_CREATE/Count_Zeile_write
add wave -noupdate /integration_tb/ISNT_IMG_CREATE/Count_Char_write
add wave -noupdate /integration_tb/ISNT_IMG_CREATE/COUNT_Write_cycle
add wave -noupdate /integration_tb/INST_MEM_CTRL/RAM1/RAM(41256)
add wave -noupdate /integration_tb/INST_MEM_CTRL/RAM1/RAM(41257)
add wave -noupdate /integration_tb/INST_MEM_CTRL/RAM1/RAM(41258)
add wave -noupdate /integration_tb/INST_MEM_CTRL/RAM1/RAM(41259)
add wave -noupdate /integration_tb/INST_MEM_CTRL/RAM1/RAM(41260)
add wave -noupdate /integration_tb/INST_MEM_CTRL/RAM1/RAM(41261)
add wave -noupdate /integration_tb/INST_MEM_CTRL/RAM1/RAM(41262)
add wave -noupdate /integration_tb/INST_MEM_CTRL/RAM1/RAM(41263)
add wave -noupdate /integration_tb/INST_MEM_CTRL/RAM1/RAM(41264)
add wave -noupdate /integration_tb/INST_MEM_CTRL/RAM1/RAM(41265)
add wave -noupdate /integration_tb/INST_MEM_CTRL/RAM1/RAM(41266)
add wave -noupdate /integration_tb/INST_MEM_CTRL/RAM1/RAM(41267)
add wave -noupdate /integration_tb/INST_MEM_CTRL/RAM1/RAM(41268)
add wave -noupdate /integration_tb/INST_MEM_CTRL/RAM1/RAM(41269)
add wave -noupdate /integration_tb/INST_MEM_CTRL/RAM1/RAM(41270)
add wave -noupdate /integration_tb/INST_MEM_CTRL/RAM1/RAM(41271)
add wave -noupdate /integration_tb/INST_MEM_CTRL/RAM1/RAM(41272)
add wave -noupdate /integration_tb/INST_MEM_CTRL/RAM1/RAM(41273)
add wave -noupdate /integration_tb/INST_MEM_CTRL/RAM1/RAM(41274)
add wave -noupdate /integration_tb/INST_MEM_CTRL/RAM1/RAM(41275)
add wave -noupdate /integration_tb/INST_MEM_CTRL/RAM1/RAM(41276)
add wave -noupdate /integration_tb/INST_MEM_CTRL/RAM1/RAM(41277)
add wave -noupdate /integration_tb/INST_MEM_CTRL/RAM1/RAM(41278)
add wave -noupdate /integration_tb/INST_MEM_CTRL/RAM1/RAM(41279)
add wave -noupdate /integration_tb/INST_MEM_CTRL/RAM1/RAM(41280)
add wave -noupdate /integration_tb/INST_MEM_CTRL/RAM1/RAM(41281)
add wave -noupdate /integration_tb/INST_MEM_CTRL/RAM1/RAM(41282)
add wave -noupdate /integration_tb/INST_MEM_CTRL/RAM1/RAM(41283)
add wave -noupdate /integration_tb/INST_MEM_CTRL/RAM1/RAM(41284)
add wave -noupdate /integration_tb/INST_MEM_CTRL/RAM1/RAM(41285)
add wave -noupdate /integration_tb/INST_MEM_CTRL/RAM1/RAM(41286)
add wave -noupdate /integration_tb/INST_MEM_CTRL/RAM1/RAM(41287)
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {3637 ns} 0}
quietly wave cursor active 1
configure wave -namecolwidth 341
configure wave -valuecolwidth 82
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
WaveRestoreZoom {0 ns} {35 ns}
