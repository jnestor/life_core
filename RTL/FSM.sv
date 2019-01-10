`timescale 1ns / 1ps
`include "pe_array_decs.sv"
`include "pe_decs.sv"
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/29/2015 02:30:39 PM
// Design Name: 
// Module Name: FSM
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


module FSM(
    input clk,
    input trigger,
    input enb,
    input run,
    input reset,
    output logic [`N_PX_BITS-1:0] x,
    output logic [`N_PY_BITS-1:0] y,
    output logic [`PE_CMD_BITS-1:0] cmd,
    output logic [`PE_STATE_BITS-1:0] val
    );
    
    parameter DEFAULT = 4'b0000, RUN = 4'hF;
    
    logic [3:0] state, next_state;
    
    always_ff @(posedge clk) begin
        if(reset) state <= DEFAULT;
        else if(run & trigger) state <= RUN;
        else state <= next_state;;
    end
    
    always_comb begin
        if(state == RUN) next_state = DEFAULT;
        if(state == DEFAULT) next_state = enb ? 4'b1 : DEFAULT;
        else if (state == 4'd13) next_state = DEFAULT;
        else next_state = state + 1;
    end
    
    always_comb begin
        case(state)
            DEFAULT: begin
                x = 0;
                y = 0;
                cmd = `PE_CMD_NOP;
                val = 0;
            end
            
            4'b0001: begin
                x = 5;
                y = 5;
                cmd = `PE_CMD_WRITE;
                val = 1;
            end
            4'b0010: begin        
                x = 5;            
                y = 6;            
                cmd = `PE_CMD_WRITE;
                val = 1;          
            end
            4'b0011: begin        
                x = 6;            
                y = 5;            
                cmd = `PE_CMD_WRITE;
                val = 1;          
            end                   
            4'b0100: begin        
                x = 6;            
                y = 6;            
                cmd = `PE_CMD_WRITE;
                val = 1;          
            end                   
            4'b0101: begin        
                x = 6;            
                y = 8;            
                cmd = `PE_CMD_WRITE;
                val = 1;          
            end                   
            4'b0110: begin        
                x = 7;            
                y = 9;            
                cmd = `PE_CMD_WRITE;
                val = 1;          
            end                   
            4'b0111: begin        
                x = 9;            
                y = 9;            
                cmd = `PE_CMD_WRITE;
                val = 1;          
            end                   
            4'b1000: begin        
                x = 4'hA;            
                y = 9;            
                cmd = `PE_CMD_WRITE;
                val = 1;          
            end                   
            4'b1001: begin        
                x = 4'hA;            
                y = 4'hA;            
                cmd = `PE_CMD_WRITE;
                val = 1;          
            end                   
            4'b1010: begin        
                x = 9;            
                y = 4'hA;            
                cmd = `PE_CMD_WRITE;
                val = 1;          
            end                   
            4'b1011: begin        
                x = 9;            
                y = 7;            
                cmd = `PE_CMD_WRITE;
                val = 1;          
            end                   
            4'b1100: begin        
                x = 8;            
                y = 6;            
                cmd = `PE_CMD_WRITE;
                val = 1;          
            end
            4'b1111: begin
                x = 0;
                y = 0;
                cmd = `PE_CMD_PROCESS;
                val = 0;
            end                                     
            default: begin        
                x = 0;            
                y = 0;            
                cmd = `PE_CMD_NOP;
                val = 0;          
            end                                      
        endcase
    end
    
endmodule
