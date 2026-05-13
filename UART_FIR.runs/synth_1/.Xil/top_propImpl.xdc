set_property SRC_FILE_INFO {cfile:C:/FPGA/UART_FIR/UART_FIR/UART_FIR.srcs/constrs_1/imports/UART_FIR/Nexys-Video-Master.xdc rfile:../../../UART_FIR.srcs/constrs_1/imports/UART_FIR/Nexys-Video-Master.xdc id:1} [current_design]
set_property src_info {type:XDC file:1 line:8 export:INPUT save:INPUT read:READ} [current_design]
set_property -dict { PACKAGE_PIN R4    IOSTANDARD LVCMOS33 } [get_ports { i_clk }]; #IO_L13P_T2_MRCC_34 Sch=sysclk
set_property src_info {type:XDC file:1 line:38 export:INPUT save:INPUT read:READ} [current_design]
set_property -dict { PACKAGE_PIN G4  IOSTANDARD LVCMOS15 } [get_ports { i_resetn }]; #IO_L12N_T1_MRCC_35 Sch=cpu_resetn
set_property src_info {type:XDC file:1 line:154 export:INPUT save:INPUT read:READ} [current_design]
set_property -dict { PACKAGE_PIN AA19  IOSTANDARD LVCMOS33 } [get_ports { uart_tx_out }]; #IO_L15P_T2_DQS_RDWR_B_14 Sch=uart_rx_out
set_property src_info {type:XDC file:1 line:156 export:INPUT save:INPUT read:READ} [current_design]
set_property -dict { PACKAGE_PIN V18   IOSTANDARD LVCMOS33 } [get_ports { uart_rx_in }]; #IO_L14P_T2_SRCC_14 Sch=uart_tx_in
