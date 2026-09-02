`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 27.08.2026 19:04:47
// Design Name: 
// Module Name: pc_mux1
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


module pc_mux1(
    input wire [31:0] pc,
    input wire [31:0] rs1,
    input pc_mux1_control,
    output wire [31:0] pc_mux1_output
    );
assign pc_mux1_output = pc_mux1_control ? rs1 : pc;
    
endmodule
