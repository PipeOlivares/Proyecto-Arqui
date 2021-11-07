----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 10/03/2021 05:40:57 PM
-- Design Name: 
-- Module Name: control_unit - Behavioral
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity control_unit is
    Port ( instruct : in STD_LOGIC_VECTOR (19 downto 0);
           c_stat : in STD_LOGIC;
           n_stat : in STD_LOGIC;
           z_stat : in STD_LOGIC;
           enA : out STD_LOGIC;
           enB : out STD_LOGIC;
           selA : out STD_LOGIC_VECTOR (1 downto 0);
           selB : out STD_LOGIC_VECTOR (1 downto 0);
           loadPC : out STD_LOGIC;
           selALU : out STD_LOGIC_VECTOR (2 downto 0);
           pc_sel: out STD_LOGIC;
           selDIn: out STD_LOGIC;
           selADD : out STD_LOGIC_VECTOR (1 downto 0);
           w : out STD_LOGIC);
end control_unit;

-- B: 10 Lit, 00 Zero, 01 B, 11 RAM 
-- A: 00 Zero, 01 A 
-- ADD: 000 , SUB 001
architecture Behavioral of control_unit is
signal decider : STD_LOGIC_VECTOR(10 downto 0);
begin
selADD <= instruct(14 downto 13);
selDIn <= instruct(12);
pc_sel <= instruct(11);
decider <= instruct(10 downto 0);
enA <= decider(10);
enB <= decider(9);
selA <= decider(8 downto 7);
selB <= decider(6 downto 5);
w <= decider(0);
selALU <= decider(3 downto 1);
with instruct(19) select
    loadPC <= decider(4) when '0',
    decider(4) and z_stat when '1';
    
end Behavioral;
