----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 08/17/2024 02:33:13 PM
-- Design Name: 
-- Module Name: tb_cpu_po - Behavioral
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
use IEEE.NUMERIC_STD.ALL;
use work.PKG.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity tb_cpu_po is
--  Port ( );
end tb_cpu_po;

architecture Behavioral of tb_cpu_po is

    component CPU_PO is
    port ( 
        clk     : in std_logic;
        rst     : in std_logic;
        
        RS1_IN  : in w32;
        RS2_IN  : in w32;
        RES     : out w32;        

        data_sel: in DATA_select;
        we_out  : in std_logic;
        we_in   : in std_logic;
        arith_opcode: in ARITH_op_type;
        logical_opcode: in LOGICAL_op_type
    );
    end component;
    
    signal clk: std_logic := '0';
    constant clk_period             : time := 16 ns;
    
    signal s_reset, s_we_in, s_we_out: std_logic;
    
    signal s_rs1_in, s_rs2_in, s_res: w32;
    signal s_data_sel: DATA_select;
    signal s_arith_opcode: ARITH_op_type;
    signal s_logical_opcode: LOGICAL_op_type;
    
    
begin

    DATA_PATH: CPU_PO
    port map(
        clk => clk,
        rst => s_reset,
        
        RS1_IN => s_rs1_in,
        RS2_IN => s_rs2_in,
        RES    => s_res,
        
        data_sel => s_data_sel,
        we_out => s_we_out,
        we_in => s_we_in,
        logical_opcode => s_logical_opcode,
        arith_opcode => s_arith_opcode
    );
    
    
    clock: process
    begin
        clk <= not clk;
        wait for clk_period/2;
    end process clock;
    
    process
    begin
        s_reset <= '1';
        wait for clk_period/4;
        s_reset <= '0';
        wait;
    end process;
    
    process
    begin
        s_rs1_in <= w32_zero;
        s_rs2_in <= w32_zero;
        s_we_in <= '0';
        s_we_out <= '0';
        s_arith_opcode <= UNDEFINED;
        s_logical_opcode <= UNDEFINED;
        wait for clk_period/4;
        
        s_rs1_in <= X"00000010";
        s_rs2_in <= X"00000010";
        s_we_in <= '1';
        wait for clk_period;
        
        s_arith_opocde <= ALU_plus;
        s_we_out <= '1';
        s_data_sel <= DATA_from_arith;
        wait for clk_period;
        
        s_rs1_in <= X"FFFFFFFF";
        s_rs2_in <= X"DEADBEEF";
        s_we_in <= '1';
        wait for clk_period;
        
        s_logical_opcode <= LOGICAL_and;
        s_we_out <= '1';
        s_data_sel <= DATA_from_logical;
        wait for clk_period;
        
        report "End of Simulation" severity failure;
        wait;
    end process;
    
end Behavioral;
