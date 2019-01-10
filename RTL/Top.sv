`timescale 1ns / 1ps
`include "pe_array_decs.sv"
`include "pe_decs.sv"
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/22/2015 04:50:06 PM
// Design Name: 
// Module Name: Top
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module Top(
    input clk,
    input [`N_PX_BITS-1:0] adr_x,
    input [`N_PY_BITS-1:0] adr_y,
    input [`PE_CMD_BITS-1:0] opcode,
    input [`PE_STATE_BITS-1:0] vali,
    output [`PE_STATE_BITS-1:0] valo,
    output [3:0] red,
    output [3:0] green,
    output [3:0] blue,
    output Hsync, Vsync, written
    );
    
    logic [1:0] cmd;
    wire [10:0] x,y;
    wire [`N_PX_BITS-1:0] vga_x;
    wire [`N_PY_BITS-1:0] vga_y;
   
    
    
    wire [`PE_STATE_BITS-1:0] vga_out;
        
    // Trigger for delayed signal
    Timer #(.COUNT_MAX(100000000)) timer (.clk(clk),.trigger(trigger));
         
        
    
    pe_array ARRAY (.clk(clk),
                    .trigger(trigger),
                    .cmd(opcode),
                    .adr_x_i(adr_x),
                    .adr_y_i(adr_y),
                    .adr_x_vga(vga_x),
                    .adr_y_vga(vga_y),
                    .state_in(vali),
                    .active(active),
                    .state_out(valo),
                    .vga_out(vga_out),
                    .written(written)
                    );
                    
    VESADriver vga_driver (.clk(clk),
                           .Hsyncb(Hsync),
                           .Vsyncb(Vsync),
                           .x(x),
                           .y(y)
                           );
                          
    Display display (.x(x),
                     .y(y),
                     .state(vga_out),
                     .rgb({red,green,blue}),
                     .x_array(vga_x),
                     .y_array(vga_y)
                     );
   


                    
endmodule
