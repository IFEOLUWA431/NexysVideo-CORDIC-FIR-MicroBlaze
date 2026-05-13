// Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// Copyright 2022-2025 Advanced Micro Devices, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2025.1 (win64) Build 6140274 Thu May 22 00:12:29 MDT 2025
// Date        : Thu Nov 20 10:24:10 2025
// Host        : IC-5CG4104D9F running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode funcsim
//               c:/FPGA/UART_FIR/UART_FIR/UART_FIR.gen/sources_1/bd/sub_system/ip/sub_system_axi_bram_ctrl_0_bram_1/sub_system_axi_bram_ctrl_0_bram_1_sim_netlist.v
// Design      : sub_system_axi_bram_ctrl_0_bram_1
// Purpose     : This verilog netlist is a functional simulation representation of the design and should not be modified
//               or synthesized. This netlist cannot be used for SDF annotated simulation.
// Device      : xc7a200tsbg484-1
// --------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

(* CHECK_LICENSE_TYPE = "sub_system_axi_bram_ctrl_0_bram_1,blk_mem_gen_v8_4_11,{}" *) (* downgradeipidentifiedwarnings = "yes" *) (* x_core_info = "blk_mem_gen_v8_4_11,Vivado 2025.1" *) 
(* NotValidForBitStream *)
module sub_system_axi_bram_ctrl_0_bram_1
   (clka,
    rsta,
    ena,
    wea,
    addra,
    dina,
    douta,
    clkb,
    rstb,
    enb,
    web,
    addrb,
    dinb,
    doutb,
    rsta_busy,
    rstb_busy);
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTA CLK" *) (* x_interface_mode = "slave BRAM_PORTA" *) (* x_interface_parameter = "XIL_INTERFACENAME BRAM_PORTA, MEM_ADDRESS_MODE BYTE_ADDRESS, MEM_SIZE 8192, MEM_WIDTH 32, MEM_ECC NONE, MASTER_TYPE BRAM_CTRL, READ_WRITE_MODE READ_WRITE, READ_LATENCY 1" *) input clka;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTA RST" *) input rsta;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTA EN" *) input ena;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTA WE" *) input [3:0]wea;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTA ADDR" *) input [31:0]addra;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTA DIN" *) input [31:0]dina;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTA DOUT" *) output [31:0]douta;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTB CLK" *) (* x_interface_mode = "slave BRAM_PORTB" *) (* x_interface_parameter = "XIL_INTERFACENAME BRAM_PORTB, MEM_ADDRESS_MODE BYTE_ADDRESS, MEM_SIZE 8192, MEM_WIDTH 32, MEM_ECC NONE, MASTER_TYPE BRAM_CTRL, READ_WRITE_MODE READ_WRITE, READ_LATENCY 1" *) input clkb;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTB RST" *) input rstb;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTB EN" *) input enb;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTB WE" *) input [3:0]web;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTB ADDR" *) input [31:0]addrb;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTB DIN" *) input [31:0]dinb;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTB DOUT" *) output [31:0]doutb;
  output rsta_busy;
  output rstb_busy;

  wire [31:0]addra;
  wire [31:0]addrb;
  wire clka;
  wire clkb;
  wire [31:0]dina;
  wire [31:0]dinb;
  wire [31:0]douta;
  wire [31:0]doutb;
  wire ena;
  wire enb;
  wire rsta;
  wire rsta_busy;
  wire rstb;
  wire rstb_busy;
  wire [3:0]wea;
  wire [3:0]web;
  wire NLW_U0_dbiterr_UNCONNECTED;
  wire NLW_U0_s_axi_arready_UNCONNECTED;
  wire NLW_U0_s_axi_awready_UNCONNECTED;
  wire NLW_U0_s_axi_bvalid_UNCONNECTED;
  wire NLW_U0_s_axi_dbiterr_UNCONNECTED;
  wire NLW_U0_s_axi_rlast_UNCONNECTED;
  wire NLW_U0_s_axi_rvalid_UNCONNECTED;
  wire NLW_U0_s_axi_sbiterr_UNCONNECTED;
  wire NLW_U0_s_axi_wready_UNCONNECTED;
  wire NLW_U0_sbiterr_UNCONNECTED;
  wire [31:0]NLW_U0_rdaddrecc_UNCONNECTED;
  wire [3:0]NLW_U0_s_axi_bid_UNCONNECTED;
  wire [1:0]NLW_U0_s_axi_bresp_UNCONNECTED;
  wire [31:0]NLW_U0_s_axi_rdaddrecc_UNCONNECTED;
  wire [31:0]NLW_U0_s_axi_rdata_UNCONNECTED;
  wire [3:0]NLW_U0_s_axi_rid_UNCONNECTED;
  wire [1:0]NLW_U0_s_axi_rresp_UNCONNECTED;

  (* C_ADDRA_WIDTH = "32" *) 
  (* C_ADDRB_WIDTH = "32" *) 
  (* C_ALGORITHM = "1" *) 
  (* C_AXI_ID_WIDTH = "4" *) 
  (* C_AXI_SLAVE_TYPE = "0" *) 
  (* C_AXI_TYPE = "1" *) 
  (* C_BYTE_SIZE = "8" *) 
  (* C_COMMON_CLK = "0" *) 
  (* C_COUNT_18K_BRAM = "0" *) 
  (* C_COUNT_36K_BRAM = "2" *) 
  (* C_CTRL_ECC_ALGO = "NONE" *) 
  (* C_DEFAULT_DATA = "0" *) 
  (* C_DISABLE_WARN_BHV_COLL = "0" *) 
  (* C_DISABLE_WARN_BHV_RANGE = "0" *) 
  (* C_ELABORATION_DIR = "./" *) 
  (* C_ENABLE_32BIT_ADDRESS = "1" *) 
  (* C_EN_DEEPSLEEP_PIN = "0" *) 
  (* C_EN_ECC_PIPE = "0" *) 
  (* C_EN_RDADDRA_CHG = "0" *) 
  (* C_EN_RDADDRB_CHG = "0" *) 
  (* C_EN_SAFETY_CKT = "1" *) 
  (* C_EN_SHUTDOWN_PIN = "0" *) 
  (* C_EN_SLEEP_PIN = "0" *) 
  (* C_EST_POWER_SUMMARY = "Estimated Power for IP     :     10.7492 mW" *) 
  (* C_FAMILY = "artix7" *) 
  (* C_HAS_AXI_ID = "0" *) 
  (* C_HAS_ENA = "1" *) 
  (* C_HAS_ENB = "1" *) 
  (* C_HAS_INJECTERR = "0" *) 
  (* C_HAS_MEM_OUTPUT_REGS_A = "0" *) 
  (* C_HAS_MEM_OUTPUT_REGS_B = "0" *) 
  (* C_HAS_MUX_OUTPUT_REGS_A = "0" *) 
  (* C_HAS_MUX_OUTPUT_REGS_B = "0" *) 
  (* C_HAS_REGCEA = "0" *) 
  (* C_HAS_REGCEB = "0" *) 
  (* C_HAS_RSTA = "1" *) 
  (* C_HAS_RSTB = "1" *) 
  (* C_HAS_SOFTECC_INPUT_REGS_A = "0" *) 
  (* C_HAS_SOFTECC_OUTPUT_REGS_B = "0" *) 
  (* C_INITA_VAL = "0" *) 
  (* C_INITB_VAL = "0" *) 
  (* C_INIT_FILE = "sub_system_axi_bram_ctrl_0_bram_1.mem" *) 
  (* C_INIT_FILE_NAME = "no_coe_file_loaded" *) 
  (* C_INTERFACE_TYPE = "0" *) 
  (* C_LOAD_INIT_FILE = "0" *) 
  (* C_MEM_TYPE = "2" *) 
  (* C_MUX_PIPELINE_STAGES = "0" *) 
  (* C_PRIM_TYPE = "1" *) 
  (* C_READ_DEPTH_A = "2048" *) 
  (* C_READ_DEPTH_B = "2048" *) 
  (* C_READ_LATENCY_A = "1" *) 
  (* C_READ_LATENCY_B = "1" *) 
  (* C_READ_WIDTH_A = "32" *) 
  (* C_READ_WIDTH_B = "32" *) 
  (* C_RSTRAM_A = "0" *) 
  (* C_RSTRAM_B = "0" *) 
  (* C_RST_PRIORITY_A = "CE" *) 
  (* C_RST_PRIORITY_B = "CE" *) 
  (* C_SIM_COLLISION_CHECK = "ALL" *) 
  (* C_USE_BRAM_BLOCK = "1" *) 
  (* C_USE_BYTE_WEA = "1" *) 
  (* C_USE_BYTE_WEB = "1" *) 
  (* C_USE_DEFAULT_DATA = "0" *) 
  (* C_USE_ECC = "0" *) 
  (* C_USE_SOFTECC = "0" *) 
  (* C_USE_URAM = "0" *) 
  (* C_WEA_WIDTH = "4" *) 
  (* C_WEB_WIDTH = "4" *) 
  (* C_WRITE_DEPTH_A = "2048" *) 
  (* C_WRITE_DEPTH_B = "2048" *) 
  (* C_WRITE_MODE_A = "WRITE_FIRST" *) 
  (* C_WRITE_MODE_B = "WRITE_FIRST" *) 
  (* C_WRITE_WIDTH_A = "32" *) 
  (* C_WRITE_WIDTH_B = "32" *) 
  (* C_XDEVICEFAMILY = "artix7" *) 
  (* downgradeipidentifiedwarnings = "yes" *) 
  (* is_du_within_envelope = "true" *) 
  sub_system_axi_bram_ctrl_0_bram_1_blk_mem_gen_v8_4_11 U0
       (.addra({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,addra[12:2],1'b0,1'b0}),
        .addrb({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,addrb[12:2],1'b0,1'b0}),
        .clka(clka),
        .clkb(clkb),
        .dbiterr(NLW_U0_dbiterr_UNCONNECTED),
        .deepsleep(1'b0),
        .dina(dina),
        .dinb(dinb),
        .douta(douta),
        .doutb(doutb),
        .eccpipece(1'b0),
        .ena(ena),
        .enb(enb),
        .injectdbiterr(1'b0),
        .injectsbiterr(1'b0),
        .rdaddrecc(NLW_U0_rdaddrecc_UNCONNECTED[31:0]),
        .regcea(1'b1),
        .regceb(1'b1),
        .rsta(rsta),
        .rsta_busy(rsta_busy),
        .rstb(rstb),
        .rstb_busy(rstb_busy),
        .s_aclk(1'b0),
        .s_aresetn(1'b0),
        .s_axi_araddr({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .s_axi_arburst({1'b0,1'b0}),
        .s_axi_arid({1'b0,1'b0,1'b0,1'b0}),
        .s_axi_arlen({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .s_axi_arready(NLW_U0_s_axi_arready_UNCONNECTED),
        .s_axi_arsize({1'b0,1'b0,1'b0}),
        .s_axi_arvalid(1'b0),
        .s_axi_awaddr({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .s_axi_awburst({1'b0,1'b0}),
        .s_axi_awid({1'b0,1'b0,1'b0,1'b0}),
        .s_axi_awlen({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .s_axi_awready(NLW_U0_s_axi_awready_UNCONNECTED),
        .s_axi_awsize({1'b0,1'b0,1'b0}),
        .s_axi_awvalid(1'b0),
        .s_axi_bid(NLW_U0_s_axi_bid_UNCONNECTED[3:0]),
        .s_axi_bready(1'b0),
        .s_axi_bresp(NLW_U0_s_axi_bresp_UNCONNECTED[1:0]),
        .s_axi_bvalid(NLW_U0_s_axi_bvalid_UNCONNECTED),
        .s_axi_dbiterr(NLW_U0_s_axi_dbiterr_UNCONNECTED),
        .s_axi_injectdbiterr(1'b0),
        .s_axi_injectsbiterr(1'b0),
        .s_axi_rdaddrecc(NLW_U0_s_axi_rdaddrecc_UNCONNECTED[31:0]),
        .s_axi_rdata(NLW_U0_s_axi_rdata_UNCONNECTED[31:0]),
        .s_axi_rid(NLW_U0_s_axi_rid_UNCONNECTED[3:0]),
        .s_axi_rlast(NLW_U0_s_axi_rlast_UNCONNECTED),
        .s_axi_rready(1'b0),
        .s_axi_rresp(NLW_U0_s_axi_rresp_UNCONNECTED[1:0]),
        .s_axi_rvalid(NLW_U0_s_axi_rvalid_UNCONNECTED),
        .s_axi_sbiterr(NLW_U0_s_axi_sbiterr_UNCONNECTED),
        .s_axi_wdata({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .s_axi_wlast(1'b0),
        .s_axi_wready(NLW_U0_s_axi_wready_UNCONNECTED),
        .s_axi_wstrb({1'b0,1'b0,1'b0,1'b0}),
        .s_axi_wvalid(1'b0),
        .sbiterr(NLW_U0_sbiterr_UNCONNECTED),
        .shutdown(1'b0),
        .sleep(1'b0),
        .wea(wea),
        .web(web));
endmodule
`pragma protect begin_protected
`pragma protect version = 1
`pragma protect encrypt_agent = "XILINX"
`pragma protect encrypt_agent_info = "Xilinx Encryption Tool 2025.1"
`pragma protect key_keyowner="Synopsys", key_keyname="SNPS-VCS-RSA-2", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=128)
`pragma protect key_block
gydSV72FvW4hnoyUt6yZFJHfJqjRQWPUfYIuDKP0fpjrPOkLRbJGBr4Z9msYTvoIHRlYtXJ2YMY0
d1TIQb+FK4gKsTRru9wr397OxuFBsTRf4e+ZjpYZEdsnqYWcgMSzhN4yhPvO06GyZO15y/LKBxa8
3OKwxVlOLYXhv+sxdXg=

`pragma protect key_keyowner="Aldec", key_keyname="ALDEC15_001", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
WHB6Zbfa5Qi47krP9T4L8UnPOlr881dWx7UcYaZfNGIQQM0gadcoXbhucIpRaUuyOKxv6yhKveRN
h0l+N9+KX6rbZ6+TRhP9JAMuPhlpI7T42QtRv5zx9+m3ct5S0NMszbFaK8zeTAYra5BGP7BHmtkr
MpKfLK5sFyaTE/A7ACtAace9MwFTHDZdl9uUs4aY6KJlm6GaypKduiqkNugukJp5vlFPX/ZapJqG
KMtMhI6grhcuYb1FJrwRZ4jW7hs9HxddSdGLzsZ0HsBcO/qaCPTst+ZA0YIQfd5ULlFmPqq39FfO
p1P+2hEH2n+LycbMj5cn4Dxfqv2R8eucM78R3w==

`pragma protect key_keyowner="Mentor Graphics Corporation", key_keyname="MGC-VELOCE-RSA", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=128)
`pragma protect key_block
SmAzQA1VEuJXtJi5vXa2Jg7YvRqAJs6PX9HTZ1YqrJw4VfonBW3726gJ81BjlizpMkcf/Uk5sFIK
aPedVhEs4xCIZylz7gXYDshtytOA/pXUID2qV9nXr8qfI+FydSADUF3ScYDZmlkclFqlZrGq6DQ7
da3lJAzt2h/iR+cczrA=

`pragma protect key_keyowner="Mentor Graphics Corporation", key_keyname="MGC-VERIF-SIM-RSA-2", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
iAph5JWb/chMQpLPX1UoLjQDxN5l2I8McM/k2xN5wRht7HXoE6F5yV8luDjn3zkI6vnfUYo7BaI1
mogRRx+R3XcwxvhHr+lngh4+/YLVex1TFncl+kiUMAsu3M/FjFSiqGMVMdKTNLDqr35DuZJVyuiF
lTwXob/KkbQDJiJjBEoxbt+968rKRKRyJGcqIjm4mqRBdqMcgo3HOJFG74SFsWAQrxvXfBhdLSG3
OfoLfls9XDojBjp7G83k0h82g1eeWgBfydm/OcX9o48Pst93NvI4ua8WShZL8MCvRWYqWZrrjrWi
cfUjXAF5SDACjq1/OU6arz/Idz6/a7AP/jmexw==

`pragma protect key_keyowner="Real Intent", key_keyname="RI-RSA-KEY-1", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
BY49GZBxBT/gjZDPyaSWlti/sctckoR7jK6NuWdhnF9tiyNfVU7BqjjwxSnyMi0Uucv1BKHXC18h
8hQbFWnNtrq71ilURotXux7sssHlVJ2i1CsJWU18DOcBWxm2ai89uwvxDJh3TJkBJixB5KPvsDhL
lWOjTvZWPoR+Ixy+Tzo+U5Vx7z7SOakRwTrn3u7+c3vmCEBphE+HKeJExhBAoOEd0SXK5iwXaByW
D7Wb7zq6NNUmnCyaJ2BG9kGxLVsf+md7SlocuaFsYyaRZhwPyTucxIlz1tLYwcytKzx0ovoax3no
nYgzlzP/F0/PDWk9BqXgr/tuclc4EZYX0cf4ng==

`pragma protect key_keyowner="Xilinx", key_keyname="xilinxt_2025.1-2029.x", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
qGnCvL35qO7cbUEKCL50yDv1UvezcqBz601zctKop1954QlcjemzZWZHg1zJ00nJaToNdH2S8AKX
n8hNJvbQ+x5HEGL5DoSU9m5qjXd8xxocnZ0yzuZX/dGCT8kDn3gWJR2Gz13pT+w2LQUno1fX+MsC
ehgwvjBBT6GeYjdxHi+aybQUP9AblSxX/z3vh857SGCPohEWvghOgORCHAe45YD+ZWnL62FLxMM2
c+Ozq/Au/Q4q1Yzlzcfv8Mnsvg7OqOeEamQHbuYOfdkJUuYqOwsskEWW348u7FXtsf8m7P3pZyyz
IWyTDAW4igGguMPLHfbtK/twZx8ScJQmOKzglg==

`pragma protect key_keyowner="Metrics Technologies Inc.", key_keyname="DSim", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
Hz+6K8+wh5/fukU4ZWNDXGsq6hreSVCSPP67nA6kUz9Vpjy4TtTnOrrl1BWY0ivEC7Ldyw8VI60A
VO/WPlt409LdAZdMZGsEZ1JuTZ0m9LPcgu9CPCyoMECctmd8LHE+otY6etTmYABB9syY61rk2hrv
RgbcyT/HCK9TzWxSm+XMqvx2nvagCLkMDPh/JZv51fj2zcKaBPnxsz8rnDipaeo0fEyVRC3Y1F/V
U3RmXojBjIumPHSJkQ537dENJEIA0Ra65u8EM/+ItUn1bcryLcIbKy1xGadrHmHdHRUoRcAodO2C
B48bNVeL0VnGg8P9ACIB04lMNzn5p6A1tPOb4Q==

`pragma protect key_keyowner="Atrenta", key_keyname="ATR-SG-RSA-1", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=384)
`pragma protect key_block
YDpb+UeT0rJ543Q8wCo2xSS3gpVAT+JoStgBlV5IMjJoUOWkiOPn691FGChmDi3BTq5NxC73KHHR
1galACCjeTGq6cv+0Zc2Ocm1oobdrnSPHp7TMDr5Zle8FX6WywJCiGdoWBODggZSlbOASIK/PVfY
cZM2z60M6RSvzsi3TnYHiKYHpju8THVoSgRd6r31GcbiSy9TjjARERXan0OVc79jGuAg90mmDEEq
91eqmn6NZ9yLI2fgBjFUZbtFCpmJ8WGxOL1h39niWnRK3ZXnk8jcpnZUlxLbYTPO0Z3vVr1zrvcn
RVQloU0OLqg7M95zSs7NtX5Vzvb6jGbMehWV+WMMyxWmxL2XOwsAwPSeX2dI2r77pioY7X6VzH7f
/JxMAnq9udra3WGPsUkD1G0CvPkCC3zdxjpVaflY37ztX9UONhKtzMQa8lJc1IL8GhXRY3R9Lg2c
HIeXSGkpNNuFDqKT6Khe/6Casq+SjFJq+IH9IUtz6RUZTkbFb0Xhgm2P

`pragma protect key_keyowner="Cadence Design Systems.", key_keyname="CDS_RSA_KEY_VER_1", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
Q+63zFEYw/LeMgxa7g8g79GGvSyIKDKD8RvvC4DHDQuGObf6n9OGZX4e17v/E/+EDEwUhsWQHFDI
Lp/aH+6fNRmhu9BEWVjxq2WRrQSl4eQjfIaSOXu2dlYh3JjRJwiUp4LteVh8RFAf5t5sRQO4dRIK
x+h28yliSgibaWEAv5FaJQ1EFbNwmgedAaSYjgf2A3afBUcBh5Uy9VHbW/zRzdhhJdsVNBjZYcFy
CVLOcf1toCRp8J4U5FlnFMOzFegUbdXFQhq2VmIhPRxWjrfTk6iR4BcMEN9UMij/5IHRAeBdksyD
CqEKsyFxosbI5KVMRZ1Ln75Zipn0JdsGekHkxg==

`pragma protect key_keyowner="Synplicity", key_keyname="SYNP15_1", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
DPUa5DLPYRWvbPnX0U412yoWvvvHyuq43DrYmDJGTK0cR5U4U6th8icYgizC1/hUAEzt19kM/hVa
zZh7bXSWACYLpcfhPY8dRTVGDZVjpbkraw0ceBryLP7jc6Jt5JdNw88tZtZpprCB7nQ25lUL82Hf
WTwL1ZqgGIvtfHhxO0JF5L5ES5giedwQ6u5ffXG3UB6ELcpQD1NvpW5lAz4mfXyvVDCAPZN581TF
tlAy79iKbPKlJ2zFn1BS2cuRIHHe2JRxwPo+0n5VD5CXVgg+lCYxTnCxI8CdyFaTumbs4IfAKwVI
wSN/btbwDUhW9hAHWHIRo+BpdJ4qeGcTDPKtsA==

`pragma protect key_keyowner="Mentor Graphics Corporation", key_keyname="MGC-PREC-RSA", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
mf5hcf6JE6yLm0jNCQnHMVmogjLlPz6re0FwG67yvOJ3FuEorru0emIeAKEwgOoxjUYNWvcM7QAH
/UEeB2EIdjLl6glPAUda0HjtaCU2rdncVdM8k6DSMBggc4yo18Qx5F+1TD/RoBgoo0jNkMdDy6wJ
JHjqlN+R01z3yYIMQ9f2z6ZaYncbBYEp4+YAb7g1D7CSMxP5cFRpQznRpYp0JwqJfT9CHzlKgdab
8B288NxeLM66iYodiTS+GSRGLGtDWXpz9yeiuiPe6kJxae2GJyHIMSfluO/0Slc3m24DQNdbojf8
jdc0G2UnrDe5mCUTfYiDmpOWTUJOdYo0FK0N2g==

`pragma protect data_method = "AES128-CBC"
`pragma protect encoding = (enctype = "BASE64", line_length = 76, bytes = 61440)
`pragma protect data_block
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
`pragma protect end_protected
`ifndef GLBL
`define GLBL
`timescale  1 ps / 1 ps

module glbl ();

    parameter ROC_WIDTH = 100000;
    parameter TOC_WIDTH = 0;
    parameter GRES_WIDTH = 10000;
    parameter GRES_START = 10000;

//--------   STARTUP Globals --------------
    wire GSR;
    wire GTS;
    wire GWE;
    wire PRLD;
    wire GRESTORE;
    tri1 p_up_tmp;
    tri (weak1, strong0) PLL_LOCKG = p_up_tmp;

    wire PROGB_GLBL;
    wire CCLKO_GLBL;
    wire FCSBO_GLBL;
    wire [3:0] DO_GLBL;
    wire [3:0] DI_GLBL;
   
    reg GSR_int;
    reg GTS_int;
    reg PRLD_int;
    reg GRESTORE_int;

//--------   JTAG Globals --------------
    wire JTAG_TDO_GLBL;
    wire JTAG_TCK_GLBL;
    wire JTAG_TDI_GLBL;
    wire JTAG_TMS_GLBL;
    wire JTAG_TRST_GLBL;

    reg JTAG_CAPTURE_GLBL;
    reg JTAG_RESET_GLBL;
    reg JTAG_SHIFT_GLBL;
    reg JTAG_UPDATE_GLBL;
    reg JTAG_RUNTEST_GLBL;

    reg JTAG_SEL1_GLBL = 0;
    reg JTAG_SEL2_GLBL = 0 ;
    reg JTAG_SEL3_GLBL = 0;
    reg JTAG_SEL4_GLBL = 0;

    reg JTAG_USER_TDO1_GLBL = 1'bz;
    reg JTAG_USER_TDO2_GLBL = 1'bz;
    reg JTAG_USER_TDO3_GLBL = 1'bz;
    reg JTAG_USER_TDO4_GLBL = 1'bz;

    assign (strong1, weak0) GSR = GSR_int;
    assign (strong1, weak0) GTS = GTS_int;
    assign (weak1, weak0) PRLD = PRLD_int;
    assign (strong1, weak0) GRESTORE = GRESTORE_int;

    initial begin
	GSR_int = 1'b1;
	PRLD_int = 1'b1;
	#(ROC_WIDTH)
	GSR_int = 1'b0;
	PRLD_int = 1'b0;
    end

    initial begin
	GTS_int = 1'b1;
	#(TOC_WIDTH)
	GTS_int = 1'b0;
    end

    initial begin 
	GRESTORE_int = 1'b0;
	#(GRES_START);
	GRESTORE_int = 1'b1;
	#(GRES_WIDTH);
	GRESTORE_int = 1'b0;
    end

endmodule
`endif
