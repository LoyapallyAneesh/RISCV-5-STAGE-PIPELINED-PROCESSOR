`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 22.08.2026 18:24:32
// Design Name: 
// Module Name: register_file
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


module register_file(
input  wire clk,
input  wire reset,
input  wire [4:0]  rs1,
input  wire [4:0]  rs2,
input  wire [4:0]  rd,
input  wire [31:0] write_data,
input  wire reg_write,

output wire [31:0] read_data1,
output wire [31:0] read_data2
);

reg [31:0] registers [0:31];
integer i;
always @(posedge clk) begin
        if (reset) begin
            for (i = 0; i < 32; i = i + 1)
                registers[i] <= 32'b0;
        end
        else begin
            // x0 must always remain zero
            registers[0] <= 32'b0;
            if (reg_write && (rd != 5'b00000))
                registers[rd] <= write_data;
        end
    end

assign read_data1 =(rs1 == 5'b00000) ? 32'b0 :
(reg_write && (rd != 5'b00000) && (rd == rs1)) ? write_data : registers[rs1];

assign read_data2 =(rs2 == 5'b00000) ? 32'b0 :
(reg_write && (rd != 5'b00000) && (rd == rs2)) ?write_data :registers[rs2];

endmodule
