`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 23.08.2026 10:39:13
// Design Name: 
// Module Name: id_ex_reg
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


module id_ex_reg(
input wire clk,
input wire reset,
input wire flush,
// Data
input wire [31:0] pc_in,
input wire [31:0] rs1_data_in,
input wire [31:0] rs2_data_in,
input wire [31:0] immediate_in,
input wire [4:0]  rs1_in,
input wire [4:0]  rs2_in,
input wire [4:0]  rd_in,
// Control
input wire reg_write_in,
input wire mem_read_in,
input wire mem_write_in,
input wire mem_to_reg_in,
input wire alu_src_in,
input wire [3:0]  alu_control_in,
input wire branch_in,
input wire branch_ne_in,
input wire jal_in,
input wire jalr_in,
input wire lui_in,
input wire  pc_mux1_in,
input wire  pc_mux2_in,
 
output reg [31:0] pc_out,
output reg [31:0] rs1_data_out,
output reg [31:0] rs2_data_out,
output reg [31:0] immediate_out,

output reg [4:0]  rs1_out,
output reg [4:0]  rs2_out,
output reg [4:0]  rd_out,

output reg reg_write_out,
output reg mem_read_out,
output reg mem_write_out,
output reg mem_to_reg_out,
output reg alu_src_out,
output reg [3:0]  alu_control_out,
output reg branch_out,
output reg branch_ne_out,
output reg jal_out,
output reg jalr_out,
output reg lui_out,
output reg  pc_mux1_out,
output reg  pc_mux2_out

);
always @(posedge clk) begin
if (reset || flush) begin
            pc_out          <= 32'b0;
            rs1_data_out    <= 32'b0;
            rs2_data_out    <= 32'b0;
            immediate_out   <= 32'b0;
            rs1_out         <= 5'b0;
            rs2_out         <= 5'b0;
            rd_out          <= 5'b0;
            reg_write_out   <= 1'b0;
            mem_read_out    <= 1'b0;
            mem_write_out   <= 1'b0;
            mem_to_reg_out  <= 1'b0;
            alu_src_out     <= 1'b0;
            alu_control_out <= 4'b0;
            branch_out      <= 1'b0;
            branch_ne_out   <= 1'b0;
            jal_out         <= 1'b0;
            jalr_out        <= 1'b0;
            lui_out         <= 1'b0;
            pc_mux1_out     <= 1'b0;
            pc_mux2_out     <= 1'b0;
        end

        else begin
            pc_out          <= pc_in;
            rs1_data_out    <= rs1_data_in;
            rs2_data_out    <= rs2_data_in;
            immediate_out   <= immediate_in;
            rs1_out         <= rs1_in;
            rs2_out         <= rs2_in;
            rd_out          <= rd_in;
            reg_write_out   <= reg_write_in;
            mem_read_out    <= mem_read_in;
            mem_write_out   <= mem_write_in;
            mem_to_reg_out  <= mem_to_reg_in;
            alu_src_out     <= alu_src_in;
            alu_control_out <= alu_control_in;
            branch_out      <= branch_in;
            branch_ne_out   <= branch_ne_in;
            jal_out         <= jal_in;
            jalr_out        <= jalr_in;
            lui_out         <= lui_in;
            pc_mux1_out     <= pc_mux1_in;
            pc_mux2_out     <= pc_mux1_in;
        end
    end

endmodule
