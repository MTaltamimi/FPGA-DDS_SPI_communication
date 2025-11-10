LIBRARY ieee;
USE ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Moore_SPI_FSM is 

PORT (
		clk : IN std_logic ;
		fin : IN std_logic;
		Button : IN std_logic;
		fsync : OUT std_logic;
		ena : OUT std_logic;
		state_o : OUT integer range 0 to 3:=0
		);
		end Moore_SPI_FSM;
ARCHITECTURE behav of Moore_SPI_FSM is 
signal state : integer range 0 to 3:=0;
begin
process(clk) 
begin
	if rising_edge(clk) then
		case state is 
			when 0 => if Button='0' then state <=1; else state <=0; end if;
			when 1 =>  state <= 2;
			when 2 => if fin = '1' then state <=3; else state <=2; end if;
			when 3 =>  if Button='1' then state <=0; else state <=3; end if;
			when others => state <= 0;
			end case;
			end if;
	end process;
		fsync <= '0' when (state=1 Or state=2) else '1';
		ena <= '1' when (state=2) else '0';
		state_o <= state;
		end behav;