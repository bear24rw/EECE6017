library verilog;
use verilog.vl_types.all;
entity top is
    generic(
        A               : vl_logic_vector(0 to 3) := (Hi0, Hi0, Hi0, Hi0);
        B               : vl_logic_vector(0 to 3) := (Hi0, Hi0, Hi0, Hi1);
        C               : vl_logic_vector(0 to 3) := (Hi0, Hi0, Hi1, Hi0);
        D               : vl_logic_vector(0 to 3) := (Hi0, Hi0, Hi1, Hi1);
        E               : vl_logic_vector(0 to 3) := (Hi0, Hi1, Hi0, Hi0);
        F               : vl_logic_vector(0 to 3) := (Hi0, Hi1, Hi0, Hi1);
        G               : vl_logic_vector(0 to 3) := (Hi0, Hi1, Hi1, Hi0);
        H               : vl_logic_vector(0 to 3) := (Hi0, Hi1, Hi1, Hi1);
        I               : vl_logic_vector(0 to 3) := (Hi1, Hi0, Hi0, Hi0)
    );
    port(
        clk             : in     vl_logic;
        reset           : in     vl_logic;
        w               : in     vl_logic;
        z               : out    vl_logic
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of A : constant is 1;
    attribute mti_svvh_generic_type of B : constant is 1;
    attribute mti_svvh_generic_type of C : constant is 1;
    attribute mti_svvh_generic_type of D : constant is 1;
    attribute mti_svvh_generic_type of E : constant is 1;
    attribute mti_svvh_generic_type of F : constant is 1;
    attribute mti_svvh_generic_type of G : constant is 1;
    attribute mti_svvh_generic_type of H : constant is 1;
    attribute mti_svvh_generic_type of I : constant is 1;
end top;
