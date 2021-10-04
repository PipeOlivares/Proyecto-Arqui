----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 10/04/2021 12:25:36 PM
-- Design Name: 
-- Module Name: STATUS - Behavioral
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

entity STATUS is
    Port ( c : in STD_LOGIC;
           z : in STD_LOGIC;
           n : in STD_LOGIC;
           clock : in STD_LOGIC;
           clear : in STD_LOGIC;
           z_out : out STD_LOGIC;
           c_out : out STD_LOGIC;
           n_out : out STD_LOGIC);
end STATUS;

architecture Behavioral of STATUS is
begin
status_prosses : process (clock)           -- Proceso sensible a clock.
        begin
          if (rising_edge(clock)) then  -- Condici�n de flanco de subida de clock.
            if (clear = '1') then 
                c_out <= '0'; 
                z_out <= '0';
                n_out <= '0'; -- Si clear = 1, carga 0 en el registro.
            else 
                c_out <= c;
                z_out <= z;          -- Si clear = 0, load = 1, carga la entrada de datos en el registro.
                n_out <= n;          
            end if;
          end if;
        end process;                  -- Los datos del registro salen sin importar el estado de clock.

end Behavioral;
