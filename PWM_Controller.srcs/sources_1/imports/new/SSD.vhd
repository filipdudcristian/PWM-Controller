----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/07/2023 04:29:12 PM
-- Design Name: 
-- Module Name: SSD - Behavioral
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
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity SSD is
  Port (d0,d1,d2,d3 : in std_logic_vector(3 downto 0);
          clk: in std_logic;
          cat: out std_logic_vector(6 downto 0);
          an: out std_logic_vector(3 downto 0 ));
end SSD;

architecture Behavioral of SSD is

signal counter: std_logic_vector(15 downto 0):="0000000000000000";
signal d: std_logic_vector(3 downto 0):="0000";
signal sel: std_logic_vector(1 downto 0):="00";

begin

process(clk)
begin
    if rising_edge(clk) then
        counter<=counter+1;
    end if;
end process;

sel<=counter(15 downto 14);

process(sel)
begin
    case sel is
        when "00" => d<=d0;
                     an<="1110";
        when "01" => d<=d1;
                     an<="1101";
        when "10" => d<=d2;
                     an<="1011";
        when others => d<=d3;
                     an<="0111";    
     end case;
end process;

process(d)
begin

 case d is
   when "0001" => cat <= "1111001";  
   when "0010" => cat <= "0100100";
   when "0011" => cat <= "0110000";  
   when "0100" => cat <= "0011001";
   when "0101" => cat <= "0010010";
   when "0110" => cat <= "0000010";
   when "0111" => cat <= "1111000"; 
   when "1000" => cat <= "0000000";
   when "1001" => cat <= "0010000"; 
   when "1010" => cat <= "0001000"; 
   when "1011" => cat <= "0000011";
   when "1100" => cat <= "1000110";
   when "1101" => cat <= "0100001";
   when "1110" => cat <= "0000110";
   when "1111" => cat <= "0001110";
   when others => cat <= "1000000";    
   end case; 
    
  
end process;

end Behavioral;
