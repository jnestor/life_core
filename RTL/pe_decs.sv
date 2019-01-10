`ifndef PE_DECS
 `define PE_DECS


`define N_STATE_BITS 1  // number of bits of PE state
`define N_STATUS_BITS 1    // number of bits in PE output

`define PE_STATE_LIVE 1'b1
`define PE_STATE_DEAD 1'b0
`define PE_RESET_STATE `PE_STATE_DEAD

`define PE_STATE_BITS 1
`define PE_STATUS_BITS 1

`define PE_CMD_BITS 3

`define PE_CMD_NOP 3'd0
`define PE_CMD_PROCESS 3'd1  // read pe memory, calculate next states, and
`define PE_CMD_READ 3'd2
`define PE_CMD_WRITE 3'd3
`define PE_CMD_RESET 3'd4

`endif
