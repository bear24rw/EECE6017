library verilog;
use verilog.vl_types.all;
entity bcd_sub is
    port(
        a_ones          : in     vl_logic_vector(3 downto 0);
        a_tens          : in     vl_logic_vector(3 downto 0);
        a_huns          : in     vl_logic_vector(3 downto 0);
        b_ones          : in     vl_logic_vector(3 downto 0);
        b_tens          : in     vl_logic_vector(3 downto 0);
        b_huns          : in     vl_logic_vector(3 downto 0);
        out_ones        : out    vl_logic_vector(3 downto 0);
        out_tens        : out    vl_logic_vector(3 downto 0);
        out_huns        : out    vl_logic_vector(3 downto 0);
        negative        : out    vl_logic
    );
end bcd_sub;
