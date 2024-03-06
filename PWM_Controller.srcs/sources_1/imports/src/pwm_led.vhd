library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

-- Fits the Lattice iCEstick FPGA board
entity pwm_led is
  generic (
    
    -- PWM and duty cycle counter bit length
    pwm_bits : integer := 8;
    
    -- PWM clock divider max count
    -- pwm_freq = 100 MHz / [100* (2**8 - 1)] = 3921 Hz
    clk_cnt_len : positive := 100;
    
     -- Counter bit length
    cnt_bits : integer := 28
  );
  port (
    clk : in std_logic;
    rst : in std_logic; 
    duty_cycle_manual: in UNSIGNED(pwm_bits - 1 downto 0);
    mode_select : in STD_LOGIC; 
    auto_mode_select : in std_logic;
    
    led : out std_logic_vector(15 downto 0);
    an   : out STD_LOGIC_VECTOR (3 downto 0); 
    cat  : out STD_LOGIC_VECTOR (6 downto 0) 
  );
end pwm_led;

architecture str of pwm_led is

  signal auto_mode_counter: std_logic;
  signal cnt : unsigned(cnt_bits - 1 downto 0);
  signal pwm_out : std_logic_vector(15 downto 0);
  
  signal duty_cycle : UNSIGNED (pwm_bits - 1 downto 0);
  signal duty_cycle_auto : UNSIGNED (pwm_bits - 1 downto 0);
  signal duty_cycle_breathing: UNSIGNED (pwm_bits - 1 downto 0);
  
  signal filtered : std_logic;

  -- Use MSBs of counter for the PWM duty cycle input
  alias duty_cycle_saw_tooth is cnt(cnt'high downto cnt'length - pwm_bits);
  
  -- Use MSBs of counter for sine ROM address input
  alias addr is cnt(cnt'high downto cnt'length - pwm_bits);
  
  signal ones : UNSIGNED (3 downto 0);
  signal tens : UNSIGNED (3 downto 0);
  signal hundred : std_logic;
begin
 
   -- Select the mode for the PWM controller 
   with mode_select select
   duty_cycle <= duty_cycle_auto when '0',
                 duty_cycle_manual when others; 
                 
   -- Select the automatic mode for the PWM controller               
   with auto_mode_counter select
   duty_cycle_auto <= duty_cycle_saw_tooth when '0',
                      duty_cycle_breathing when others;           
      
  led <= pwm_out;
   
  debounce2: entity work.debounce port map(clk, rst, auto_mode_select, filtered);
  
  btn_counting_proc:process(Clk) 
    begin
        if rising_edge(clk) and filtered = '1' then 
               auto_mode_counter <= not auto_mode_counter;
        end if;
    end process;
    
  
  display: entity work.SSD port map(std_logic_vector(ones),
                                    std_logic_vector(tens), 
                                    "000" & hundred ,
                                    "000" & auto_mode_counter , 
                                    clk, cat, an);

  HexToPercentage : entity work.HexToPercentage
    port map ( 
      duty_cycle => duty_cycle,
      ones => ones,
      tens => tens,
      hundred => hundred
    );
               
  
  PWM : entity work.pwm(rtl)
    generic map (
      pwm_bits => pwm_bits,
      clk_cnt_len => clk_cnt_len
    )
    port map (
      clk => clk,
      rst => rst,
      mode => mode_select,
      auto_mode => auto_mode_counter,
      duty_cycle => duty_cycle,
      pwm_out => led
    );

  COUNTER : entity work.counter(rtl)
    generic map (
      counter_bits => cnt'length
    )
    port map (
      clk => clk,
      rst => rst,
      count_enable => '1',
      counter => cnt
    );
    
    SINE_ROM : entity work.sine_rom(rtl)
    generic map (
      data_bits => pwm_bits,
      addr_bits => pwm_bits
    )
    port map (
      clk => clk,
      addr => addr,
      data => duty_cycle_breathing
    );
    
end architecture;