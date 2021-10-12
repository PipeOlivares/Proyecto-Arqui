-- NO TOCAR

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.std_logic_unsigned.all;

entity STATUS is
    Port ( clock    : in  std_logic;                        -- Se�al del clock (reducido).
           clear    : in  std_logic;                        -- Se�al de reset.
           c        : in  std_logic;
           z        : in  std_logic;
           n        : in  std_logic;   -- Se�ales de entrada de datos.
           c_out    : out  std_logic;
           z_out    : out  std_logic;
           n_out    : out  std_logic);
end STATUS;

architecture Behavioral of STATUS is

signal c_i : std_logic;
signal z_i : std_logic;
signal n_i : std_logic;

begin

status_process : process (clock)           -- Proceso sensible a clock.
        begin
          if (rising_edge(clock)) then  -- Condici�n de flanco de subida de clock.
            if (clear = '1') then 
                c_i <= '0';
                z_i <= '0';
                n_i <= '0'; -- Si clear = 1, carga 0 en el registro.
            else
                c_i <= c;
                z_i <= z;
                n_i <= n;          -- Si clear = 0, load = 1, carga la entrada de datos en el registro.          
            end if;
          end if;
        end process;
        
c_out <= c_i;
n_out <= n_i;
z_out <= z_i;                         -- Los datos del registro salen sin importar el estado de clock.
            
end Behavioral;