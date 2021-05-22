library std;
use std.standard.all;

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;


entity CustomProcessor is
    port (
        in_clock, in_reset : in std_logic;
        dataX:  out std_logic_vector(15 downto 0)
    );
end entity;


architecture CustomProcessorArchitecture of CustomProcessor is

    component generic_register is
        generic(n: natural :=16);
        port(
            input_reg: in std_logic_vector(n-1 downto 0);
            clock: in std_logic;
            load_reg: in std_logic;
            output_reg: out std_logic_vector(n-1 downto 0)
        );
    end component;

    component register_file is
        port (
            A1, A2,	A3: in std_logic_vector(2 downto 0);  -- because we have 8 register
            D3_in: in std_logic_vector(15 downto 0);
            clk, register_write: in std_logic;
            D1_out, D2_out: out std_logic_vector(15 downto 0)
        );
    end component;

    component mux_n_bit_2_to_1 is
        generic (n: natural :=16);
        port(
            i0, i1: in std_logic_vector(n-1 downto 0);
            s0: in STD_LOGIC;
            O: out std_logic_vector(n-1 downto 0)
        );
    end component;

    component mux_n_bit_4_to_1 is
        generic (n: natural :=16);
        port(
            i0, i1, i2, i3: in std_logic_vector(n-1 downto 0);
            s0, s1: in STD_LOGIC;
            O: out std_logic_vector(n-1 downto 0)
        );
    end component;

    component SimulatedRAM is
        PORT (
            addr, mem_data_in : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
            clock, mem_write : IN STD_LOGIC;
            mem_data_out : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
        );
    end component;

    component alu is
        generic(n: natural :=16);
        port (
            in_a : in std_logic_vector(n-1 downto 0);
            in_b : in std_logic_vector(n-1 downto 0);
            operation  : in std_logic;
            z_out   : out std_logic;
            c_out   : out std_logic;
            output_alu  : out std_logic_vector(n-1 downto 0)
        );
    end component;

    component FSM is
        PORT (
            instruction, mem_instruction, T1, T2, T3 : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
            clock, reset, init_carry, init_zero : IN STD_LOGIC;
    
            pc_w, m_w, ir_w, rf_w, t3_w, t2_w, t1_w,  -- Program Counter write, Memory Write, Instruction Register Write, Register File Write, Register T1 & T2 & T3 Write
            mux_pc, mux_mem_addr_A, mux_mem_addr_B, mux_mem_in, mux_rf_d3_A, mux_rf_d3_B, mux_rf_a1, mux_rf_a3_A,
            mux_rf_a3_B, mux_t1, mux_t2_A, mux_t2_B, mux_alu_a_A, mux_alu_a_B, mux_alu_b_A, mux_alu_b_B, mux_t3_A, mux_t3_B,
            alu_operation : OUT STD_LOGIC;
            carry_flag: OUT STD_LOGIC;  -- used for state S2
            zero_flag: OUT STD_LOGIC;  -- used for state S8
            mux_zero: OUT STD_LOGIC  -- used to differentiate S2 and S8
        );
    end component;

    -- TODO: define variables as necessary

    -- Below are the variables for processor/state Control Signals
    -- Initializing "c_ir_w" ensures that the IR is updated when the processors first starts
    signal c_pc_w, c_m_w, c_ir_w, c_rf_w, c_t3_w, c_t2_w, c_t1_w, c_mux_pc,
            c_mux_mem_addr_A, c_mux_mem_in, c_mux_rf_d3_A,
            c_mux_rf_d3_B, c_mux_rf_a1, c_mux_rf_a3_A, c_mux_rf_a3_B, c_mux_t1,
            c_mux_t2_A, c_mux_t2_B, c_mux_alu_a_A, c_mux_alu_a_B, c_mux_alu_b_A,c_mux_alu_b_B, c_mux_t3_A, c_mux_t3_B : STD_LOGIC := '0';
    signal c_mux_mem_addr_B : STD_LOGIC := '1';
    signal c_alu_operation : STD_LOGIC := '0';
    signal c_zero_write, c_carry_write, c_mux_zero : STD_LOGIC := '0';

    -- Prefix "s" denotes signals/temporary variables
    -- Initializing "s_mem_addr" ensures that the processor starts reading from memory address zero
    signal s_instruction_register : std_logic_vector(15 downto 0) := (others => '0');
    signal s_alu_C, s_PC_in, s_PC_out, s_mem_addr, s_mem_in, s_mem_out, s_rf_d3 : std_logic_vector(15 downto 0) := (others => '0');
    signal s_rf_a1, s_rf_a3 : std_logic_vector(2 downto 0) := (others => '0');
    signal s_rf_D1_out, s_rf_D2_out, s_T1_in, s_T2_in, s_T1_out, s_T2_out, s_alu_a_in, s_alu_b_in, s_T3_in, s_T3_out : std_logic_vector(15 downto 0) := (others => '0');
    signal s_carry_out, s_zero_in, s_zero_out : std_logic_vector(0 downto 0) := (others => '0');

    signal temp_sign_extender_6, temp_sign_extender_9, temp_higher_9_bits : std_logic_vector(15 downto 0) := (others => '0');
    signal temp_carry, temp_zero, temp_t3_isZero : std_logic_vector(0 downto 0) := (others => '0');

begin

    -- Prefix "l" means label

    l_fsm: FSM port map (
        instruction => s_instruction_register, mem_instruction => s_mem_out, T1 => s_T1_out, T2 => s_T2_out, T3 => s_T3_out,
        clock => in_clock, reset => in_reset, init_carry => s_carry_out(0), init_zero => s_zero_out(0),

        pc_w => c_pc_w, m_w => c_m_w, ir_w => c_ir_w, rf_w => c_rf_w, t3_w => c_t3_w,
        t2_w => c_t2_w, t1_w => c_t1_w, mux_pc => c_mux_pc, mux_mem_addr_A => c_mux_mem_addr_A, mux_mem_addr_B => c_mux_mem_addr_B,
        mux_mem_in => c_mux_mem_in, mux_rf_d3_A => c_mux_rf_d3_A, mux_rf_d3_B => c_mux_rf_d3_B, mux_rf_a1 => c_mux_rf_a1,
        mux_rf_a3_A => c_mux_rf_a3_A, mux_rf_a3_B => c_mux_rf_a3_B, mux_t1 => c_mux_t1, mux_t2_A => c_mux_t2_A, mux_t2_B => c_mux_t2_B,
        mux_alu_a_A => c_mux_alu_a_A, mux_alu_a_B => c_mux_alu_a_B, mux_alu_b_A => c_mux_alu_b_A, mux_alu_b_B => c_mux_alu_b_B,
        mux_t3_A => c_mux_t3_A, mux_t3_B => c_mux_t3_B,

        alu_operation => c_alu_operation, carry_flag => c_carry_write, zero_flag => c_zero_write, mux_zero => c_mux_zero
    );

    l_mux_PC: mux_n_bit_2_to_1 generic map (n => 16) port map (i0 => s_alu_C, i1 => s_T2_out, s0 => c_mux_pc, O => s_PC_in);
    l_PC: generic_register generic map (n => 16) port map (input_reg => s_PC_in, clock => in_clock, load_reg => c_pc_w, output_reg => s_PC_out);
    
    -- -- REFER: https://www.intel.com/content/www/us/en/programmable/support/support-resources/knowledge-base/solutions/rd03312005_587.html
    -- s_mux_select_line <= (c_mux_mem_addr_A & c_mux_mem_addr_B);
    l_mux_memory_addr: mux_n_bit_4_to_1 generic map (n => 16) port map (
        i0 => s_T2_out, i1 => s_PC_out, i2 => s_T1_out, i3 => (others => '0'),  -- "i3" is unused
        s0 => c_mux_mem_addr_A, s1 => c_mux_mem_addr_B, O => s_mem_addr
    );
    
    l_mux_memory_in: mux_n_bit_2_to_1 generic map (n => 16) port map (i0 => s_T1_out, i1 => s_T3_out, s0 => c_mux_mem_in, O => s_mem_in);
    
    -- TODO: think about this
    process (in_clock)
    begin
        if (in_reset = '1') then
            s_mem_addr <= (others => '0');
        end if;
    end process;

    l_memory: SimulatedRAM port map (addr => s_mem_addr, mem_data_in => s_mem_in, clock => in_clock, mem_write => c_m_w, mem_data_out => s_mem_out);

    l_IR: generic_register generic map (n => 16) port map(input_reg => s_mem_out, clock => in_clock, load_reg => c_ir_w, output_reg => s_instruction_register);

    l_T3: generic_register generic map (n => 16) port map (
        input_reg => s_T3_in, clock => in_clock, load_reg => c_t3_w,
        output_reg => s_T3_out
    );

    temp_higher_9_bits <= s_instruction_register(8 downto 0) & ("0000000");
    l_mux_rf_d3: mux_n_bit_4_to_1 generic map (n => 16) port map (
        i0 => temp_higher_9_bits, i1 => s_T3_out, i2 => s_PC_out, i3 => (others => '0'),  -- "i3" is unused
        s0 => c_mux_rf_d3_A, s1 => c_mux_rf_d3_B, O => s_rf_d3
    );

    l_mux_rf_a1: mux_n_bit_2_to_1 generic map (n => 3) port map (
        i0 => s_T2_out(2 downto 0), i1 => s_instruction_register(11 downto 9),
        s0 => c_mux_rf_a1, O => s_rf_a1
    );

    l_mux_rf_a3: mux_n_bit_4_to_1 generic map (n => 3) port map (
        i0 => s_instruction_register(8 downto 6), i1 => s_instruction_register(5 downto 3), 
        i2 => s_instruction_register(11 downto 9), i3 => s_T2_out(2 downto 0),
        s0 => c_mux_rf_a3_A, s1 => c_mux_rf_a3_B,
        O => s_rf_a3
    );

    l_RF: register_file port map (
        A1 => s_rf_a1, A2 => s_instruction_register(8 downto 6), A3 => s_rf_a3,
        D3_in => s_rf_d3, clk => in_clock, register_write => c_rf_w,
        D1_out => s_rf_D1_out, D2_out => s_rf_D2_out
    );

    l_mux_t1: mux_n_bit_2_to_1 generic map (n => 16) port map (
        i0 => s_alu_C, i1 => s_rf_D1_out,
        s0 => c_mux_t1,
        O => s_T1_in
    );

    temp_sign_extender_6 <= (
        0 => s_instruction_register(0),
        1 => s_instruction_register(1),
        2 => s_instruction_register(2),
        3 => s_instruction_register(3),
        4 => s_instruction_register(4),
        5 => s_instruction_register(5),
        others => s_instruction_register(5)
    );
    temp_sign_extender_9 <= (
        0 => s_instruction_register(0),
        1 => s_instruction_register(1),
        2 => s_instruction_register(2),
        3 => s_instruction_register(3),
        4 => s_instruction_register(4),
        5 => s_instruction_register(5),
        6 => s_instruction_register(6),
        7 => s_instruction_register(7),
        8 => s_instruction_register(8),
        others => s_instruction_register(8)
    );

    l_mux_t2: mux_n_bit_4_to_1 generic map (n => 16) port map (
        i0 => temp_sign_extender_6, i1 => s_rf_D2_out, i2 => s_alu_C, i3 => (others => '0'),
        s0 => c_mux_t2_A, s1 => c_mux_t2_B,
        O => s_T2_in
    );
    
    l_t1: generic_register generic map (n => 16) port map (
        input_reg => s_T1_in, clock => in_clock, load_reg => c_t1_w, output_reg => s_T1_out
    );
    l_t2: generic_register generic map (n => 16) port map (
        input_reg => s_T2_in, clock => in_clock, load_reg => c_t2_w, output_reg => s_T2_out
    );

    l_mux_ALU_A: mux_n_bit_4_to_1 generic map (n => 16) port map (
        i0 => s_PC_out, i1 => s_T1_out, i2 => s_T2_out, i3 => (others => '0'),  -- "i3" is unused
        s0 => c_mux_alu_a_A, s1 => c_mux_alu_a_B,
        O => s_alu_a_in
    );

    l_mux_ALU_B: mux_n_bit_4_to_1 generic map (n => 16) port map (
        i0 => (0 => '1', others => '0'), i1 => s_T2_out, i2 => temp_sign_extender_6, i3 => temp_sign_extender_9,
        s0 => c_mux_alu_b_A, s1 => c_mux_alu_b_B,
        O => s_alu_b_in
    );

    l_alu: alu generic map (n => 16) port map (
        in_a => s_alu_a_in, in_b => s_alu_b_in, operation => c_alu_operation,
        z_out => temp_zero(0), c_out => temp_carry(0), output_alu => s_alu_C
    );

    temp_t3_isZero <= (0 => not (
        s_T3_out(0) or s_T3_out(1) or s_T3_out(2) or s_T3_out(3) or s_T3_out(4) or 
        s_T3_out(5) or s_T3_out(6) or s_T3_out(7) or s_T3_out(8) or s_T3_out(9) or 
        s_T3_out(10) or s_T3_out(11) or s_T3_out(12) or s_T3_out(13) or 
        s_T3_out(14) or s_T3_out(15)
    ));
    l_mux_zero: mux_n_bit_2_to_1 generic map (n => 1) port map (
        i0 => temp_zero, i1 => temp_t3_isZero,
        s0 => c_mux_zero,
        O => s_zero_in
    );

    l_reg_zero : generic_register GENERIC MAP (n => 1) PORT MAP (
        input_reg => s_zero_in, clock => in_clock, load_reg => c_zero_write, output_reg => s_zero_out
    );

    l_reg_carry : generic_register GENERIC MAP (n => 1) PORT MAP (
        input_reg => temp_carry, clock => in_clock, load_reg => c_carry_write, output_reg => s_carry_out
    );

    l_mux_t3: mux_n_bit_4_to_1 generic map (n => 16) port map (
        i0 => s_mem_out, i1 => s_alu_C, i2 => s_rf_D1_out, i3 => (others => '0'),  -- "i3" is unused
        s0 => c_mux_t3_A, s1 => c_mux_t3_B, O => s_T3_in
    );

    dataX <= s_mem_out;

end CustomProcessorArchitecture;
