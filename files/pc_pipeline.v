`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 23.08.2026 10:33:09
// Design Name: 
// Module Name: pc_pipeline
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


module pc_pipeline(
input wire clk,
input wire reset,
input wire stall,
input wire [31:0] next_pc,

output reg [31:0] current_pc
);
always @(posedge clk) begin
if (reset)
    current_pc <= 32'b0;
else if (!stall)
    current_pc <= next_pc;
// else: Hold PC during stall
end

endmodule