----------------------------------------------------------------------------------
-- Company:
-- Engineer: Oussama KADDAMI
-- 
-- Create Date: 08/17/2024 01:45:55 PM
-- Design Name: 
-- Module Name: CPU_PO - Behavioral
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

----------------
--
--    
--   type DATA_select is (
--        DATA_from_arith,
--        DATA_from_logical,
--        UNDEFINED
--    );
--
--
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.PKG.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity CPU_PO is
    Port ( 
        clk     : in std_logic;
        rst     : in std_logic;
        
        -- Operands
        RS1_IN  : in w32;
        RS2_IN  : in w32;
        RES     : out w32;        
    
        -- control signals
        data_sel: in DATA_select;
        we_out  : in std_logic;
        we_in   : in std_logic;        
        arith_opcode: in ARITH_op_type;
        logical_opcode: in LOGICAL_op_type;
         
        -- debug
        rs1_dbg: out w32;
        rs2_dbg: out w32;
        rs_logic_dbg: out w32;
        rs_arith_dbg: out w32
    );
end CPU_PO;

architecture Behavioral of CPU_PO is
    
    signal RS1_d, RS1_q: w32;
    signal RS2_d, RS2_q: w32;
    signal RSOUT_d, RSOUT_q: w32;
    
    signal LOGICAL_res : w32;
    signal ARITH_res:    w32;
    
    
begin
    -- The ALU supports logical ops (AND/OR/XOR) and arithmetic instruction (ADD/SUB)
    LOGICAL_res <= RS1_q and RS2_q when logical_opcode = LOGICAL_and else
                   RS1_q or  RS2_q when logical_opcode = LOGICAL_or  else
                   RS1_q xor RS2_q when logical_opcode = LOGICAL_xor else
                   (others => 'U');
    
    ARITH_res <= RS1_q + RS2_q when arith_opcode = ALU_plus  else
               RS1_q - RS2_q when arith_opcode = ALU_minus else
               (others => 'U');
               
    
    RS1_d <=  RS1_IN;
    RS2_d <=  RS2_IN;
        

    with data_sel select
    RSOUT_d <= LOGICAL_res when DATA_from_logical,
               ARITH_res when DATA_from_arith,
               (others => '0') when others;
    
    RES <= RSOUT_q;

    -- debug signals                    
    rs1_dbg <= RS1_q;
    rs2_dbg <= RS2_q;
    rs_logic_dbg <= LOGICAL_res;
    rs_arith_dbg <= ARITH_res;

    load_regs: process(clk)
    begin
        if rst = '1' then
            RS1_q <= w32_zero;
            RS2_q <= w32_zero;
        elsif (rising_edge(clk)) then
                if (we_in = '1') then
                    RS1_q <= RS1_d;
                    RS2_q <= RS2_d;
                end if;
                if (we_out = '1') then
                    RSOUT_q <= RSOUT_d;
                end if;
        end if;     
    end process load_regs;

end Behavioral;
