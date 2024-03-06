library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity pwm is
  generic (
    -- PWM and duty cycle counter bit length
    pwm_bits : integer;

    -- Clock divider max count
    -- Set to 1 to disable clock divider logic
    -- pwm_hz = clk_hz / (2**pwm_bits - 1) / clk_cnt_len
    clk_cnt_len : positive := 100 
  );
  port (
    clk : in std_logic;
    rst : in std_logic;
    mode : in std_logic;
    --auto_mode : in std_logic_vector (1 downto 0);
    auto_mode : in std_logic;
    duty_cycle : in unsigned(pwm_bits - 1 downto 0);
    pwm_out : out std_logic_vector(15 downto 0)
  );
end pwm;

architecture rtl of pwm is

  signal pwm_cnt : unsigned(pwm_bits - 1 downto 0);
  signal clk_cnt : integer range 0 to clk_cnt_len - 1;
  
  type duty_cycle_arrays is ARRAY (0 to 15) OF UNSIGNED (PWM_BITS - 1 downto 0);
  signal duty_cycles_temp: duty_cycle_arrays := (others => (others => '0'));
  signal pwm_counters: duty_cycle_arrays := (others => (others => '0'));

  signal duty_cycle_breathing_alt: UNSIGNED (pwm_bits - 1 downto 0);
begin
  
  -- The opposite value of the duty cycle, used for the alternate breathing effect  
  duty_cycle_breathing_alt <= not duty_cycle;  
   
  PWM_PROC : process(clk)
  begin
    if rising_edge(clk) then
        if rst = '1' then
          pwm_cnt <= (others => '0');
          pwm_out <= (others => '0');
          
        elsif clk_cnt = 0 then
        
            -- Incrementing the counting signal
            pwm_cnt <= pwm_cnt + 1;
            
            -- Setting the initial pwm_out value to 0 
            pwm_out <= (others => '0');

            -- Wrap pwm_cnt after 2**pwm_bits - 2
            if pwm_cnt = unsigned(to_signed(-2, pwm_cnt'length)) then
                pwm_cnt <= (others => '0');
            end if;
            
            case mode is
            
                 -- Auto mode
                 when '0' =>  case auto_mode is
                                  when '0' =>  duty_cycles_temp(0) <= duty_cycle;
                                               pwm_out <= (others => '0');
                                               for i in 1 to 15 loop 
                                                   duty_cycles_temp(i) <= duty_cycles_temp(i-1) - 8;
                                               end loop;
                                               
                                               for i in 0 to 15 loop
                                                
                                                  pwm_counters(i) <= pwm_counters(i) + 1;
                                                 
                                                  
                                                  if pwm_counters(i) = UNSIGNED(to_signed(-2, PWM_BITS)) then -- daca se ajunge la 111...10
                                                      pwm_counters(i) <= (others => '0');
                                                  end if;
                                                  
                                                  if pwm_counters(i) > duty_cycles_temp(i) then
                                                      pwm_out(i) <= '1';
                                                  end if;
                                               
                                               end loop;
                                                   
                                  when others => -- A for loop to set each of the 16 leds values alternatively
                                                 for i in 0 to 15 loop 
                                                     if i mod 2 = 0 then
                                                         if pwm_cnt < duty_cycle then
                                                             pwm_out(i) <= '1';
                                                         end if;
                                                     elsif i mod 2 = 1 then
                                                             if pwm_cnt < duty_cycle_breathing_alt then   
                                                                 pwm_out(i) <= '1';
                                                             end if;
                                                     end if;
                                                 end loop;
                              end case;
                 -- Manual mode             
                 when others => if pwm_cnt < duty_cycle then
                                 pwm_out <= (others => '1');
                             end if;
            end case;      
         end if;
    end if;
  end process;

  CLK_CNT_PROC : process(clk)
  begin
    if rising_edge(clk) then
      if rst = '1' then
        clk_cnt <= 0;
        
      else
        if clk_cnt < clk_cnt_len - 1 then
          clk_cnt <= clk_cnt + 1;
        else
          clk_cnt <= 0;
        end if;
        
      end if;
    end if;
  end process;

end architecture;