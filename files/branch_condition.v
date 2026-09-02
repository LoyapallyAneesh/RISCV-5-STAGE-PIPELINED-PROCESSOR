`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 21.08.2026 05:44:52
// Design Name: 
// Module Name: branch_condition
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


module branch_condition(
input  wire branch,
input  wire branch_ne,
input  wire zero,

output wire branch_taken
);

assign branch_taken = branch &&((!branch_ne && zero) ||( branch_ne && !zero));

endmodule
