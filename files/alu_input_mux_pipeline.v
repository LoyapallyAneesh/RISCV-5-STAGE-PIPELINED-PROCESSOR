`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 22.08.2026 18:11:26
// Design Name: 
// Module Name: alu_input_mux_pipeline
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


module alu_input_mux_pipeline(
input wire [31:0] forwarded_rs2,
input wire [31:0] immediate,
input wire alu_src,

output wire [31:0] alu_input_b
);

assign alu_input_b = alu_src ? immediate : forwarded_rs2;

endmodule