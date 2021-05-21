library ieee;
use ieee.std_logic_1164.all;

entity FSM is
   port (instruction,T1,T2,T3,mem: in std_logic_vector(15 downto 0); r, clk,init_carry,init_zero: in std_logic;
	pc_w,m_w,ir_w,rf_w,t3_w,t2_w,t1_w,
	m1,m20,m21,m30,m31,m4,m50,m51,m60,m61,m70,m71,m8,m90,m91,m100,m101,mux,
	carry,zero,done,alucont,m12: out std_logic);
end entity;

architecture Behave4 of FSM is

  type StateSymbol  is (s0,s1,s2,s3,s4,s5,s6,s7,s8,s9,s10,s11,s12,s13,s14,s15,s16,s17,s18,s19,s20,s21,sa);
  signal fsm_state_symbol: StateSymbol;

begin
process(r,clk,instruction,init_carry,init_zero,T1,T2,T3,fsm_state_symbol)
	variable nextState_var : StateSymbol;
	variable pc_w_var,m_w_var,ir_w_var,rf_w_var,t3_w_var,t2_w_var,t1_w_var,
		m1_var,m20_var,m21_var,m30_var,m31_var,m4_var,m50_var,m51_var,m60_var,m61_var,m70_var,m71_var,m8_var,m90_var,m91_var,m100_var,m101_var,
		carry_var,zero_var,mux_var,done_var,alu_var,m12_var : std_logic;

	begin
		nextState_var := fsm_state_symbol; 
		pc_w_var := '0';
		m_w_var := '0';
		ir_w_var := '0';
		rf_w_var := '0';
		t3_w_var := '0';
		t2_w_var := '0';
		t1_w_var := '0';

		m1_var := '0';
		m20_var := '1';
		m21_var := '0';
		m30_var := '0';
		m31_var := '0';
		m4_var := '0';
		m50_var := '0';
		m51_var := '0';
		m60_var := '0';
		m61_var := '0';
		m70_var := '0';
		m71_var := '0';
		m8_var := '0';
		m90_var := '0';
		m91_var := '0';
		m100_var := '0';
		m101_var := '0';
		carry_var := '1';
		zero_var := '1';
		mux_var := '0';
		done_var := '0';
		alu_var := '0';
		m12_var := '0';


     -- compute next-state, output
		case fsm_state_symbol is
			when s0 =>
				ir_w_var := '1';				 
				-- m20_var := '1';
				-- m21_var := '0';

				if (mem(15 downto 12) = "0001" ) then --t1
					nextState_var := s5;
				elsif (mem(15 downto 12) = "0011") then --t2
					nextState_var := s11;
				elsif ((mem(15 downto 12) = "0110") or (mem(15 downto 12) = "0111")) then --t3
					nextState_var := s13;
				elsif ((mem(15 downto 12) = "1000") or (mem(15 downto 12) = "1001")) then
					nextState_var := s18;
				else
					nextState_var := s1;
				end if;

			when s1 =>
				t2_w_var := '1';
				t1_w_var := '1';
				-- m60_var := '1';
				-- m61_var := '0';
				-- m70_var := '1';
				-- m71_var := '0';		
				-- m8_var := '0';

				if (instruction(15 downto 12) = "0100") or (mem(15 downto 12) = "0101")) then --t8
					nextState_var := s7;
				elsif (((instruction(15 downto 12) = "0000" ) or (instruction(15 downto 12) = "0010" )) and ((instruction(1 downto 0) = "00") or (instruction(1 downto 0) = "10" and init_carry = '1') or (instruction(1 downto 0) = "01" and init_zero = '1'))) then --t10
					nextState_var := s2;
				elsif (instruction(15 downto 12) = "1100" and (T1 = T2) )then
					nextState_var := s12;
				else
					nextState_var := s4;
				end if;
				
			when s2 =>
				t3_w_var := '1';
				-- m90_var := '0';
				-- m91_var := '1';
				-- m100_var := '0';
				-- m101_var := '1';
				-- m60_var := '0';
				-- m61_var := '1';

				if ((instruction(15 downto 12) = "0000") or (instruction(15 downto 12) = "0001")) then
					carry_var := '0';
				end if;
					zero_var := '0';
				if (instruction(15 downto 12) = "0010") then
					alu_var := '1';
				else
					alu_var := '0';
				end if;

				if ((instruction(15 downto 12) = "0000") or (instruction(15 downto 12) = "0010")) then --t11
					nextState_var := s3;
				elsif (instruction(15 downto 12) = "0001") then --t12
					nextState_var := s6;
				end if;
					
			when s3 =>
				rf_w_var := '1';				 
				-- m50_var := '1';
				-- m51_var := '1';	
				-- m30_var := '0';
				-- m31_var := '1';
				nextState_var := s4;
		
		
			when s4 =>
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
					
			when s5 =>
				t1_w_var := '1';
				t2_w_var := '1';
				-- rf_w_var := '0';
				-- m30_var := '1';
				-- m31_var := '0';		
				-- m50_var := '1';
				-- m51_var := '1';	

				nextState_var := s2;

					
			when s6 =>
				rf_w_var := '1';
				-- m30_var := '0';
				-- m31_var := '0';
				-- m50_var := '1';
				-- m51_var := '0';

				nextState_var := s4;

			 
			when s7 =>
				t2_w_var := '1';
				-- m90_var := '1';
				-- m91_var := '0';
				-- m100_var := '1';
				-- m101_var := '1';
				-- m70_var := '0';
				-- m71_var := '1';
				alu_var := '0';

				if (instruction(15 downto 12) = "0100" ) then --t13
					nextState_var := s8;
				else --t14
					nextState_var := s10;
				end if;
			 
			when s8 =>
					t3_w_var := '1';
					zero_var := '0';					
					-- m20_var := '0';
					-- m21_var := '0';	
					-- m60_var := '0';
					-- m61_var := '0';	
					-- mux_var := '1';

					nextState_var := s9;

			when s9 =>
				rf_w_var := '1';
				-- m_w_var := '0';
				-- m20_var := '0';
				-- m21_var := '0';

				nextState_var := s4;

				 
			when s10 =>
				m_w_var := '1';
				-- rf_w_var := '0';				 
				-- m30_var := '0';
				-- m31_var := '0';	
				-- m50_var := '1';
				-- m51_var := '1';	

				nextState_var := s4;

				 
			when s11 =>
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
	
				 
			when s12 => 
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
				
			 
			when s13 =>
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

				if (instruction(15 downto 12) = "0110" ) then --t15
					nextState_var := s14;
				else --t16
					nextState_var := s16;
				end if;

			when s14 => 
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
			 
	when s15 =>
				 pc_w_var := '0';
				 m90_var := '0';
	          m91_var := '0';
				 m100_var := '1';
	          m101_var := '0';
				 m1_var := '0';
				 
						nextState_var := s0;
					done_var := '1';
	
	when s16 =>
		t3_w_var = '1';
		t2_w_var = '1';
		nextState_var = s17;
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
	
	when s17 =>
		m_w_var = '1';
		t1_w_var = '1';
		if (T2(2 downto 0) /= "000") then  -- t19
			nextState_var = s16;
		else  -- t20
			nextState_var = s4;
		end if;
		-- pc_w_var := '0';
		-- m90_var := '1';
		-- m91_var := '0';
		-- m100_var := '1';
		-- m101_var := '0';
		-- m1_var := '0';

		-- nextState_var := s0;
		-- done_var := '1';
					
	when s18 =>
		rf_w_var = '1';
		t2_w_var = '1';
		if (instruction(15 downto 12) == "1000") then
			nextState_var = s19;
		else
			nextState_var = s20;
		end if;
		-- pc_w_var := '0';
		-- m1_var := '1';

		-- nextState_var := s0;
		-- done_var := '1';
				
	when s19 =>
		alu_var = '0';
		pc_w_var = '1';
		nextState_var = s0;

	when s20 =>
		pc_w_var = '1';
		nextState_var = s0;

	when sa =>
		pc_w_var := '0';				 
		m90_var := '1';
		m91_var := '1';
		m100_var := '1';
		m101_var := '0';	
		m1_var := '0';

		nextState_var := s0;
		done_var := '1';

				 

       when others => null;

     end case;
	  
	  

  
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
     if(rising_edge(clk)) then
          if (r = '1') then
             fsm_state_symbol <= s0;
          else
             fsm_state_symbol <= nextState_var;
          end if;
     end if;

  end process;

end Behave4;