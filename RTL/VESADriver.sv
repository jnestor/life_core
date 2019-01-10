`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Signal Generator for VESA (1280x1024 VGA)
// Generates Hsync and Vsync signals
// Outputs current screen X and Y coordinates for use elsewhere
//  Keep in mind that computer geometry's origin is at the top-left, and 
//  positive-y is down. 
// Timings from http://tinyvga.com/vga-timing/800x600@72Hz, assuming a 50Mhz clock.
//////////////////////////////////////////////////////////////////////////////////
module VESADriver(
		  input clk,
		  output reg Hsyncb,
		  output reg Vsyncb,
		  output [10:0] x,
		  output reg [10:0] y = 0
		  );

   parameter 		 HLEN             = 11'd1280;
   parameter 		 HFRONT_PORCH_LEN = 11'd48;
   parameter 		 HSYNC_WIDTH      = 11'd112;
   parameter 		 HBACK_PORCH_LEN  = 11'd248;
   parameter 		 HTOTAL           = 11'd1688;
 		 
   
   parameter 		 VHEIGHT          = 11'd1024;
   parameter  		 VFRONT_PORCH_LEN = 11'd1;
   parameter 		 VSYNC_LEN        = 11'd3; 
   parameter 		 VBACK_PORCH_LEN  = 11'd38;
   parameter 		 VTOTAL           = 11'd1066;
 		 
   
   //The back porch requires 11 bits of x, but only 10
   //bits are needed to address the screen. 
   //Slicing off the last bit makes X and Y have the same 
   //dimension, bitwise. It's a bit nicer to work with. 
   reg [10:0] 		 xinternal = 0;
   assign 		 x = xinternal;
   
   assign 		 Hsync = ~((xinternal > HLEN + HFRONT_PORCH_LEN)
				   && (xinternal < HLEN + HFRONT_PORCH_LEN + HSYNC_WIDTH));
   assign 		 Vsync = ~((y > VHEIGHT + VFRONT_PORCH_LEN)
				   && (y < VHEIGHT + VFRONT_PORCH_LEN + VSYNC_LEN));
   assign 		 frame = (xinternal == HTOTAL-1 && y == VTOTAL-1);
   
   always @(posedge clk) begin
      Hsyncb <= Hsync;
      Vsyncb <= Vsync;
      
      if (xinternal == HTOTAL-1 && y != VTOTAL-1) begin
			 xinternal <= 0;
			 y <= y+1;
      end
      else xinternal<= xinternal+1;
      
      if (xinternal == HTOTAL-1 &&y == VTOTAL-1) begin
			 y <= 0;
			 xinternal <= 0;
      end
   end
   
endmodule
