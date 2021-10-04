library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Basys3 is
    Port (
        sw          : in   std_logic_vector (15 downto 0); -- No Tocar - Se�ales de entrada de los interruptores -- Arriba   = '1'   -- Los 16 swiches.
        btn         : in   std_logic_vector (4 downto 0);  -- No Tocar - Se�ales de entrada de los botones       -- Apretado = '1'   -- 0 central, 1 arriba, 2 izquierda, 3 derecha y 4 abajo.
        led         : out  std_logic_vector (15 downto 0); -- No Tocar - Se�ales de salida  a  los leds          -- Prendido = '1'   -- Los 16 leds.
        clk         : in   std_logic;                      -- No Tocar - Se�al de entrada del clock              -- 100Mhz.
        seg         : out  std_logic_vector (7 downto 0);  -- No Tocar - Salida de las se�ales de segmentos.
        an          : out  std_logic_vector (3 downto 0);  -- No Tocar - Salida del selector de diplay.
        tx          : out  std_logic;                      -- No Tocar - Se�al de salida para UART Tx.
        rx          : in   std_logic                       -- No Tocar - Se�al de entrada para UART Rx.
          );
end Basys3;

architecture Behavioral of Basys3 is

-- Inicio de la declaraci�n de los componentes.

component Clock_Divider -- No Tocar
    Port (
        clk         : in    std_logic;
        speed       : in    std_logic_vector (1 downto 0);
        clock       : out   std_logic
          );
    end component;
    
component Display_Controller -- No Tocar
    Port (  
        dis_a       : in    std_logic_vector (3 downto 0);
        dis_b       : in    std_logic_vector (3 downto 0);
        dis_c       : in    std_logic_vector (3 downto 0);
        dis_d       : in    std_logic_vector (3 downto 0);
        clk         : in    std_logic;
        seg         : out   std_logic_vector (7 downto 0);
        an          : out   std_logic_vector (3 downto 0)
          );
    end component;
    
component Debouncer -- No Tocar
    Port (
        clk         : in    std_logic;
        signal_in      : in    std_logic;
        signal_out     : out   std_logic
          );
    end component;
            

component ROM -- No Tocar
    Port (
        clk         : in    std_logic;
        write       : in    std_logic;
        disable     : in    std_logic;
        address     : in    std_logic_vector (11 downto 0);
        dataout     : out   std_logic_vector (35 downto 0);
        datain      : in    std_logic_vector(35 downto 0)
          );
    end component;

component RAM -- No Tocar
    Port (  
        clock       : in    std_logic;
        write       : in    std_logic;
        address     : in    std_logic_vector (11 downto 0);
        datain      : in    std_logic_vector (15 downto 0);
        dataout     : out   std_logic_vector (15 downto 0)
          );
    end component;
    
component Programmer -- No Tocar
    Port (
        rx          : in    std_logic;
        tx          : out   std_logic;
        clk         : in    std_logic;
        clock       : in    std_logic;
        bussy       : out   std_logic;
        ready       : out   std_logic;
        address     : out   std_logic_vector(11 downto 0);
        dataout     : out   std_logic_vector(35 downto 0)
        );
    end component;
    
component CPU is
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
-- Fin de la declaraci�n de los componentes.

-- Inicio de la declaraci�n de se�ales.

signal clock            : std_logic;                     -- Se�al del clock reducido.
            
signal dis_a            : std_logic_vector(3 downto 0);  -- Se�ales de salida al display A.    
signal dis_b            : std_logic_vector(3 downto 0);  -- Se�ales de salida al display B.     
signal dis_c            : std_logic_vector(3 downto 0);  -- Se�ales de salida al display C.    
signal dis_d            : std_logic_vector(3 downto 0);  -- Se�ales de salida al display D.

signal dis              : std_logic_vector(15 downto 0); -- Se�ales de salida totalidad de los displays.

signal d_btn            : std_logic_vector(4 downto 0);  -- Se�ales de botones con anti-rebote.

signal write_rom        : std_logic;                     -- Se�al de escritura de la ROM.
signal pro_address      : std_logic_vector(11 downto 0); -- Se�ales del direccionamiento de programaci�n de la ROM.
signal rom_datain       : std_logic_vector(35 downto 0); -- Se�ales de la palabra a programar en la ROM.

signal clear            : std_logic;                     -- Se�al de limpieza de registros durante la programaci�n.

signal cpu_rom_address  : std_logic_vector(11 downto 0); -- Se�ales del direccionamiento de lectura de la ROM.
signal rom_address      : std_logic_vector(11 downto 0); -- Se�ales del direccionamiento de la ROM.
signal rom_dataout      : std_logic_vector(35 downto 0); -- Se�ales de la palabra de salida de la ROM.

signal write_ram        : std_logic;                     -- Se�al de escritura de la RAM.
signal ram_address      : std_logic_vector(11 downto 0); -- Se�ales del direccionamiento de la RAM.
signal ram_datain       : std_logic_vector(15 downto 0); -- Se�ales de la palabra de entrada de la RAM.
signal ram_dataout      : std_logic_vector(15 downto 0); -- Se�ales de la palabra de salida de la RAM.

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






-- Fin de la declaraci�n de los se�ales.

begin

dis_a  <= dis(15 downto 12);
dis_b  <= dis(11 downto 8);
dis_c  <= dis(7 downto 4);
dis_d  <= dis(3 downto 0);
                    
-- Muxer del address de la ROM.          
with clear select
    rom_address <= cpu_rom_address when '0',
                   pro_address when '1';


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
                   
-- Inicio de declaraci�n de instancias.

-- Instancia de la CPU.        
inst_CPU: CPU port map(
    clock       => clock,
    clear       => clear,
    ram_address => ram_address,
    ram_datain  => ram_datain,
    ram_dataout => ram_dataout,
    ram_write   => write_ram,
    rom_address => cpu_rom_address,
    rom_dataout => rom_dataout,
    dis         => dis
    );

-- Instancia de la memoria RAM.
inst_ROM: ROM port map(
    clk         => clk,
    disable     => clear,
    write       => write_rom,
    address     => rom_address,
    dataout     => rom_dataout,
    datain      => rom_datain
    );

-- Instancia de la memoria ROM.
inst_RAM: RAM port map(
    clock       => clock,
    write       => write_ram,
    address     => ram_address,
    datain      => ram_datain,
    dataout     => ram_dataout
    );
    
 -- Intancia del divisor de la se�al del clock.
inst_Clock_Divider: Clock_Divider port map(
    speed       => "11",                    -- Selector de velocidad: "00" full, "01" fast, "10" normal y "11" slow. 
    clk         => clk,                     -- No Tocar - Entrada de la se�al del clock completo (100Mhz).
    clock       => clock                    -- No Tocar - Salida de la se�al del clock reducido: 25Mhz, 8hz, 2hz y 0.5hz.
    );
    
 -- No Tocar - Intancia del controlador de los displays de 8 segmentos.    
inst_Display_Controller: Display_Controller port map(
    dis_a       => dis_a,                   -- No Tocar - Entrada de se�ales para el display A.
    dis_b       => dis_b,                   -- No Tocar - Entrada de se�ales para el display B.
    dis_c       => dis_c,                   -- No Tocar - Entrada de se�ales para el display C.
    dis_d       => dis_d,                   -- No Tocar - Entrada de se�ales para el display D.
    clk         => clk,                     -- No Tocar - Entrada del clock completo (100Mhz).
    seg         => seg,                     -- No Tocar - Salida de las se�ales de segmentos.
    an          => an                       -- No Tocar - Salida del selector de diplay.
	);
    
-- No Tocar - Intancias de los Debouncers.    
inst_Debouncer0: Debouncer port map( clk => clk, signal_in => btn(0), signal_out => d_btn(0) );
inst_Debouncer1: Debouncer port map( clk => clk, signal_in => btn(1), signal_out => d_btn(1) );
inst_Debouncer2: Debouncer port map( clk => clk, signal_in => btn(2), signal_out => d_btn(2) );
inst_Debouncer3: Debouncer port map( clk => clk, signal_in => btn(3), signal_out => d_btn(3) );
inst_Debouncer4: Debouncer port map( clk => clk, signal_in => btn(4), signal_out => d_btn(4) );

-- No Tocar - Intancia del ROM Programmer.           
inst_Programmer: Programmer port map(
    rx          => rx,                      -- No Tocar - Salida de la se�al de transmici�n.
    tx          => tx,                      -- No Tocar - Entrada de la se�al de recepci�n.
    clk         => clk,                     -- No Tocar - Entrada del clock completo (100Mhz).
    clock       => clock,                   -- No Tocar - Entrada del clock reducido.
    bussy       => clear,                   -- No Tocar - Salida de la se�al de programaci�n.
    ready       => write_rom,               -- No Tocar - Salida de la se�al de escritura de la ROM.
    address     => pro_address(11 downto 0),-- No Tocar - Salida de se�ales del address de la ROM.
    dataout     => rom_datain               -- No Tocar - Salida de se�ales palabra de entrada de la ROM.
        );
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
    instruct    => rom_dataout(18 downto 0),
    c_stat      => flag_c_0,
    n_stat      => flag_n_0,
    z_stat      => flag_z_0,
    enA         => a_enable,
    enB         => b_enable,
    selA        => a_sel,
    selB        => b_sel,
    loadPC      => load_pc,
    selALU      => ALU_sel,
    w           => write_ram
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

-- Fin de declaraci�n de instancias.

-- Fin de declaraci�n de comportamientos.
  
end Behavioral;