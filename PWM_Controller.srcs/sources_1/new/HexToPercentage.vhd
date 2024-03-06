----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 12/31/2023 04:15:51 PM
-- Design Name: 
-- Module Name: HexToPercentage - Behavioral
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
use IEEE.numeric_std.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity HexToPercentage is
    Port ( duty_cycle : in UNSIGNED (7 downto 0);
           ones : out UNSIGNED (3 downto 0);
           tens : out UNSIGNED (3 downto 0);
           hundred : out std_logic);
end HexToPercentage;

architecture Behavioral of HexToPercentage is

signal percentage : UNSIGNED (15 downto 0);
signal remainder : UNSIGNED (15 downto 0);
signal quotient : UNSIGNED (15 downto 0);

begin
    
    percentage <= (duty_cycle * 100) / 255;
    process(percentage)
    begin
        if percentage = 100 then
            hundred <= '1';
            remainder <= (others => '0');
            quotient <= (others => '0');
        else
            hundred <= '0';
            remainder <= percentage mod 10;
            quotient <= percentage / 10;
        end if;
    end process;
    
    ones <= remainder(3 downto 0);
    tens <= quotient(3 downto 0);
    
end Behavioral;
