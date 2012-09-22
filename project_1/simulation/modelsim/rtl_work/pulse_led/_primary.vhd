library verilog;
use verilog.vl_types.all;
entity pulse_led is
    generic(
        period          : integer := 500000;
        step_size       : integer := 20000
    );
    port(
        clk             : in     vl_logic;
        led             : out    vl_logic
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of period : constant is 1;
    attribute mti_svvh_generic_type of step_size : constant is 1;
end pulse_led;
