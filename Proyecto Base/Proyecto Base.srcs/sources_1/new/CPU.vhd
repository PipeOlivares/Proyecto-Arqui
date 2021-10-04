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
           dis : out STD_LOGIC_VECTOR (15 downto 0));
end CPU;

architecture Behavioral of CPU is
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

begin
ram_address <= rom_dataout(31 downto 20);
ram_datain <= ALU_result;
dis <= ALU_result;

--Muxer A
with a_sel select
    a_data_ALU <= a_dataout when "01",
                "0000000000000000" when "00",
                "1111111111111111" when "11",
                "1111111111111111" when "10";
    
--Muxer B

with b_sel select
    b_data_ALU <= b_dataout when "01",
                "0000000000000000" when "00",
                "1111111111111111" when "11",
                rom_dataout(35 downto 20) when "10";
                
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
    datain      => rom_dataout(31 downto 20),
    load        => load_pc,
    clock       => clock,
    clear       => clear,
    dataout     => rom_address
    );
end Behavioral;

