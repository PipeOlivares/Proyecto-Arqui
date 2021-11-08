library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.std_logic_unsigned.all;
use IEEE.numeric_std.all;


entity CPU is
    Port (
           clock : in STD_LOGIC;
           clear : in STD_LOGIC;
           ram_address : out STD_LOGIC_VECTOR (11 downto 0);
           ram_datain : out STD_LOGIC_VECTOR (15 downto 0);
           ram_dataout : in STD_LOGIC_VECTOR (15 downto 0);
           ram_write : out STD_LOGIC;
           rom_address : out STD_LOGIC_VECTOR (11 downto 0);
           rom_dataout : in STD_LOGIC_VECTOR (35 downto 0);
           dis : out STD_LOGIC_VECTOR (15 downto 0);
           flags: out STD_LOGIC_VECTOR (2 downto 0);
           pc_out: out STD_LOGIC_VECTOR (11 downto 0)) ; ---c,z,n
end CPU;

architecture Behavioral of CPU is
component Adder16
    Port ( a  : in  std_logic_vector (15 downto 0);
           b  : in  std_logic_vector (15 downto 0);
           ci : in  std_logic;
           s  : out std_logic_vector (15 downto 0);
           co : out std_logic);
    end component;

component SP is
    Port ( clock : in STD_LOGIC;
           clear : in STD_LOGIC;
           incSP : in STD_LOGIC;
           decSP : in STD_LOGIC;
           outSP : out STD_LOGIC_VECTOR (11 downto 0));
end component;

component Reg is
    Port ( 
           clock    : in  std_logic;                        -- Se�al del clock (reducido).
           clear    : in  std_logic;                        -- Se�al de reset.
           load     : in  std_logic;                        -- Se�al de carga.
           up       : in  std_logic;                        -- Se�al de subida.
           down     : in  std_logic;                        -- Se�al de bajada.
           datain   : in  std_logic_vector (15 downto 0);   -- Se�ales de entrada de datos.
           dataout  : out std_logic_vector (15 downto 0));  -- Se�ales de salida de datos.
    end component;
component control_unit is
    Port ( instruct : in STD_LOGIC_VECTOR (19 downto 0);
           c_stat : in STD_LOGIC;
           n_stat : in STD_LOGIC;
           z_stat : in STD_LOGIC;
           enA : out STD_LOGIC;
           enB : out STD_LOGIC;
           selA : out STD_LOGIC_VECTOR (1 downto 0);
           selB : out STD_LOGIC_VECTOR (1 downto 0);
           loadPC : out STD_LOGIC;
           selALU : out STD_LOGIC_VECTOR (2 downto 0);
           pc_sel: out STD_LOGIC;
           selDIn: out STD_LOGIC;
           selADD: out STD_LOGIC_VECTOR (1 downto 0);
           incSP :out STD_LOGIC;
           decSP: out STD_LOGIC;
           w : out STD_LOGIC);
    end component;
component ALU is
    Port ( a        : in  std_logic_vector (15 downto 0);   -- Primer operando.
           b        : in  std_logic_vector (15 downto 0);   -- Segundo operando.
           sop      : in  std_logic_vector (2 downto 0);   -- Selector de la operaci�n.
           c        : out std_logic;                       -- Se�al de 'carry'.
           z        : out std_logic;                       -- Se�al de 'zero'.
           n        : out std_logic;                       -- Se�al de 'nagative'.
           result   : out std_logic_vector (15 downto 0));  -- Resultado de la operaci�n.
    end component;
component STATUS is
    Port ( c : in STD_LOGIC;
           z : in STD_LOGIC;
           n : in STD_LOGIC;
           clock : in STD_LOGIC;
           clear : in STD_LOGIC;
           z_out : out STD_LOGIC;
           c_out : out STD_LOGIC;
           n_out : out STD_LOGIC);
end component;
component PC is
    Port ( datain : in STD_LOGIC_VECTOR (11 downto 0);
           load : in STD_LOGIC;
           clock : in STD_LOGIC;
           clear : in STD_LOGIC;
           dataout : out STD_LOGIC_VECTOR (11 downto 0));
end component;


signal a_dataout        : std_logic_vector(15 downto 0); --Salida reg A
signal b_dataout        : std_logic_vector(15 downto 0); --Salida reg B

signal a_data_ALU       : std_logic_vector(15 downto 0); --Salida reg A
signal b_data_ALU       : std_logic_vector(15 downto 0); --Salida reg B

signal b_sel            : std_logic_vector(1 downto 0);
signal a_sel            : std_logic_vector(1 downto 0);

signal DIn_sel          : std_logic;

signal ALU_sel          : std_logic_vector(2 downto 0);
signal ALU_result       : std_logic_vector(15 downto 0);
signal flag_c           : std_logic;
signal flag_z           : std_logic;
signal flag_n           : std_logic;
signal flag_c_0         : std_logic;
signal flag_z_0         : std_logic;
signal flag_n_0         : std_logic;

signal a_enable         : std_logic;
signal b_enable         : std_logic;

signal load_pc          : std_logic;
signal pc_in            : std_logic_vector(11 downto 0);
signal pc_select        : std_logic;

signal counter          : std_logic_vector(11 downto 0);
signal ram_inst         : std_logic_vector(15 downto 0);

signal adder_out        : std_logic_vector(15 downto 0);
signal adder_c          : std_logic;
signal selAdd           : std_logic_vector(1 downto 0);

signal ram_add          : std_logic_vector(11 downto 0);

signal sp_inc           :std_logic;
signal sp_dec           :std_logic;
signal sp_out           :std_logic_vector(11 downto 0);

begin

ram_address <= ram_add;
dis <= a_dataout;
flags(2) <= flag_c_0;
flags(1) <= flag_z_0;
flags(0) <= flag_n_0;
rom_address <= counter;
pc_out <= counter;
ram_inst(11 downto 0) <= rom_dataout(31 downto 20); 

--Muxer A
with a_sel select
    a_data_ALU <= a_dataout when "01",
                "0000000000000000" when "00",
                "1111111111111111" when "11",
                "0000000000000001" when "10";
    
--Muxer B

with b_sel select
    b_data_ALU <= b_dataout when "01",
                "0000000000000000" when "00",
                ram_dataout when "11",
                rom_dataout(35 downto 20) when "10";
                
--Muxer PC
with pc_select select
    pc_in <= rom_dataout(31 downto 20) when '0',
                ram_dataout(11 downto 0) when '1';


--Muxer Ram datain
with DIn_sel select
    ram_datain <= ALU_result when '0',
                adder_out when '1';

--Muxer Ram addres
with selAdd select
    ram_add <= rom_dataout(31 downto 20) when "00",
                b_dataout(11 downto 0) when "01",
                sp_out when others;           
--Instancia ALU
inst_ALU: ALU port map(
    a           => a_data_ALU,
    b           => b_data_ALU,
    sop         => ALU_sel,
    c           => flag_c,
    z           => flag_z,
    n           => flag_n,
    result      => ALU_result
    );
inst_A: Reg port map(
    clock       => clock,
    clear       => clear,
    load        => a_enable,
    up          => '0',
    down        => '0',
    datain      => ALU_result,
    dataout     => a_dataout
    );
inst_B: Reg port map(
    clock       => clock,
    clear       => clear,
    load        => b_enable,
    up          => '0',
    down        => '0',
    datain      => ALU_result,
    dataout     => b_dataout
    );
inst_CU: control_unit port map(
    instruct    => rom_dataout(19 downto 0),
    c_stat      => flag_c_0,
    n_stat      => flag_n_0,
    z_stat      => flag_z_0,
    enA         => a_enable,
    enB         => b_enable,
    selA        => a_sel,
    selB        => b_sel,
    loadPC      => load_pc,
    selALU      => ALU_sel,
    pc_sel      => pc_select,
    selDIn      => DIn_sel,
    selADD      =>selAdd,
    incSP       =>sp_inc,
    decSP       =>sp_dec,
    w           => ram_write
    );
inst_STATUS: STATUS port map(
    c           => flag_c,
    n           => flag_n,
    z           => flag_z,
    clock       => clock,
    clear       => clear,
    z_out       => flag_z_0,
    c_out       => flag_c_0,
    n_out       => flag_n_0
    );

inst_PC: PC port map(
    datain      => pc_in,
    load        => load_pc,
    clock       => clock,
    clear       => clear,
    dataout     => rom_address
    );
inst_Adder16: Adder16 port map(
        a      =>ram_inst,
        b      =>"0000000000000000",
        ci      =>'1',
        s      =>adder_out,
        co    =>adder_c
    );      
inst_SP:      SP port map(
           clock => clock,
           clear => clear,
           incSP => sp_inc,
           decSP => sp_dec,
           outSP => sp_out
           );
end Behavioral;

