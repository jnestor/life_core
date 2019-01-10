`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/20/2015 07:34:08 PM
// Design Name: 
// Module Name: Timer
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


module Timer(
    input clk,
    output reg trigger
    );
    
    parameter COUNT_MAX = 1000;
    reg [31:0] count;
    
    always @(posedge clk) begin
        count <= count + 1;
        if (count == COUNT_MAX) begin
            trigger <= 1;
            count <= 0;
        end
        else trigger <= 0;
   end
   
endmodule
