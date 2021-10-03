-- NO TOCAR

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.std_logic_unsigned.all;

entity Reg is
    Port ( clock    : in  std_logic;                        -- Señal del clock (reducido).
           clear    : in  std_logic;                        -- Señal de reset.
           load     : in  std_logic;                        -- Señal de carga.
           up       : in  std_logic;                        -- Señal de subida.
           down     : in  std_logic;                        -- Señal de bajada.
           datain   : in  std_logic_vector (15 downto 0);   -- Señales de entrada de datos.
           dataout  : out std_logic_vector (15 downto 0));  -- Señales de salida de datos.
end Reg;

architecture Behavioral of Reg is

signal reg : std_logic_vector(15 downto 0) := (others => '0'); -- Señales del registro. Parten en 0.

begin

reg_prosses : process (clock)           -- Proceso sensible a clock.
        begin
          if (rising_edge(clock)) then  -- Condición de flanco de subida de clock.
            if (clear = '1') then 
                reg <= (others => '0'); -- Si clear = 1, carga 0 en el registro.
            elsif (load = '1') then
                reg <= datain;          -- Si clear = 0, load = 1, carga la entrada de datos en el registro.
            elsif (up = '1') then
                reg <= reg + 1;         -- Si clear = 0,load = 0 y up = 1 incrementa el registro en 1.
            elsif (down = '1') then
                reg <= reg - 1;         -- Si clear = 0,load = 0, up = 0 y down = 1 decrementa el registro en 1.          
            end if;
          end if;
        end process;
        
dataout <= reg;                         -- Los datos del registro salen sin importar el estado de clock.
            
end Behavioral;
