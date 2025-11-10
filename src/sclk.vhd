LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

entity sclk is 

generic (
prescaler : integer := 10;
N : integer := 16
);

PORT(

clk : in std_logic;
data_w : in std_logic_vector( N-1 downto 0);
ena : in std_logic;
sclk_clk : out std_logic ;
finished : out std_logic;
sclk_o : out integer range 0 to (prescaler-1);
MOSI : out std_logic

);
 end sclk; 
 
Architecture behav of sclk is 



signal sclk_c : integer range 0 to (prescaler-1);


begin


	Process (clk) 

	variable MOSI_v :  std_logic;
	variable sclk_out_v : std_logic :='1';
	variable i : integer range 0 to N :=0;
	variable data : std_logic_vector( N-1 downto 0);
	variable fin : std_logic :='0';


	begin

	if rising_edge(clk) then

		if ena ='0' then
			sclk_out_v := '0';
			fin := '0';
			MOSI_v := '0';
			
			
		else 
					data := data_w;
					if ( sclk_c < (prescaler/2 -1)) then
						sclk_c <= sclk_c+1;
						sclk_out_v := '1';
						MOSI_v := data(N-1-i);
						i:=i;
						elsif (  (sclk_c < prescaler-1)) then
							sclk_c <= sclk_c+1;
							sclk_out_v := '0';
							MOSI_v := data(N-1-i);
							i:=i;
						else 
							sclk_c <= 0;
							sclk_out_v := '1';
							i := i+1;
							if i = N then
								fin :='1';
								--i:=0;
								MOSI_v := data(N-1-i+1);
							else
								fin :='0';
								MOSI_v := data(N-1-i);

							end if;
							end if;
							end if;
					end if;
					
					MOSI <= MOSI_v;
					sclk_clk <= sclk_out_v;
					finished <= fin;
					sclk_o <= sclk_c;
					end process;
					
					end behav;