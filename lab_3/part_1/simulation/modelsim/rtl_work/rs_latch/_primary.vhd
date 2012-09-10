library verilog;
use verilog.vl_types.all;
entity rs_latch is
    port(
        Clk             : in     vl_logic;
        R               : in     vl_logic;
        S               : in     vl_logic;
        Q               : out    vl_logic
    );
end rs_latch;
