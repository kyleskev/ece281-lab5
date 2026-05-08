----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/18/2025 02:50:18 PM
-- Design Name: 
-- Module Name: ALU - Behavioral
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity ALU is
    Port ( i_A : in STD_LOGIC_VECTOR (7 downto 0);
           i_B : in STD_LOGIC_VECTOR (7 downto 0);
           i_op : in STD_LOGIC_VECTOR (2 downto 0);
           o_result : out STD_LOGIC_VECTOR (7 downto 0);
           o_flags : out STD_LOGIC_VECTOR (3 downto 0));
end ALU;

architecture Behavioral of ALU is
    signal c_result : std_logic_vector(7 downto 0);
begin
    process(i_A, i_B, i_op)
    begin
        case i_op is
            when "000" => --ADD
                c_result <= std_logic_vector(unsigned(i_A) + unsigned(i_B));
            when "001" => --SUBTRACT
                c_result <= std_logic_vector(unsigned(i_A) - unsigned(i_B));
            when "010" =>
                c_result <= i_A and i_B;
            when "011" =>
                c_result <= i_A or i_B;
            when others => 
                c_result <= "00000000";
       end case;
   end process;

    o_result <= c_result;
    
    o_flags(3) <= c_result(7);
    o_flags(2) <= '1' when c_result = "00000000" else '0';
    o_flags(1) <= '0';
    o_flags(0) <= '0';
end Behavioral;
