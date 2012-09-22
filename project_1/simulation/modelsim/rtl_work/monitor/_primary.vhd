library verilog;
use verilog.vl_types.all;
entity monitor is
    port(
        clk             : in     vl_logic;
        rst             : in     vl_logic;
        en              : in     vl_logic;
        mode            : in     vl_logic;
        temp_value_ones : in     vl_logic_vector(3 downto 0);
        temp_value_tens : in     vl_logic_vector(3 downto 0);
        temp_value_huns : in     vl_logic_vector(3 downto 0);
        temp_value_sign : out    vl_logic;
        temp_delta_ones : out    vl_logic_vector(3 downto 0);
        temp_delta_tens : out    vl_logic_vector(3 downto 0);
        temp_delta_huns : out    vl_logic_vector(3 downto 0);
        temp_delta_sign : out    vl_logic;
        state           : out    vl_logic_vector(3 downto 0)
    );
end monitor;
