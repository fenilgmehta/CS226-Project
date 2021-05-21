LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY FSM IS
	PORT (
		instruction, T1, T2, T3, mem : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
		r, clk, init_carry, init_zero : IN STD_LOGIC;
		pc_w, m_w, ir_w, rf_w, t3_w, t2_w, t1_w,
		mux_pc, mux_mem_addr_A, mux_mem_addr_B, mux_mem_in, mux_rf_d3_A, mux_rf_d3_B, mux_rf_a1, mux_rf_a3_A, mux_rf_a3_B, mux_t1, mux_t2_A, mux_t2_B, mux_alu_a_A, mux_alu_a_B, mux_alu_b_A, mux_alu_b_B, mux_t3_A, mux_t3_B,
		-- m1, m20, m21, m30, m31, m4, m50, m51, m60, m61, m70, m71, m8, m90, m91, m100, m101, mux,
		carry, zero, done, alucont, m12 : OUT STD_LOGIC
	);
END ENTITY;

ARCHITECTURE Behave4 OF FSM IS

	TYPE StateSymbol IS (s0, s1, s2, s3, s4, s5, s6, s7, s8, s9, s10, s11, s12, s13, s14, s15, s16, s17, s18, s19, s20, s21, sa);
	SIGNAL fsm_state_symbol : StateSymbol;

BEGIN
	PROCESS (r, clk, instruction, init_carry, init_zero, T1, T2, T3, fsm_state_symbol)
		VARIABLE nextState_var : StateSymbol;
		VARIABLE pc_w_var, m_w_var, ir_w_var, rf_w_var, t3_w_var, t2_w_var, t1_w_var,
		m1_var, m20_var, m21_var, m30_var, m31_var, m4_var, m50_var, m51_var, m60_var, m61_var, m70_var, m71_var, m8_var, m90_var, m91_var, m100_var, m101_var,
		carry_var, zero_var, mux_var, done_var, alu_var, m12_var : STD_LOGIC;

	BEGIN
		nextState_var := fsm_state_symbol;
		pc_w_var := '0';
		m_w_var := '0';
		ir_w_var := '0';
		rf_w_var := '0';
		t3_w_var := '0';
		t2_w_var := '0';
		t1_w_var := '0';

		mux_pc_var := '0';
		mux_mem_addr_A_var := '0';
		mux_mem_addr_B_var := '0';
		mux_mem_in_var := '0';
		mux_rf_d3_A_var := '0';
		mux_rf_d3_B_var := '0';
		mux_rf_a1_var := '0';
		mux_rf_a3_A_var := '0';
		mux_rf_a3_B_var := '0';
		mux_t1_var := '0';
		mux_t2_A_var := '0';
		mux_t2_B_var := '0';
		mux_alu_a_A_var := '0';
		mux_alu_a_B_var := '0';
		mux_alu_b_A_var := '0';
		mux_alu_b_B_var := '0';
		mux_t3_A_var := '0';
		mux_t3_B_var := '0';

		-- m1_var := '0';
		-- m20_var := '1';
		-- m21_var := '0';
		-- m30_var := '0';
		-- m31_var := '0';
		-- m4_var := '0';
		-- m50_var := '0';
		-- m51_var := '0';
		-- m60_var := '0';
		-- m61_var := '0';
		-- m70_var := '0';
		-- m71_var := '0';
		-- m8_var := '0';
		-- m90_var := '0';
		-- m91_var := '0';
		-- m100_var := '0';
		-- m101_var := '0';
		-- carry_var := '1';
		-- zero_var := '1';
		-- mux_var := '0';
		-- done_var := '0';
		-- alu_var := '0';
		-- m12_var := '0';
		-- compute next-state, output
		CASE fsm_state_symbol IS
			WHEN s0 =>
				ir_w_var := '1';
				-- m20_var := '1';
				-- m21_var := '0';

				IF (mem(15 DOWNTO 12) = "0001") THEN --t1
					nextState_var := s5;
				ELSIF (mem(15 DOWNTO 12) = "0011") THEN --t2
					nextState_var := s11;
				ELSIF ((mem(15 DOWNTO 12) = "0110") OR (mem(15 DOWNTO 12) = "0111")) THEN --t3
					nextState_var := s13;
				ELSIF ((mem(15 DOWNTO 12) = "1000") OR (mem(15 DOWNTO 12) = "1001")) THEN
					nextState_var := s18;
				ELSE
					nextState_var := s1;
				END IF;

			WHEN s1 =>
				t2_w_var := '1';
				t1_w_var := '1';
				-- m60_var := '1';
				-- m61_var := '0';
				-- m70_var := '1';
				-- m71_var := '0';		
				-- m8_var := '0';

				IF (instruction(15 DOWNTO 12) = "0100") OR (mem(15 DOWNTO 12) = "0101")) THEN --t8
					nextState_var := s7;
				ELSIF (((instruction(15 DOWNTO 12) = "0000") OR (instruction(15 DOWNTO 12) = "0010")) AND ((instruction(1 DOWNTO 0) = "00") OR (instruction(1 DOWNTO 0) = "10" AND init_carry = '1') OR (instruction(1 DOWNTO 0) = "01" AND init_zero = '1'))) THEN --t10
					nextState_var := s2;
				ELSIF (instruction(15 DOWNTO 12) = "1100" AND (T1 = T2)) THEN
					nextState_var := s12;
				ELSE
					nextState_var := s4;
				END IF;

			WHEN s2 =>
				t3_w_var := '1';
				-- m90_var := '0';
				-- m91_var := '1';
				-- m100_var := '0';
				-- m101_var := '1';
				-- m60_var := '0';
				-- m61_var := '1';

				IF ((instruction(15 DOWNTO 12) = "0000") OR (instruction(15 DOWNTO 12) = "0001")) THEN
					carry_var := '0';
				END IF;
				zero_var := '0';
				IF (instruction(15 DOWNTO 12) = "0010") THEN
					alu_var := '1';
				ELSE
					alu_var := '0';
				END IF;

				IF ((instruction(15 DOWNTO 12) = "0000") OR (instruction(15 DOWNTO 12) = "0010")) THEN --t11
					nextState_var := s3;
				ELSIF (instruction(15 DOWNTO 12) = "0001") THEN --t12
					nextState_var := s6;
				END IF;

			WHEN s3 =>
				rf_w_var := '1';
				-- m50_var := '1';
				-- m51_var := '1';	
				-- m30_var := '0';
				-- m31_var := '1';
				nextState_var := s4;
			WHEN s4 =>
				pc_w_var := '1';
				-- m90_var := '1';
				-- m91_var := '0';
				-- m100_var := '0';
				-- m101_var := '1';
				-- m60_var := '0';
				-- m61_var := '1';
				-- carry_var := '0';
				-- zero_var := '0';
				alu_var := '0';
				nextState_var := s0;
				done_var := '1';

			WHEN s5 =>
				t1_w_var := '1';
				t2_w_var := '1';
				-- rf_w_var := '0';
				-- m30_var := '1';
				-- m31_var := '0';		
				-- m50_var := '1';
				-- m51_var := '1';	

				nextState_var := s2;
			WHEN s6 =>
				rf_w_var := '1';
				-- m30_var := '0';
				-- m31_var := '0';
				-- m50_var := '1';
				-- m51_var := '0';

				nextState_var := s4;
			WHEN s7 =>
				t2_w_var := '1';
				-- m90_var := '1';
				-- m91_var := '0';
				-- m100_var := '1';
				-- m101_var := '1';
				-- m70_var := '0';
				-- m71_var := '1';
				alu_var := '0';

				IF (instruction(15 DOWNTO 12) = "0100") THEN --t13
					nextState_var := s8;
				ELSE --t14
					nextState_var := s10;
				END IF;

			WHEN s8 =>
				t3_w_var := '1';
				zero_var := '0';
				-- m20_var := '0';
				-- m21_var := '0';	
				-- m60_var := '0';
				-- m61_var := '0';	
				-- mux_var := '1';

				nextState_var := s9;

			WHEN s9 =>
				rf_w_var := '1';
				-- m_w_var := '0';
				-- m20_var := '0';
				-- m21_var := '0';

				nextState_var := s4;
			WHEN s10 =>
				m_w_var := '1';
				-- rf_w_var := '0';				 
				-- m30_var := '0';
				-- m31_var := '0';	
				-- m50_var := '1';
				-- m51_var := '1';	

				nextState_var := s4;
			WHEN s11 =>
				rf_w_var := '1';
				-- t2_w_var := '0';
				-- t1_w_var := '0';
				-- m90_var := '1';
				-- m91_var := '1';
				-- m100_var := '0';
				-- m101_var := '1';
				-- m20_var := '1';
				-- m21_var := '1';
				-- m70_var := '1';
				-- m71_var := '1';	
				-- m8_var := '1';
				nextState_var := s4;
			WHEN s12 =>
				alu_var := '0';
				t3_w_var := '1';
				-- rf_w_var := '0';
				-- m90_var := '1';
				-- m91_var := '1';
				-- m100_var := '0';
				-- m101_var := '0';	
				-- m30_var := '1';
				-- m31_var := '1';	
				-- m50_var := '0';
				-- m51_var := '1';	
				-- m60_var := '0';
				-- m61_var := '1';	
				nextState_var := s0;
				done_var := '1';
			WHEN s13 =>
				t1_w_var := '1';
				t2_w_var := '1';
				-- m90_var := '1';
				-- m91_var := '1';
				-- m100_var := '0';
				-- m101_var := '0';
				-- m60_var := '0';
				-- m61_var := '1';
				-- m70_var := '0';
				-- m71_var := '0';	
				-- m4_var := '1';

				IF (instruction(15 DOWNTO 12) = "0110") THEN --t15
					nextState_var := s14;
				ELSE --t16
					nextState_var := s16;
				END IF;

			WHEN s14 =>
				t1_w_var := '1';
				t3_w_var := '1';
				-- m_w_var := '0';
				-- m90_var := '1';
				-- m91_var := '1';
				-- m100_var := '0';
				-- m101_var := '1';
				-- m20_var := '1';
				-- m21_var := '1';      
				-- m8_var := '1';
				-- m12_var := '1';
				nextState_var := s15;

			WHEN s15 =>
				rf_w_var := '1';
				t2_w_var := '1';
				-- pc_w_var := '0';
				-- m90_var := '0';
				-- m91_var := '0';
				-- m100_var := '1';
				-- m101_var := '0';
				-- m1_var := '0';
				IF (T2(2 DOWNTO 0) = "000") THEN --t18
					nextState_var := s4;
				ELSE --t17
					nextState_var := s14;
				END IF;

			WHEN s16 =>
				t3_w_var := '1';
				t2_w_var := '1';
				nextState_var := s17;
				-- rf_w_var := '0';
				-- t2_w_var := '0';
				-- m30_var := '0';
				-- m31_var := '0';
				-- m50_var := '0';
				-- m51_var := '0';	
				-- m70_var := '1';
				-- m71_var := '0';

				-- if (instruction(15 downto 12) = "1000" ) then
				-- 	nextState_var := s15;
				-- else
				-- -- opcode : 1001
				-- 	nextState_var := s18;
				-- end if;

			WHEN s17 =>
				m_w_var := '1';
				t1_w_var := '1';
				IF (T2(2 DOWNTO 0) /= "000") THEN -- t19
					nextState_var := s16;
				ELSE -- t20
					nextState_var := s4;
				END IF;
				-- pc_w_var := '0';
				-- m90_var := '1';
				-- m91_var := '0';
				-- m100_var := '1';
				-- m101_var := '0';
				-- m1_var := '0';

				-- nextState_var := s0;
				-- done_var := '1';

			WHEN s18 =>
				rf_w_var := '1';
				t2_w_var := '1';
				IF (instruction(15 DOWNTO 12) = "1000") THEN --t5
					nextState_var := s19;
				ELSE --t6
					nextState_var := s20;
				END IF;
				-- pc_w_var := '0';
				-- m1_var := '1';

				-- nextState_var := s0;
				-- done_var := '1';

			WHEN s19 =>
				alu_var := '0';
				pc_w_var := '1';
				nextState_var := s0;
				done_var := '1';

			WHEN s20 =>
				pc_w_var := '1';
				nextState_var := s0;
				done_var := '1';

			WHEN OTHERS => NULL;

		END CASE;
		-- y(k)

		pc_w <= pc_w_var;
		m_w <= m_w_var;
		ir_w <= ir_w_var;
		rf_w <= rf_w_var;
		t3_w <= t3_w_var;
		t2_w <= t2_w_var;
		t1_w <= t1_w_var;
		m1 <= m1_var;
		m20 <= m20_var;
		m21 <= m21_var;
		m30 <= m30_var;
		m31 <= m31_var;
		m4 <= m4_var;
		m50 <= m50_var;
		m51 <= m51_var;
		m60 <= m60_var;
		m61 <= m61_var;
		m70 <= m70_var;
		m71 <= m71_var;
		m8 <= m8_var;
		m90 <= m90_var;
		m91 <= m91_var;
		m100 <= m100_var;
		m101 <= m101_var;
		carry <= carry_var;
		zero <= zero_var;
		mux <= mux_var;
		done <= done_var;
		alucont <= alu_var;
		m12 <= m12_var;
		-- q(k+1) = nq(k)
		IF (rising_edge(clk)) THEN
			IF (r = '1') THEN
				fsm_state_symbol <= s0;
			ELSE
				fsm_state_symbol <= nextState_var;
			END IF;
		END IF;

	END PROCESS;

END Behave4;