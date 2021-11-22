library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ltc_2308_tb is

end ltc_2308_tb;

architecture ltc_2308_tb_arch of ltc_2308_tb is
    component ltc_2308 is
        port(
            clk_40M     :   in      std_logic;
            adcout      :   out     unsigned(11 downto 0);
            sdi         :   out     std_logic;
            sdo         :   in      std_logic;
            adcclk      :   out     std_logic;
            convst      :   out     std_logic
        );
        end component;
        signal clk_tb,sdi_tb,sdo_tb,adcclk_tb,convst_tb : std_logic;
        signal adcout_tb : unsigned(11 downto 0) := (others=>'0');
begin
    dut : ltc_2308 port map(clk_tb,adcout_tb,sdi_tb,sdo_tb,adcclk_tb,convst_tb);

    clk_proc : process
    begin
        clk_tb <= '0';
        wait for 25ns;
        clk_tb <= '1';
        wait for 25ns;
    end process;

    sdo_tb <= '1';

end ltc_2308_tb_arch;