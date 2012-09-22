library verilog;
use verilog.vl_types.all;
entity seven_seg is
    port(
        en              : in     vl_logic;
        value           : in     vl_logic_vector(4 downto 0);
        seg             : out    vl_logic_vector(6 downto 0)
    );
end seven_seg;
