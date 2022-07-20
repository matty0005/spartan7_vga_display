-- Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
-- --------------------------------------------------------------------------------
-- Tool Version: Vivado v.2022.1.1 (win64) Build 3557992 Fri Jun  3 09:58:00 MDT 2022
-- Date        : Wed Jul 20 14:58:48 2022
-- Host        : Squid running 64-bit major release  (build 9200)
-- Command     : write_vhdl -force -mode synth_stub {g:/My
--               Drive/FPGA_Development/spartan7_vga_display/spartan7_vga_display.gen/sources_1/ip/clk_65mhz/clk_65mhz_stub.vhdl}
-- Design      : clk_65mhz
-- Purpose     : Stub declaration of top-level module interface
-- Device      : xc7s25csga225-1
-- --------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity clk_65mhz is
  Port ( 
    clk_65 : out STD_LOGIC;
    clk_mem : out STD_LOGIC;
    reset : in STD_LOGIC;
    locked : out STD_LOGIC;
    clk_in1 : in STD_LOGIC
  );

end clk_65mhz;

architecture stub of clk_65mhz is
attribute syn_black_box : boolean;
attribute black_box_pad_pin : string;
attribute syn_black_box of stub : architecture is true;
attribute black_box_pad_pin of stub : architecture is "clk_65,clk_mem,reset,locked,clk_in1";
begin
end;
