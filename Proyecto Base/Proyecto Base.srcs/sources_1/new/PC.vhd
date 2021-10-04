----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 10/04/2021 12:53:04 PM
-- Design Name: 
-- Module Name: PC - Behavioral
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

entity PC is
    Port ( datain : in STD_LOGIC_VECTOR (11 downto 0);
           load : in STD_LOGIC;
           clock : in STD_LOGIC;
           clear : in STD_LOGIC;
           dataout : out STD_LOGIC_VECTOR (11 downto 0));
end PC;

architecture Behavioral of PC is

signal reg : std_logic_vector(11 downto 0) := (others => '0'); -- Se�ales del registro. Parten en 0.

begin

reg_prosses : process (clock)           -- Proceso sensible a clock.
        begin
          if (rising_edge(clock)) then  -- Condici�n de flanco de subida de clock.
            if (clear = '1') then 
                reg <= (others => '0'); -- Si clear = 1, carga 0 en el registro.
            elsif (load = '1') then
                reg <= datain;          -- Si clear = 0, load = 1, carga la entrada de datos en el registro.
            else 
                reg <= reg + 1;         -- Si clear = 0,load = 0 y up = 1 incrementa el registro en 1         
            end if;
          end if;
        end process;
        
dataout <= reg;                       -- Los datos del registro salen sin importar el estado de clock.

end Behavioral;
