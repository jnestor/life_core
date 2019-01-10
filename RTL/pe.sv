//-----------------------------------------------------------------------------
// Title         : pe - Processing Element for Conway's Life
// Project       : TSP - Tiled Spatial Processing (Life Prototype)
//-----------------------------------------------------------------------------
// File          : pe.v
// Author        : John Nestor
// Created       : 19.03.2013
// Last modified : 19.03.2013
//-----------------------------------------------------------------------------
// Description :
// Processing element module comprised of a single PE tile memoruy
// (pe_mem) and a combinational sequencer unit (pe_seq)
//-----------------------------------------------------------------------------
// Copyright (c) 2015 by John Nestor.
//------------------------------------------------------------------------------
// Modification history :
// 19.03.2013 : created
//-----------------------------------------------------------------------------

`include "pe_array_decs.sv"
`include "pe_decs.sv"

module pe (input clk, trigger, rst,
       input 		       rsel_i, csel_i, // used for opcodes
       input               vga_rsel, vga_csel, // used for the VGA display
       input [`PE_CMD_BITS-1:0]    cmd,
       output [`N_STATUS_BITS-1:0] status_out, // for communicating with neighbors
       input [`PE_STATE_BITS-1:0]  state_in,
       output reg [`PE_STATE_BITS-1:0] state_out, // for reading the PE
       output reg [`PE_STATE_BITS-1:0] vga_out,
       output 		       active, // for keeping track of activity in entire array - true when state changes

       input [`N_STATUS_BITS-1:0]  w_i, e_i, n_i, s_i, // manhattan neighbors
       input [`N_STATUS_BITS-1:0]  nw_i, ne_i, sw_i, se_i,    // diagonal neighbors
       output reg written // has a new value been written
       );

   // PE selection logic

   logic sel_i, vga_sel, nwritten;
   
   assign sel_i = rsel_i & csel_i;
   assign vga_sel = vga_rsel & vga_csel;
   
   
   // state memory for this PE

   logic [`PE_STATE_BITS-1:0] 	      state, nstate, nstate_out, nvga_out;


   // This functon should be modified for different PEs
   // the idea of putting it into a function is to limit other changes

    function [`PE_STATUS_BITS-1:0] status_from_state;
        input [`PE_STATE_BITS-1:0] state;
      
        status_from_state = state;  // status == state in Conway's Life, for example
      
    endfunction // status_from_state 
     
    assign              status_out = status_from_state(state);
   

   logic [3*`N_STATUS_BITS:0] 			 neighbor_count;

   assign neighbor_count = w_i + n_i + e_i + s_i
      + nw_i + ne_i + sw_i + se_i;


    always_ff @(posedge clk)
        if (rst) begin 
            state <= `PE_STATE_DEAD;
            state_out <= `PE_STATE_DEAD;
            vga_out <= `PE_STATE_DEAD;
            written <= 0;
        end
        else begin 
            state <= nstate;
            state_out <= nstate_out;
            vga_out <= nvga_out;
            written <= nwritten;
        end
         
    always_comb begin
        if(vga_sel)
            nvga_out = state;
        else
            nvga_out = 0;
       nstate_out = 0;
       nstate = state;
       nwritten = 0;
       case (cmd)
            `PE_CMD_NOP: begin
                    nstate = state;  // do nothing!
                end
            `PE_CMD_PROCESS: begin
                    if (!trigger) nstate = state; // do nothing
                    else if (neighbor_count < 2) nstate = `PE_STATE_DEAD;
                    else if (neighbor_count == 2) nstate = state;
                    else if (neighbor_count == 3) nstate = `PE_STATE_LIVE;
                    else nstate = `PE_STATE_DEAD;
                end
            `PE_CMD_WRITE:
                if (sel_i) begin
                    nstate = state_in;
                    nwritten = 1;
                end
                else begin
                    nstate = state;
                    nwritten = 0;
                end
            `PE_CMD_READ:
                if(sel_i) begin
                    nstate_out = state;
                end
            default: begin
                nstate = state;
                nstate_out = 0;
            end
        endcase // case(cmd)
   end // always_comb


   assign active = nstate != state;

endmodule // pe   