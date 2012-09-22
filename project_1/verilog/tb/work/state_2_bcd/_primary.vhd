library verilog;
use verilog.vl_types.all;
entity state_2_bcd is
    port(
        state           : in     vl_logic_vector(3 downto 0);
        bcd_0           : out    vl_logic_vector(4 downto 0);
        bcd_1           : out    vl_logic_vector(4 downto 0);
        bcd_2           : out    vl_logic_vector(4 downto 0);
        bcd_3           : out    vl_logic_vector(4 downto 0)
    );
end state_2_bcd;
