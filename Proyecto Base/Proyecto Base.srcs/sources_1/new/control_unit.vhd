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
    Port ( instruc : in STD_LOGIC_VECTOR (20 downto 0);
           c_stat : in STD_LOGIC;
           n_stat : in STD_LOGIC;
           z_stat : in STD_LOGIC;
           enA : out STD_LOGIC;
           enB : out STD_LOGIC;
           selA : out STD_LOGIC_VECTOR (2 downto 0);
           selB : out STD_LOGIC_VECTOR (2 downto 0);
           loadPC : out STD_LOGIC;
           selALU : out STD_LOGIC_VECTOR (3 downto 0));
end control_unit;

architecture Behavioral of control_unit is

begin


end Behavioral;
