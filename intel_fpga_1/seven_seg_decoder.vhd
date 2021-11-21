library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity seven_seg_decoder is
	generic
	(
		N	: integer  :=	4
	);
	port
	(
		-- Input ports
		number	: 		in  integer range 0 to 9999 := 0;
		CLOCK_50_B7A: 	in std_logic;
		-- Output ports
		HEX0	: out std_logic_vector(6 downto 0) := (others=>'0');
		HEX1	: out std_logic_vector(6 downto 0) := (others=>'0');
		HEX2	: out std_logic_vector(6 downto 0) := (others=>'0');
		HEX3	: out std_logic_vector(6 downto 0) := (others=>'0');
		LEDR	: out std_logic_vector(9 downto 0) := (others=>'0');
		LEDG	: out std_logic_vector(7 downto 0) := (others=>'0')
	);
end entity;

architecture seven_seg_decoder_arch of seven_seg_decoder is

	signal count : unsigned (27 downto 0) := (others => '0');
	signal count_bcd : std_logic_vector(11 downto 0) := (others=>'0');
	constant count_limit : unsigned(27 downto 0) := (others => '1');
	-- function to convert to BCD format
	-- input : 8 bit integer
	-- output : 12 bit BCD number
	function to_bcd ( bin : unsigned(7 downto 0) ) return std_logic_vector is
		variable i : integer:=0;
		variable bcd : unsigned(11 downto 0) := (others => '0');
		variable bint : unsigned(7 downto 0) := bin;
	begin
		for i in 0 to 7 loop  -- repeating 8 times.
			bcd(11 downto 1) := bcd(10 downto 0);  --shifting the bits.
			bcd(0) := bint(7);
			bint(7 downto 1) := bint(6 downto 0);
			bint(0) :='0';
			if(i < 7 and bcd(3 downto 0) > "0100") then --add 3 if BCD digit is greater than 4.
			bcd(3 downto 0) := bcd(3 downto 0) + "0011";
			end if;
			if(i < 7 and bcd(7 downto 4) > "0100") then --add 3 if BCD digit is greater than 4.
			bcd(7 downto 4) := bcd(7 downto 4) + "0011";
			end if;
			if(i < 7 and bcd(11 downto 8) > "0100") then  --add 3 if BCD digit is greater than 4.
			bcd(11 downto 8) := bcd(11 downto 8) + "0011";
			end if;
		end loop;
		return std_logic_vector(bcd);
	end to_bcd;

begin
	-- incrementation process
	counter : process(CLOCK_50_B7A)
	begin
		if(CLOCK_50_B7A'event and CLOCK_50_B7A='1') then
			if(count=count_limit) then
				count<=(others=>'0');
			else
				count<=count+1;
			end if;
		end if;
	end process;
	-- bcd conversion process
	compute_bcd : process(count)
	begin
		count_bcd <= to_bcd(count(27 downto 20));
	end process;
	-- hex output settings process
	drive_hexs : process(count_bcd)
	begin
		case count_bcd(11 downto 8) is
			 when "0000" => HEX2 <= "1000000"; -- "0"     
			 when "0001" => HEX2 <= "1111001"; -- "1" 
			 when "0010" => HEX2 <= "0100100"; -- "2" 
			 when "0011" => HEX2 <= "0000110"; -- "3" 
			 when "0100" => HEX2 <= "1001100"; -- "4" 
			 when "0101" => HEX2 <= "0100100"; -- "5" 
			 when "0110" => HEX2 <= "0100000"; -- "6" 
			 when "0111" => HEX2 <= "0001111"; -- "7" 
			 when "1000" => HEX2 <= "0000000"; -- "8"     
			 when "1001" => HEX2 <= "0000100"; -- "9" 
			 when "1010" => HEX2 <= "0000010"; -- a
			 when "1011" => HEX2 <= "1100000"; -- b
			 when "1100" => HEX2 <= "0110001"; -- C
			 when "1101" => HEX2 <= "1000010"; -- d
			 when "1110" => HEX2 <= "0000110"; -- E
			 when "1111" => HEX2 <= "0001110"; -- F
		end case;
	end process;

	-- default outputs
	LEDG(3 downto 0) <= std_logic_vector(count(27 downto 24));
	LEDG(7 downto 4) <= "1111";
	LEDR <= (others=>'1');
	HEX3 <= (others=>'1');
	HEX1 <= (others=>'1');
	HEX0 <= (others=>'1');

end seven_seg_decoder_arch;