`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 18.08.2026 21:28:33
// Design Name: 
// Module Name: immediate_generator
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


module immediate_generator(
input  wire [31:0] instruction,
output reg  [31:0] immediate
);
wire [6:0] opcode;
assign opcode = instruction[6:0];
always @(*) begin
        case (opcode)
// I-TYPE - ADDI, ANDI, ORI, XORI, SLTI, SLTIU and LW and JALR
            7'b0010011,     // I-type ALU
            7'b0000011,     // LW
            7'b1100111:    // JALR
            begin
                immediate = {{20{instruction[31]}},instruction[31:20]};
            end
// S-TYPE SW
            7'b0100011:
            begin
                immediate = {{20{instruction[31]}},instruction[31:25],instruction[11:7]};
            end
// B-TYPE - BEQ / BNE
            7'b1100011:
            begin
                immediate = {{19{instruction[31]}},instruction[31],
                             instruction[7],instruction[30:25],instruction[11:8],
                             1'b0};
            end
// U-TYPE - LUI
            7'b0110111:
            begin
                immediate = {instruction[31:12],12'b0};
            end
// J-TYPE-JAL
            7'b1101111:
            begin
                immediate = {{11{instruction[31]}},instruction[31],
                             instruction[19:12],instruction[20],instruction[30:21],
                             1'b0};
            end

            default:
            begin
                immediate = 32'b0;
            end
        endcase
    end

endmodule

