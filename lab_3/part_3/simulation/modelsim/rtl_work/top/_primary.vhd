library verilog;
use verilog.vl_types.all;
entity top is
    port(
        SW_0            : in     vl_logic;
        SW_1            : in     vl_logic;
        LED_R0          : out    vl_logic
    );
end top;
