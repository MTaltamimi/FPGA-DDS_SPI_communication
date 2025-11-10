LIBRARY ieee;
USE ieee.std_logic_1164.all;
use ieee.numeric_std.all;

ENTITY third_entity is 
	generic (
N : integer := 16
);
	PORT (
	clk : IN std_logic;
	Switch : IN std_logic_vector(9 downto 0); -- les 10 switches pour les dix bits configuré avec switch (non forcé)
	Button : IN std_logic;
	fsync : out std_logic ;
	MOSI : OUT std_logic ;
	ena : OUT std_logic;
	sclk_out : OUT std_logic;
	fin : OUT std_logic;
	state_o : OUT integer range 0 to 3:=0;
	gfedcba_sw1,gfedcba_sw2,gfedcba_sw3, gfedcba_sw4: OUT STD_LOGIC_VECTOR (6 DOWNTO 0); -- for 7 seg
	Switch_inter_rep : OUT std_logic_vector(15 downto 0)
		);
	end third_entity;
	
	
	ARCHITECTURE behav of third_entity IS
signal switch_inter : std_logic_vector(15 downto 0); -- some will be forced while others will connect switch of this entity to switch of MooreAndSclk

Component MooreAndSclk 
	generic (
N : integer := 16
);
	PORT (
	clk : IN std_logic;
	Switch : IN std_logic_vector(N-1 downto 0);
	Button : IN std_logic;
	fsync : out std_logic ;
	MOSI : OUT std_logic ;
	ena : OUT std_logic;
	sclk_out : OUT std_logic;
	fin : OUT std_logic;
	state_o : OUT integer range 0 to 3:=0
		);
		end component;
		
component seg_7
	
	PORT (
	SW: IN STD_LOGIC_VECTOR (3 DOWNTO 0);
	gfedcba: OUT STD_LOGIC_VECTOR (6 DOWNTO 0)
	);
	end component;
	
begin 
-- instantiation of 7 segments by connecting the input to part of switch_inter signal ; 4 parts for 16 bits
seg_7_inst_1 : seg_7 PORT MAP (SW =>switch_inter(15 downto 12),gfedcba =>gfedcba_sw1);
seg_7_inst_2 : seg_7 PORT MAP (SW =>switch_inter(11 downto 8),gfedcba =>gfedcba_sw2);
seg_7_inst_3 : seg_7 PORT MAP (SW =>switch_inter(7 downto 4),gfedcba =>gfedcba_sw3);
seg_7_inst_4 : seg_7 PORT MAP (SW =>switch_inter(3 downto 0),gfedcba =>gfedcba_sw4);

-- connecter le signal switch_inter aussi aux entrées de cette entité et forcer certaines à zero.
	switch_inter(15) <= '0';
		switch_inter(14 downto 13) <= Switch(9 downto 8);
		switch_inter (12 downto 10) <= "000";
		switch_inter( 9 downto 2) <= Switch(7 downto 0);
		switch_inter( 1 downto 0) <= "00";--(others =>'0');

	-- connect MooreAndSclk ports to the corresponding ports in third entity. 	
MooreAndSclk_inst : MooreAndSclk
	PORT MAP (
		clk => clk,
	Switch => switch_inter,
	Button => Button,
	fsync=> fsync,
	MOSI => MOSI,
	ena => ena,
	sclk_out => sclk_out,
	fin => fin,
	state_o => state_o
		);
		Switch_inter_rep <= switch_inter;
end behav;