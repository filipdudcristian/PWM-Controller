----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 10/05/2023 05:12:05 PM
-- Design Name: 
-- Module Name: debounce - Behavioral
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
use IEEE.std_logic_unsigned.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity debounce is
    Port ( Clk : in STD_LOGIC;
           Rst : in STD_LOGIC;
           Din : in STD_LOGIC;
           Qout : out std_logic);
           --Counter : out STD_LOGIC_VECTOR (1 downto 0));
end debounce;

architecture Behavioral of debounce is

signal Q1, Q2, Q3 : std_logic;

--signal Q1, Q2, Q3, Qout : std_logic;
signal temp_counter : std_logic_vector(1 downto 0);

begin

process(Clk)
begin
   if (Clk'event and Clk = '1') then
      if (Rst = '1') then
         Q1 <= '0';
         Q2 <= '0';
         Q3 <= '0';
      else
         Q1 <= Din;
         Q2 <= Q1;
         Q3 <= Q2;
      end if;
   end if;
end process;

Qout <= Q1 and Q2 and (not Q3);

--counting_proc:process(Clk)
--begin
--    if rising_edge(clk) and Qout = '1' then 
--        if temp_counter = "01" then
--            temp_counter <= "00";
--        else
--            temp_counter <= temp_counter + 1;
--        end if;   
--    end if;
--end process;

end Behavioral;
