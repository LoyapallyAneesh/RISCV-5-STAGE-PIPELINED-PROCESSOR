`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 22.08.2026 18:13:50
// Design Name: 
// Module Name: forwarding_mux
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


module forwarding_mux(
input wire [31:0] original_a,
input wire [31:0] original_b,
input wire [31:0] ex_mem_result,
input wire [31:0] mem_wb_result,
input wire [1:0] forward_a,
input wire [1:0] forward_b,

output reg [31:0] alu_a,
output reg [31:0] forwarded_b
);
always @(*) begin
// ALU A
case (forward_a)
            2'b00:
                alu_a = original_a;
            2'b10:
                alu_a = ex_mem_result;
            2'b01:
                alu_a = mem_wb_result;
            default:
                alu_a = original_a;
        endcase
// ALU B
case (forward_b)
            2'b00:
                forwarded_b = original_b;
            2'b10:
                forwarded_b = ex_mem_result;
            2'b01:
                forwarded_b = mem_wb_result;
            default:
                forwarded_b = original_b;
        endcase
    end

endmodule