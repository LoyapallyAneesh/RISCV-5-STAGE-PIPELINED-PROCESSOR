`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 22.08.2026 18:28:38
// Design Name: 
// Module Name: pc_adder
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


module pc_adder(
input wire [31:0] pc_mux1,
input wire [31:0] pc_mux2,
input jalr,

output wire [31:0] pc_next
);

assign pc_next= jalr ?((pc_mux1 + pc_mux2)&32'hFFFFFFFE): (pc_mux1 + pc_mux2);

endmodule


