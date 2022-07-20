----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 19.07.2022 16:17:46
-- Design Name: 
-- Module Name: vga_display - vga
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

-- Hsync 
--  Visible Area: 1024 pixels
--  Front porch: 24 pixels
--  Sync pulse: 136 pixels
--  Back porch: 160 pixels
--  Whole line: 1344 pixels


-- Vsync 
--  Visible Area: 768 pixels
--  Front porch: 3 pixels
--  Sync pulse: 6 pixels
--  Back porch: 29 pixels
--  Whole line: 806 pixels

entity vga_display is

    -- ja(0 - 3) = red, green, blue, hsync, vsync
    Port ( 
           ja : out std_logic_vector(3 downto 0);
           led0_g : out std_logic;
           clk : in std_logic
        );
       
      
end vga_display;

architecture vga of vga_display is


    constant hsync_whole : natural := 1344;
    constant hsync_visible : natural := 1024;
    constant hsync_front_porch : natural := 1048; -- + 24
    constant hsync_sync : natural := 1184; -- + 136
    
    constant vsync_whole : natural := 806 * hsync_whole;
    constant vsync_visible : natural := 768 * hsync_whole;
    constant vsync_front_porch : natural := 771 * hsync_whole;
    constant vsync_sync : natural := 777 * hsync_whole;
    
    
    signal hsync_counter : natural range 0 to hsync_whole;
    signal vsync_counter : natural range 0 to vsync_whole;
    
    signal hsync_state : std_logic := '1';
    signal vsync_state : std_logic := '1';
     
    component clk_65mhz port (
         clk_in1, reset : in std_logic;
         clk_65, clk_mem, locked : out std_logic
    );
    end component;
    
    COMPONENT blk_mem_gen_0
      PORT (
        clka : IN STD_LOGIC;
        ena : IN STD_LOGIC;
        wea : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
        addra : IN STD_LOGIC_VECTOR(16 DOWNTO 0);
        dina : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
        douta : OUT STD_LOGIC_VECTOR(7 DOWNTO 0) 
      );
    END COMPONENT;
    
    signal clk_reset : std_logic;
    signal clk_locked : std_logic;
    signal clk_65 : std_logic;
    signal clk_mem : std_logic;
    
    signal wea : std_logic_VECTOR(0 downto 0):="0";
    
    signal dina,douta : std_logic_VECTOR(7 downto 0) := (others => '0');
    signal addra : std_logic_VECTOR(16 downto 0) := (others => '0');
    
    signal current_pixel : natural range 0 to 1024 * 768;
    signal current_pixel_8 : natural range 0 to 8;

begin
    
    -- Clock 65Mhz IP
    clk_65m : clk_65mhz 
     port map (
      clk_in1 => clk,
      clk_65 => clk_65,
      clk_mem => clk_mem,
      reset => clk_reset,
      locked => clk_locked
     );
     
     
     -- BRAM
     bram : blk_mem_gen_0
      PORT MAP (
        clka => clk_mem,
        ena => '1',
        wea => wea,
        addra => addra,
        dina => dina,
        douta => douta
      );
         
     
     hsync_proc : process (clk_65) is
     begin
        if rising_edge(clk_65) then
            
            -- Check to see if output should be 1 or 0
            if (hsync_counter < hsync_front_porch) or (hsync_counter >= hsync_sync) then
                hsync_state <= '1';
            else
                hsync_state <= '0';
            end if;
            
            -- Increment or reset counter
            if hsync_counter = hsync_whole then
                hsync_counter <= 0;
            else 
                hsync_counter <= hsync_counter + 1;
            end if;
         
        end if;
        
     end process hsync_proc;
     
     
     vsync_proc : process (clk_65) is
     begin
        if rising_edge(clk_65) then
            
            -- Check to see if output should be 1 or 0
            if (vsync_counter < vsync_front_porch) or (vsync_counter >= vsync_sync) then
                vsync_state <= '1';
            else
                vsync_state <= '0';
            end if;
            
            -- Increment or reset counter
            if vsync_counter = vsync_whole then
                vsync_counter <= 0;
            else 
                vsync_counter <= vsync_counter + 1;
            end if;
         
        end if;
        
     end process vsync_proc;
     
     
     pixel_proc : process (clk_65) is
     begin
        if rising_edge(clk_65) then
        
            -- Determine if we can output data bits
            if hsync_counter < hsync_visible and vsync_counter < vsync_visible then
            
             
                if current_pixel_8 = 8 then
                    -- Increment memory address
                    addra <= std_logic_vector( unsigned(addra) + 1 );

                    current_pixel_8 <= 0;
                else 
                    -- Output bit
                    ja(0) <= douta(current_pixel_8);
                end if;
                
                
                current_pixel <= current_pixel + 1;
                current_pixel_8 <= current_pixel_8 + 1;
                
                if current_pixel = 786432 then
                    -- Reset frame
                    addra <= (others => '0');
                    current_pixel_8 <= 0;
                    current_pixel <= 0;

                end if;
                
                
            
               
            else 
                ja(0) <= '0';
            end if; 

        end if;
        
     end process pixel_proc;
     
     
     ja(2) <= hsync_state;
     ja(3) <= vsync_state;
     

end vga;
