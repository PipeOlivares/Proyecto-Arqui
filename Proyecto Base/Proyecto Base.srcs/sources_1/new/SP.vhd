----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 07.11.2021 15:14:51
-- Design Name: 
-- Module Name: SP - Behavioral
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
use IEEE.std_logic_unsigned.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity SP is
    Port ( clock : in STD_LOGIC;
           clear : in STD_LOGIC;
           incSP : in STD_LOGIC;
           decSP : in STD_LOGIC;
           outSP : out STD_LOGIC_VECTOR (11 downto 0));
end SP;

architecture Behavioral of SP is

signal sp : std_logic_vector(11 downto 0) := (others => '1'); -- Señales del registro. Parten en 0.

begin

sp_process : process (clock)           -- Proceso sensible a clock.
        begin
          if (rising_edge(clock)) then  -- Condición de flanco de subida de clock.
            if (clear = '1') then 
                SP <= (others => '0'); -- Si clear = 1, carga 0 en el registro.
            elsif (incSP = '1') then
                SP <= SP + 1;          -- 
            elsif (decSP = '1') then
                sp <= sp - 1;
                
            end if;
          elsif (falling_edge(clock)) then
            if (clear = '1') then 
                SP <= (others => '0'); -- Si clear = 1, carga 0 en el registro.
            elsif (incSP = '1') then
                SP <= SP + 1;          -- 
            elsif (decSP = '1') then
                sp <= sp - 1;
                
            end if;
                
          end if;
        end process;   



outSP <= sp;

end Behavioral;
