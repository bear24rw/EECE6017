library verilog;
use verilog.vl_types.all;
entity d_flop is
    port(
        clk             : in     vl_logic;
        clr             : in     vl_logic;
        d               : in     vl_logic;
        q               : out    vl_logic
    );
end d_flop;
