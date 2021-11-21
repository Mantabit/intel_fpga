library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity intel_fpga_1_1 is
port(
	CLOCK_50_B7A:		in			std_logic;
	LEDR:					out		std_logic_vector(9 downto 0);
	LEDG:					out		std_logic_vector(7 downto 0)
);
end intel_fpga_1_1;

architecture intel_fpga_1_1_arch of intel_fpga_1 is
	signal output : std_logic := '0';
	signal count : integer range 0 to 5000000 := 0;
begin
	counter : process(CLOCK_50_B7A)
	begin
		if CLOCK_50_B7A'event and CLOCK_50_B7A='1' then
			if count=(5000000-1) then
				count <= 0;
				output <= not output;
			else
				count <= count +1;
			end if;
		end if;
	end process;
	LEDR(0) <= output;
	LEDR(1) <= std_logic_vector(to_unsigned(count,23))(20);
	LEDG <= "11111111";
end intel_fpga_1_1_arch;