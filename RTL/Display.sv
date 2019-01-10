`timescale 1ns / 1ps
`include "pe_array_decs.sv"
`include "pe_decs.sv"
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/23/2015 11:19:05 AM
// Design Name: 
// Module Name: Display_4x4
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


module Display(
    input [10:0] x,
    input [10:0] y,
    input [`PE_STATE_BITS-1:0] state,
    output [11:0] rgb,
    output [`N_PX_BITS-1:0] x_array,
    output [`N_PY_BITS-1:0] y_array
    );
    
    logic [11:0] color;
    
    assign out_of_range = x[10] == 1'b1 || y[10] == 1'b1;
    
    assign rgb = ~out_of_range ? color : 0;
    
    assign x_array = x[9:9-`N_PX_BITS+1];
    assign y_array = y[9:9-`N_PX_BITS+1];
    
    always_comb begin
        case(state)
        `PE_STATE_LIVE:
            color = 12'hFFF;
        `PE_STATE_DEAD:
            color = 12'h000;
        default:
            color = 12'h000;
        endcase
    end

            
    
endmodule
