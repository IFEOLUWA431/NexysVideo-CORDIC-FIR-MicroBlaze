// Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// Copyright 2022-2025 Advanced Micro Devices, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2025.1 (win64) Build 6140274 Thu May 22 00:12:29 MDT 2025
// Date        : Thu Nov 20 10:24:08 2025
// Host        : IC-5CG4104D9F running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode funcsim -rename_top decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix -prefix
//               decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix_ sub_system_axi_bram_ctrl_0_bram_1_sim_netlist.v
// Design      : sub_system_axi_bram_ctrl_0_bram_1
// Purpose     : This verilog netlist is a functional simulation representation of the design and should not be modified
//               or synthesized. This netlist cannot be used for SDF annotated simulation.
// Device      : xc7a200tsbg484-1
// --------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

(* CHECK_LICENSE_TYPE = "sub_system_axi_bram_ctrl_0_bram_1,blk_mem_gen_v8_4_11,{}" *) (* downgradeipidentifiedwarnings = "yes" *) (* x_core_info = "blk_mem_gen_v8_4_11,Vivado 2025.1" *) 
(* NotValidForBitStream *)
module decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix
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
  decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix_blk_mem_gen_v8_4_11 U0
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
`pragma protect encoding = (enctype = "BASE64", line_length = 76, bytes = 61264)
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
