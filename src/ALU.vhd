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
    signal c_result9 : unsigned(8 downto 0);
    signal c_result  : std_logic_vector(7 downto 0);
begin

    process(i_A, i_B, i_op)
        variable v_a_signed : signed(7 downto 0);
        variable v_b_signed : signed(7 downto 0);
        variable v_r_signed : signed(7 downto 0);
    begin
        c_result9 <= (others => '0');
        c_result  <= (others => '0');
        o_flags   <= (others => '0');

        v_a_signed := signed(i_A);
        v_b_signed := signed(i_B);

        case i_op is
            when "000" => -- ADD
                c_result9 <= ('0' & unsigned(i_A)) + ('0' & unsigned(i_B));
                c_result  <= std_logic_vector(unsigned(i_A) + unsigned(i_B));

            when "001" => -- SUBTRACT
                c_result9 <= ('0' & unsigned(i_A)) - ('0' & unsigned(i_B));
                c_result  <= std_logic_vector(unsigned(i_A) - unsigned(i_B));

            when "010" => -- AND
                c_result <= i_A and i_B;

            when "011" => -- OR
                c_result <= i_A or i_B;

            when others =>
                c_result <= (others => '0');
        end case;

        v_r_signed := signed(c_result);

        -- N flag
        o_flags(3) <= c_result(7);

        -- Z flag
        if c_result = "00000000" then
            o_flags(2) <= '1';
        else
            o_flags(2) <= '0';
        end if;

        -- C flag
        if i_op = "000" or i_op = "001" then
            o_flags(1) <= c_result9(8);
        else
            o_flags(1) <= '0';
        end if;

        -- V flag
        if i_op = "000" then
            if (i_A(7) = i_B(7)) and (c_result(7) /= i_A(7)) then
                o_flags(0) <= '1';
            else
                o_flags(0) <= '0';
            end if;
        elsif i_op = "001" then
            if (i_A(7) /= i_B(7)) and (c_result(7) /= i_A(7)) then
                o_flags(0) <= '1';
            else
                o_flags(0) <= '0';
            end if;
        else
            o_flags(0) <= '0';
        end if;
    end process;

    o_result <= c_result;

end Behavioral;
