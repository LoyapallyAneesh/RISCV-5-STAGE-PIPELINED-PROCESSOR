`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 27.08.2026 19:10:42
// Design Name: 
// Module Name: pc_mux2
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


module pc_mux2(
    input wire pc_mux2_control,
    input wire branch_taken,
    input wire [31:0] immediate,
    output reg [31:0] pc_mux2_output
);
always@(*)begin
      if(branch_taken || pc_mux2_control)
            pc_mux2_output = immediate;
      else
            pc_mux2_output =  32'd4 ;
      end 
endmodule
