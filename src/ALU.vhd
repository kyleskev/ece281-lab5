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
begin

    process(i_A, i_B, i_op)
        variable v_result9 : unsigned(8 downto 0);
        variable v_result  : std_logic_vector(7 downto 0);
        variable v_flags   : std_logic_vector(3 downto 0);
    begin
        v_result9 := (others => '0');
        v_result  := (others => '0');
        v_flags   := (others => '0');

        case i_op is
            when "000" => -- ADD
                v_result9 := ('0' & unsigned(i_A)) + ('0' & unsigned(i_B));
                v_result  := std_logic_vector(v_result9(7 downto 0));

            when "001" => -- SUBTRACT
                v_result9 := ('0' & unsigned(i_A)) - ('0' & unsigned(i_B));
                v_result  := std_logic_vector(v_result9(7 downto 0));

            when "010" => -- AND
                v_result := i_A and i_B;

            when "011" => -- OR
                v_result := i_A or i_B;

            when others =>
                v_result := (others => '0');
        end case;

        -- NZCV flags
        v_flags(3) := v_result(7); -- N

        if v_result = "00000000" then
            v_flags(2) := '1'; -- Z
        else
            v_flags(2) := '0';
        end if;

        if i_op = "000" then
            v_flags(1) := v_result9(8); -- carry
        elsif i_op = "001" then
            if unsigned(i_A) >= unsigned(i_B) then
                v_flags(1) := '1'; -- no borrow
            else
                v_flags(1) := '0'; -- borrow occurred
            end if;
        else
            v_flags(1) := '0';
        end if;

        if i_op = "000" then
            if (i_A(7) = i_B(7)) and (v_result(7) /= i_A(7)) then
                v_flags(0) := '1'; -- V
            end if;
        elsif i_op = "001" then
            if (i_A(7) /= i_B(7)) and (v_result(7) /= i_A(7)) then
                v_flags(0) := '1'; -- V
            end if;
        end if;

        o_result <= v_result;
        o_flags  <= v_flags;
    end process;

end Behavioral;
