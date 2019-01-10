`include "pe_array_decs.sv"
`include "pe_decs.sv"

// Non-tiled version - Conway's game of Life using generate

module pe_array ( input                       clk,
          input trigger,
 		  input [`PE_CMD_BITS-1:0]    cmd,
		  input [`PE_STATE_BITS-1:0]  state_in,
		  output logic [`PE_STATE_BITS-1:0] state_out,
		  output logic [`PE_STATE_BITS-1:0] vga_out,
		  output logic		      active,
		  output logic            written,
		  input [`N_PX_BITS-1:0]      adr_x_i,
		  input [`N_PY_BITS-1:0]      adr_y_i,
          input [`N_PX_BITS-1:0]      adr_x_vga,
          input [`N_PY_BITS-1:0]      adr_y_vga
		  );

   // reset logic
   assign reset = (cmd == `PE_CMD_RESET);

   genvar i, j;

   logic [`N_PX+2-1:0][`N_PY+2-1:0][`N_STATUS_BITS-1:0] status_a;  // use oversized array to connect edges!!!
   logic [`N_PX-1:0][`N_PY-1:0] active_a;
   logic [`N_PX-1:0][`N_PY-1:0][`PE_STATE_BITS-1:0] state_out_a; 
   logic [`N_PX-1:0][`N_PY-1:0][`PE_STATE_BITS-1:0] vga_out_a; 
   logic [`N_PX-1:0][`N_PY-1:0] written_a; 


    // Input selector
    logic [`N_PX-1:0] 		csel_i;
    logic [`N_PY-1:0] 		rsel_i;

    logic [`N_PX-1:0] 		csel_vga;
    logic [`N_PY-1:0] 		rsel_vga;
   

    // row decoder logic
    generate
        for (i=0; i<`N_PX; i=i+1) begin
            assign csel_i[i] = (adr_x_i == i);
            assign csel_vga[i] = (adr_x_vga == i);
        end
    endgenerate

    // col decoder logic
    generate
        for (i=0; i<`N_PY; i=i+1) begin
            assign rsel_i[i] = (adr_y_i == i);
            assign rsel_vga[i] = (adr_y_vga == i);
        end
    endgenerate

    generate
        for (i=1; i<`N_PX+1; i=i+1) // build column-by-column
	    begin: col
	        for (j=1; j<`N_PY+1; j=j+1) // instantiate cells in each column
	        begin : row
		    pe PE_INST (
		                .clk(clk),
		                .trigger(trigger),
		                .rst(reset),
		                .rsel_i(rsel_i[(j-1)]),
		                .csel_i(csel_i[(i-1)]),
                        .vga_rsel(rsel_vga[(j-1)]),
                        .vga_csel(csel_vga[(i-1)]),
                        .cmd(cmd),
		      	        .status_out(status_a[(i)][(j)]),
		      	        .state_in(state_in),
		                .state_out(state_out_a[(i-1)][(j-1)]),
		      	        .active(active_a[(i-1)][(j-1)]),
		      	        .vga_out(vga_out_a[(i-1)][(j-1)]),
		      	        .w_i(status_a[i-1][j]),
		      	        .n_i(status_a[i][j-1]),
		      	        .e_i(status_a[i+1][j]),
		      	        .s_i(status_a[i][j+1]),
		      	        .nw_i(status_a[i-1][j-1]),
		      	        .ne_i(status_a[i+1][j-1]),
		      	        .se_i(status_a[i+1][j+1]),
		      	        .sw_i(status_a[i-1][j+1]),
		      	        .written(written_a[i-1][j-1])
	                    );
		  end
	    end
    endgenerate


    generate
        for (i=0; i<`N_PX+2; i=i+1) begin
            assign status_a[i][0] = 1'b0;   // top edge and corners
	        assign status_a[i][`N_PY+1] = 1'b0;  // bottom edge and corners
        end
    endgenerate

    generate
        for (j=1; j<`N_PY+2; j=j+1) begin
	       assign status_a[0][j] = 1'b0;   // left edge
	       assign status_a[`N_PX+1][j] = 1'b0;  // right edge
        end
    endgenerate

    // OR together active and state_out signals from PEs to get active output

    always_comb
        begin
	       integer i, j;
	       active = 0;
	       state_out = 0;
	       written = 0;
	       for (i=0; i<`N_PX; i=i+1) begin
	           for (j=0; j<`N_PY; j=j+1) begin
	               active = active | active_a[i][j];
	               state_out = state_out | state_out_a[i][j];
	               written = written | written_a[i][j];
	           end
	       end
        end
     
     // OR together the VGA output to get the value at the current cell
     always_comb
         begin
            integer i, j;
            vga_out = 0;
            for (i=0; i<`N_PX; i=i+1) begin
                for (j=0; j<`N_PY; j=j+1) begin
                    vga_out = vga_out | vga_out_a[i][j];
                end
            end
         end
     
      
endmodule // pe_array

