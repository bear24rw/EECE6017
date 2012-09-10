library verilog;
use verilog.vl_types.all;
entity top is
    generic(
        STATE_IDLE      : integer := 0;
        STATE_DOT       : integer := 1;
        STATE_DASH_1    : integer := 2;
        STATE_DASH_2    : integer := 3;
        STATE_DASH_3    : integer := 4;
        A               : vl_logic_vector(0 to 3) := (Hi0, Hi0, Hi0, Hi0);
        B               : vl_logic_vector(0 to 3) := (Hi0, Hi0, Hi0, Hi1);
        C               : vl_logic_vector(0 to 3) := (Hi0, Hi0, Hi1, Hi0);
        D               : vl_logic_vector(0 to 3) := (Hi0, Hi0, Hi1, Hi1);
        E               : vl_logic_vector(0 to 3) := (Hi0, Hi1, Hi0, Hi0);
        F               : vl_logic_vector(0 to 3) := (Hi0, Hi1, Hi0, Hi1);
        G               : vl_logic_vector(0 to 3) := (Hi0, Hi1, Hi1, Hi0);
        H               : vl_logic_vector(0 to 3) := (Hi0, Hi1, Hi1, Hi1)
    );
    port(
        clk             : in     vl_logic;
        reset           : in     vl_logic;
        send            : in     vl_logic;
        letter          : in     vl_logic_vector(3 downto 0);
        led             : out    vl_logic
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of STATE_IDLE : constant is 1;
    attribute mti_svvh_generic_type of STATE_DOT : constant is 1;
    attribute mti_svvh_generic_type of STATE_DASH_1 : constant is 1;
    attribute mti_svvh_generic_type of STATE_DASH_2 : constant is 1;
    attribute mti_svvh_generic_type of STATE_DASH_3 : constant is 1;
    attribute mti_svvh_generic_type of A : constant is 1;
    attribute mti_svvh_generic_type of B : constant is 1;
    attribute mti_svvh_generic_type of C : constant is 1;
    attribute mti_svvh_generic_type of D : constant is 1;
    attribute mti_svvh_generic_type of E : constant is 1;
    attribute mti_svvh_generic_type of F : constant is 1;
    attribute mti_svvh_generic_type of G : constant is 1;
    attribute mti_svvh_generic_type of H : constant is 1;
end top;
