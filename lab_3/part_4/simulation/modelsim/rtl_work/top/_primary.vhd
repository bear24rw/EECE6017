library verilog;
use verilog.vl_types.all;
entity top is
    port(
        clk             : in     vl_logic;
        d               : in     vl_logic;
        qa              : out    vl_logic;
        qb              : out    vl_logic;
        qc              : out    vl_logic
    );
end top;
