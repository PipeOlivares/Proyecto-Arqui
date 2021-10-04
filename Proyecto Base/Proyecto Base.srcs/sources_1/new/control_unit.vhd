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
    Port ( instruct : in STD_LOGIC_VECTOR (20 downto 0);
           c_stat : in STD_LOGIC;
           n_stat : in STD_LOGIC;
           z_stat : in STD_LOGIC;
           enA : out STD_LOGIC;
           enB : out STD_LOGIC;
           selA : out STD_LOGIC_VECTOR (1 downto 0);
           selB : out STD_LOGIC_VECTOR (1 downto 0);
           loadPC : out STD_LOGIC;
           selALU : out STD_LOGIC_VECTOR (2 downto 0);
           w : out STD_LOGIC);
end control_unit;

-- B: 10 Lit, 00 Zero, 01 B, 11 RAM 
-- A: 00 Zero, 01 A 
-- ADD: 000 , SUB 001
architecture Behavioral of control_unit is
signal decider : STD_LOGIC_VECTOR(3 downto 0);
begin
decider<= instruct(3 downto 0);
 


process (decider, z_status)
begin
--MOVAL
if decider = '0000' then;
         enA <-'1';
         enB <-'0';
         selA <-'00';
         selB <-'10';
         loadPC <- '0';
         selALU <- '000';
         w <- '0';
        end if;
 --MOVBL
if decider = '0001' then
         enA <-'0';
         enB <-'1';
         selA <-'00;
         selB <-'10';
         loadPC <- '0';
         selALU <- '000';
         w <- '0';
        end if;
 --MOV(DIR)A
 if decider = '0010' then
         enA <-'0';
         enB <-'0';
         selA <-'01;
         selB <-'00';
         loadPC <- '0';
         selALU <- '000';
         w <- '1';
        end if;
--MOV(DIR)B
 if decider = '0011' then
         enA <-'0';
         enB <-'0';
         selA <-'00';
         selB <-'01';
         loadPC <- '0';
         selALU <- '000';
         w <- '1';
        end if;
 --MOVA(DIR)
 if decider = '0100' then
         enA <-'1';
         enB <-'0';
         selA <-'00;
         selB <-'11';
         loadPC <- '0';
         selALU <- '000';
         w <- '0';
        end if;
 --MOVB(DIR)
 if decider = '0101' then
         enA <-'0';
         enB <-'1';
         selA <-'00;
         selB <-'11';
         loadPC <- '0';
         selALU <- '000';
         w <- '0';
        end if;
  --CMPAL
 if decider = '0110' then
         enA <-'0';
         enB <-'0';
         selA <-'01;
         selB <-'10';
         loadPC <- '0';
         selALU <- '001';
         w <- '0';
        end if;
  --JEQ
 if decider = '0111' and z_stat = '0' then
         enA <-'0';
         enB <-'0';
         selA <-'01;
         selB <-'01';
         loadPC <- '0';
         selALU <- '001';
         w <- '1';
        end if;        
   --ANDAL
 if decider = '1000' then
         enA <-'1';
         enB <-'0';
         selA <-'01;
         selB <-'10';
         loadPC <- '0';
         selALU <- '010';
         w <- '0';
        end if;        
   --ADD(DIR)
 if decider = '1001' then
         enA <-'0';
         enB <-'0';
         selA <-'01;
         selB <-'01';
         loadPC <- '0';
         selALU <- '000';
         w <- '1';
        end if;  
 --SHR(DIR)A
 if decider = '1010' then
         enA <-'0';
         enB <-'0';
         selA <-'01;
         selB <-'01';
         loadPC <- '0';
         selALU <- '110';
         w <- '0';
        end if;   
 --SHL(DIR)A 
 if decider = '1011' then
         enA <-'0';
         enB <-'0';
         selA <-'01;
         selB <-'01';
         loadPC <- '0';
         selALU <- '111';
         w <- '0';
        end if;    
 --SHL(DIR)A 
 if decider = '1100' then
         enA <-'0';
         enB <-'0';
         selA <-'01;
         selB <-'01';
         loadPC <- '1';
         selALU <- '111';
         w <- '0';
        end if;    
end process;


end Behavioral;
