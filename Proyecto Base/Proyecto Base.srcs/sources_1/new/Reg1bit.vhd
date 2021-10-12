----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 10/05/2021 05:36:17 PM
-- Design Name: 
-- Module Name: Regflags - Behavioral
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

entity Regflags is
    Port ( c : in STD_LOGIC;
           z : in STD_LOGIC;
           n : in STD_LOGIC;
           c_out : out STD_LOGIC;
           z_out : out STD_LOGIC;
           n_out : out STD_LOGIC;
           clock : in STD_LOGIC;
           clear : in STD_LOGIC);
end Regflags;

architecture Behavioral of Regflags is

begin


end Behavioral;
