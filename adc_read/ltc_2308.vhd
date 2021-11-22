library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ltc_2308 is
port(
    clk_40M     :   in      std_logic;
    adcout      :   out     unsigned(11 downto 0);
    sdi         :   out     std_logic;
    sdo         :   out     std_logic;
    adcclk      :   out     std_logic;
    convst:     :   out     std_logic;
);
end ltc_2308;

architecture ltc_2308_arch of ltc_2308 is
    signal s_counter : unsigned(6 downto 0) := (others=>'0');
    constant c_counter_max : unsigned(6 downto 0) := to_unsigned(40,7);
    -- number of clk cycles convst needs to be held high
    constant c_clkcyc_convst : unsigned(6 downto 0) := to_unsigned(128,7);
    -- number of clock cycle when adcclk gets enabled
    constant c_adc_start : unsigned(6 downto 0) := to_unsigned(128+10,7);
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
	end process;
    -- adcclk
    adcclk : process(clk_40M)
    begin
        if clk_40M'event then
            if s_counter>=c_adc_start and s_counter<(c_adc_start+to_unsigned(24)) then
                adcclk <= not adcclk;
            end if;
        end if;
    end process;
    -- drive the adc inputs and read adc outputs
    adc_driving : process(s_counter)
    begin
        if s_counter<c_clkcyc_convst then
            convst <= '1';
            adcclk <= '0';
            sdi <= c_sd;
            s_adcclken <= '0';
        elsif s_counter<c_adc_start then
            convst <= '0';
            adcclk <= '0';
            sdi <= c_sd;
            s_adcclken <= '0';
        else
            case s_counter is
                when to_unsigned(128,7);    =>  convst <= '0';
                                                adcclk <= '0';
                                                sdi <= c_sd;
                when others => ;
            end case;
        end if;
    end process;
end ltc_2308_arch;