library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ltc_2308 is
port(
    clk_40M     :   in      std_logic;
    adcout      :   out     unsigned(11 downto 0);
    sdi         :   out     std_logic;
    sdo         :   in      std_logic;
    adcclk      :   out     std_logic;
    convst      :   out     std_logic
);
end ltc_2308;

architecture ltc_2308_arch of ltc_2308 is
    signal s_counter : unsigned(6 downto 0) := (others=>'0');
    signal s_adcclkcounter : unsigned(3 downto 0) := (others=>'0');
    signal s_adcclk : std_logic := '0';
    signal s_adcactive : boolean := false;
    constant c_counter_max : unsigned(6 downto 0) := to_unsigned(80,7);
    -- number of clk cycles convst needs to be held high
    constant c_clkcyc_convst : unsigned(6 downto 0) := to_unsigned(64,7);
    -- number of clock cycle when adcclk gets enabled
    constant c_adc_start : unsigned(6 downto 0) := to_unsigned(65,7);
    -- sdi data
    constant c_sd : std_logic := '0';
    constant c_os : std_logic := '0';
    constant c_s1 : std_logic := '0';
    constant c_s0 : std_logic := '0';
    constant c_uni : std_logic := '0';
    constant c_slp : std_logic := '0';
begin
    -- counter incrementation
	counter : process(clk_40M)
	begin
		if clk_40M'event and clk_40M='1' then
			if s_counter=c_counter_max then
				s_counter <= (others=>'0');
			else
				s_counter <= s_counter+1;
			end if;
		end if;
        report "s_counter: " & integer'image(to_integer(s_counter));
	end process;
    -- adcclk feed through
    adcclkfeed : process(clk_40M)
    begin
        s_adcactive <= s_counter>=c_adc_start and s_counter<(c_adc_start+to_unsigned(11,7));
        report "adc active: " & boolean'image(s_adcactive);
        if clk_40M'event then
            if s_adcactive then
                s_adcclk <= not s_adcclk;
            end if;
        end if;
    end process;
    -- adcclk
    adcclk <= s_adcclk;
    -- drive the adc inputs and read adc outputs
    adc_driving : process(s_counter)
    begin
        if s_counter<c_clkcyc_convst+1 then
            convst <= '1';
            sdi <= c_sd;
        else
            convst <= '0';
            case s_adcclkcounter is
                when "0000" =>   sdi <= c_sd;
                when "0001" =>   sdi <= c_os;
                when "0010" =>   sdi <= c_s1;
                when "0011" =>   sdi <= c_s0;
                when "0100" =>   sdi <= c_uni;
                when "0101" =>   sdi <= c_slp;
                when others =>   sdi <= 'X';
            end case;
        end if;
    end process;
    -- adc output read & adcclkcounter
    adcoutread : process(s_adcclk)
    begin
        if(s_adcclk'event and s_adcclk='1') then
            adcout(to_integer(s_adcclkcounter)) <= sdo;
            s_adcclkcounter <= s_adcclkcounter+1;
        end if;
    end process;
end ltc_2308_arch;