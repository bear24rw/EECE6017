module top (
    input clk, reset, w,
    output z
);

    reg [3:0] next_state;
    reg [3:0] cur_state;

    parameter 
            A = 4'b0000,
            B = 4'b0001,
            C = 4'b0010,
            D = 4'b0011,
            E = 4'b0100,
            F = 4'b0101,
            G = 4'b0110,
            H = 4'b0111,
            I = 4'b1000;

    always @(w, cur_state) 
    begin: state_table

        case (cur_state)
            A:
                if (~w) next_state = B;
                else next_state = F;

        
            B:
                if (~w) next_state = C;
                else next_state = F;
            C:
                if (~w) next_state = D;
                else next_state = F;
            D:
                if (~w) next_state = E;
                else next_state = F;
            E:
                if (w) next_state = F;


            F:
                if (w) next_state = G;
                else next_state = B;
            G:
                if (w) next_state = H;
                else next_state = B;
            H:
                if (w) next_state = I;
                else next_state = B;
            I:
                if (~w) next_state = B;

            default:
                next_state = A;

        endcase
    end

    always @(posedge clk)
    begin: state_FFs
        if (reset)
            cur_state <= A;
        else
            cur_state <= next_state;
    end

    assign z = (cur_state == E) || (cur_state == I) ? 1'b1:1'b0;

endmodule
