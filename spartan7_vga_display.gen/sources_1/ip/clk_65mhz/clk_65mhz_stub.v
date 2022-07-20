// Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2022.1.1 (win64) Build 3557992 Fri Jun  3 09:58:00 MDT 2022
// Date        : Wed Jul 20 14:58:48 2022
// Host        : Squid running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode synth_stub {g:/My
//               Drive/FPGA_Development/spartan7_vga_display/spartan7_vga_display.gen/sources_1/ip/clk_65mhz/clk_65mhz_stub.v}
// Design      : clk_65mhz
// Purpose     : Stub declaration of top-level module interface
// Device      : xc7s25csga225-1
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
module clk_65mhz(clk_65, clk_mem, reset, locked, clk_in1)
/* synthesis syn_black_box black_box_pad_pin="clk_65,clk_mem,reset,locked,clk_in1" */;
  output clk_65;
  output clk_mem;
  input reset;
  output locked;
  input clk_in1;
endmodule
