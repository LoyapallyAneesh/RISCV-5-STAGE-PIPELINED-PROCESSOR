`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 23.08.2026 10:37:43
// Design Name: 
// Module Name: ex_mem_reg
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


module ex_mem_reg(
input wire clk,
input wire reset,
input wire [31:0] alu_result_in,
input wire [31:0] rs2_data_in,
input wire [31:0] pc_in,
input wire [31:0] immediate_in,
input wire [4:0]  rd_in,
input wire reg_write_in,
input wire mem_read_in,
input wire mem_write_in,
input wire mem_to_reg_in,
input wire jal_in,
input wire lui_in,

output reg [31:0] alu_result_out,
output reg [31:0] rs2_data_out,
output reg [31:0] pc_out,
output reg [31:0] immediate_out,
output reg [4:0]  rd_out,
output reg reg_write_out,
output reg mem_read_out,
output reg mem_write_out,
output reg mem_to_reg_out,
output reg jal_out,
output reg lui_out
);
always @(posedge clk) begin
if (reset) begin
            alu_result_out   <= 32'b0;
            rs2_data_out     <= 32'b0;
            pc_out     <= 32'b0;
            immediate_out    <= 32'b0;
            rd_out           <= 5'b0;
            reg_write_out    <= 1'b0;
            mem_read_out     <= 1'b0;
            mem_write_out    <= 1'b0;
            mem_to_reg_out   <= 1'b0;
            jal_out          <= 1'b0;
            lui_out          <= 1'b0;
        end
else begin
            alu_result_out    <= alu_result_in;
            rs2_data_out      <= rs2_data_in;
            pc_out      <= pc_in;
            immediate_out     <= immediate_in;
            rd_out            <= rd_in;
            reg_write_out     <= reg_write_in;
            mem_read_out      <= mem_read_in;
            mem_write_out     <= mem_write_in;
            mem_to_reg_out    <= mem_to_reg_in;
            jal_out           <= jal_in;
            lui_out           <= lui_in;
        end
    end

endmodule

