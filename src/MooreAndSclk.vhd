LIBRARY ieee;
USE ieee.std_logic_1164.all;
use ieee.numeric_std.all;

ENTITY MooreAndSclk is 
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
	end MooreAndSclk;
	
	
	ARCHITECTURE behav of MooreAndSclk IS
signal ena_out : std_logic;
signal fini : std_logic;
signal fsync_sig : std_logic;
signal state_o_sig : integer range 0 to 3:=0;
signal sclk_out_sig : std_logic;
signal MOSI_sig : std_logic ;

Component Moore_SPI_FSM 
Port ( 	
			clk : IN std_logic ;
		fin : IN std_logic;
		Button : IN std_logic;
		fsync : OUT std_logic;
		ena : OUT std_logic;
		state_o : OUT integer range 0 to 3:=0
		);
		end component;
		
component sclk
	generic (
prescaler : integer := 10;
N : integer := 16
);
	PORT (
	clk : in std_logic;
data_w : in std_logic_vector( N-1 downto 0);
ena : in std_logic;
sclk_clk : out std_logic ;
finished : out std_logic;
MOSI : out std_logic
	);
	end component;
	
begin 

SPI_sclk_inst : sclk
	PORT MAP (
	
		clk => clk,
		data_w => Switch,
		ena => ena_out,
		sclk_clk => sclk_out_sig,
		finished => fini,
		MOSI => MOSI_sig
		);
Moore_SPI_FSM_inst : Moore_SPI_FSM
	PORT MAP (
		clk => clk,
		fin => fini,
		Button => Button,
		fsync => fsync_sig,
		ena => ena_out,
		state_o => state_o_sig
		);
		
ena <= ena_out;
fsync <= fsync_sig;
MOSI <= MOSI_sig;
state_o <= state_o_sig;
sclk_out <= sclk_out_sig;
fin <= fini;
end behav;