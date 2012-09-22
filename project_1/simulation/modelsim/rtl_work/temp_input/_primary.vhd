library verilog;
use verilog.vl_types.all;
entity temp_input is
    port(
        rst             : in     vl_logic;
        enter           : in     vl_logic;
        value           : in     vl_logic_vector(3 downto 0);
        current_value   : out    vl_logic_vector(3 downto 0);
        state           : out    vl_logic_vector(1 downto 0);
        temp_value_ones : out    vl_logic_vector(3 downto 0);
        temp_value_tens : out    vl_logic_vector(3 downto 0);
        temp_value_huns : out    vl_logic_vector(3 downto 0)
    );
end temp_input;
