library verilog;
use verilog.vl_types.all;
entity bit_shift_4 is
    port(
        clk             : in     vl_logic;
        d               : in     vl_logic;
        q               : out    vl_logic_vector(3 downto 0)
    );
end bit_shift_4;
