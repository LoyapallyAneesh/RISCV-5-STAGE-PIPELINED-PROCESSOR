`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 22.08.2026 18:07:58
// Design Name: 
// Module Name: hazard_detection_unit
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


module hazard_detection_unit(
input wire [4:0] id_rs1,
input wire [4:0] id_rs2,
input wire [4:0] id_ex_rd,
input wire id_ex_mem_read,

output reg pc_write,
output reg if_id_write,
output reg control_stall
);
always @(*) begin
// Normal operation
pc_write      = 1'b1;
if_id_write   = 1'b1;
control_stall = 1'b0;
// LOAD-USE HAZARD
if (id_ex_mem_read &&(id_ex_rd != 5'b0) &&((id_ex_rd == id_rs1) ||(id_ex_rd == id_rs2))) begin
pc_write      = 1'b0;
if_id_write   = 1'b0;
control_stall = 1'b1;
end
end

endmodule

