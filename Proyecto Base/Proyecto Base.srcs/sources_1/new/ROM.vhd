library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
USE IEEE.NUMERIC_STD.ALL;

entity ROM is
    Port (
        clk       : in  std_logic;
        write     : in  std_logic;
        disable   : in  std_logic;
        address   : in  std_logic_vector(11 downto 0);
        datain    : in  std_logic_vector(35 downto 0);
        dataout   : out std_logic_vector(35 downto 0)
          );
end ROM; 

architecture Behavioral of ROM is
type memory_array is array (0 to 15) of std_logic_vector (35 downto 0); 
signal memory : memory_array:= (
"000000000000011000000000010001000000", --MOV A,5              0
"000000000000001100000000001001000000", --MOV B,3              1
"000000000000000000000000000010000001", --MOV (fac1),A         2
"000000000000000100000000000000100001", --MOV (fac2),B         3
"000000000000001000000000000010000001", --MOV (res),A          4
"000000000000000000000000010000100000", --MOV A,B    loop      5
"000000000000000100000000010011000010", --SUB A,1              6
"000000000000000000000000000011000010", --CMP A,0              7
"000000000000111000100000000010110000", --JEQ saver            8
"000000000000000000000000001010000000", --MOV B,A              9
"000000000000001000000000010001100000", --MOV A,(res)          10
"000000000000000000000000010011100000",-- ADD A,(fac1)         11
"000000000000001000000000000010000001", --MOV (res),A          12
"000000000000010100000000000010110000", --JMP LOOP             13
"000000000000001000000000010001100000", --MOV A,(res) SAVER    14
"000000000000111100000000000010110000");
begin

process (clk)
    begin
       if (rising_edge(clk)) then
            if(write = '1') then
                memory(to_integer(unsigned(address))) <= datain;
            end if;
       end if;
end process;

with disable select
    dataout <= memory(to_integer(unsigned(address)))  when '0',
            (others => '0') when others;
            
end Behavioral; 

