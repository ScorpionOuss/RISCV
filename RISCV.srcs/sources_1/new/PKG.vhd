----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 08/17/2024 02:13:41 PM
-- Design Name: 
-- Module Name: PKG - Behavioral
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


library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

package PKG is
    subtype w32   is unsigned(31 downto 0);
    subtype w16   is unsigned(15 downto 0);
    subtype waddr is unsigned(31 downto 0);

    type ARITH_op_type is (
        ALU_plus,  
        ALU_minus,
        UNDEFINED
    );
    type LOGICAL_op_type is (
        LOGICAL_and,
        LOGICAL_or,
        LOGICAL_xor,
        UNDEFINED
    );
    
   type DATA_select is (
        DATA_from_arith,
        DATA_from_logical,
        UNDEFINED
    );
    
    constant w32_zero   : w32   := (others=>'0');

end PKG;