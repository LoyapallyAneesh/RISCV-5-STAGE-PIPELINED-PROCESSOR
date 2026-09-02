`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 22.08.2026 17:52:08
// Design Name: 
// Module Name: data_memory
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


module data_memory(
input wire  clk,
input wire  mem_read,
input wire  mem_write,
input wire [31:0] address,
input wire [31:0] write_data,

output wire [31:0] read_data
);
reg [31:0] memory [0:255];
assign read_data = mem_read ? memory[address[9:2]] : 32'b0;
always @(posedge clk) begin
if (mem_write)
  memory[address[9:2]] <= write_data;
end

endmodule


endmodule
