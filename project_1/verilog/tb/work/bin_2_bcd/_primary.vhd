library verilog;
use verilog.vl_types.all;
entity bin_2_bcd is
    port(
        bin             : in     vl_logic_vector(11 downto 0);
        huns            : out    vl_logic_vector(3 downto 0);
        tens            : out    vl_logic_vector(3 downto 0);
        ones            : out    vl_logic_vector(3 downto 0)
    );
end bin_2_bcd;
