library verilog;
use verilog.vl_types.all;
entity clk_div is
    port(
        clk_50mhz       : in     vl_logic;
        clk_1hz         : out    vl_logic
    );
end clk_div;
