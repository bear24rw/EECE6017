`ifndef _constants_h_
`define _constants_h_

// uncomment the following line to change the 1Hz clock
// to only toggle every 5 system clocks. this allows
// for faster simulation
//`define SIMULATION 1

// temperature state aliases
`define STATE_NORMAL        2'd0
`define STATE_BORDERLINE    2'd1
`define STATE_ATTENTION     2'd2
`define STATE_EMERGENCY     2'd3

// bcd digit input states for the FSM
`define INPUT_STATE_DONE    2'd0
`define INPUT_STATE_ONES    2'd1
`define INPUT_STATE_TENS    2'd2
`define INPUT_STATE_HUNS    2'd3

// 7-segment display states for the FSM
`define DISP_MODE_TEMP      2'd0
`define DISP_MODE_DELTA     2'd1
`define DISP_MODE_STATE     2'd2

// bcd lookup table for the 7-segment driver
`define BCD_0       5'h0
`define BCD_1       5'h1
`define BCD_2       5'h2
`define BCD_3       5'h3
`define BCD_4       5'h4
`define BCD_5       5'h5
`define BCD_6       5'h6
`define BCD_7       5'h7
`define BCD_8       5'h8
`define BCD_9       5'h9
`define BCD_A       5'hA
`define BCD_B       5'hB
`define BCD_C       5'hC
`define BCD_D       5'hD
`define BCD_E       5'hE
`define BCD_F       5'hF
`define BCD_G       5'h10
`define BCD_L       5'h11 
`define BCD_N       5'h12
`define BCD_O       5'h13
`define BCD_R       5'h14
`define BCD_T       5'h15
`define BCD_NEG     5'h16
`define BCD_BLANK   5'h17

`endif

// vim: set filetype=verilog:
