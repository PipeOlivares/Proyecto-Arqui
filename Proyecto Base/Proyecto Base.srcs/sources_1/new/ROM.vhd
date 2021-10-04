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

type memory_array is array (0 to (23) ) of std_logic_vector (35 downto 0); 

signal memory : memory_array:= (
"000000000000010100000000010001000000", --MOV A,5 
"000000000000001100000000001001000000", --MOV B,3 
"000000000000000000000000000010000001", --MOV (fac1),A 
"000000000000000100000000000000100001", --MOV (fac2),B
"000000000000000000000000001001000000", --MOV B,0
"000000000000001000000000000000100001", --MOV (res),B
"000000000000110000000000010001000000", --MOV A,12
"000000000000001100000000000010000001", --MOV (loop),A
"000000000001001000000000010001000000", --MOV A,18 
"000000000000010000000000000010000001", --MOV (divider),A 
"000000000001011100000000010001000000", --MOV A,23 
"000000000000010100000000000010000001", --MOV (saver),A 
"000000000000000000000000010001100000", --MOV A,(fac1) LOOP
"000000000000000000000000000011000010", --CMP A,0
"000000000000010100000000000010110000", --JEQ saver
"000000000000001000000000010001100000", --MOV A,(res)
"000000000000000100000000001001100000", --MOV B,(fac2)
"000000000000001000000000000010100001", --ADD (res)
"000000000000000000000000010001100000", --MOV A,(fac1) DIVIDER
"000000000000000000000000000010101101", --SHR (fac1),A
"000000000000000100000000010001100000", --MOV A,(fac2)
"000000000000000100000000000010101111", --SHL (fac2),A
"000000000000001100000000000010110000", --JMP loop
"000000000000001000000000010001100000" --MOV A,(res) SAVER
        ); 

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

