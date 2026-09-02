`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 23.08.2026 14:14:17
// Design Name: 
// Module Name: riscv_decoder_pipeline
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


module riscv_decoder_pipeline(
input  wire [6:0] opcode,
input  wire [2:0] funct3,
input  wire [6:0] funct7,

output reg  reg_write,
output reg  mem_read,
output reg  mem_write,
output reg  mem_to_reg,
output reg  alu_src,
output reg  branch,
output reg  branch_ne,
output reg  jal,
output reg  jalr,
output reg  pc_mux1,
output reg  pc_mux2,
output reg [3:0]  alu_control,
output reg lui
);
parameter ALU_ADD = 4'b0000;
parameter ALU_SUB = 4'b0001;
parameter ALU_AND = 4'b0010;
parameter ALU_OR  = 4'b0011;
parameter ALU_XOR = 4'b0100;
parameter ALU_SLL = 4'b0101;
parameter ALU_SRL = 4'b0110;
parameter ALU_SRA = 4'b0111;
parameter ALU_SLT = 4'b1000;
parameter ALU_SLTU= 4'b1001;

parameter OP_RTYPE = 7'b0110011;
parameter OP_ITYPE = 7'b0010011;
parameter OP_LOAD  = 7'b0000011;
parameter OP_STORE = 7'b0100011;
parameter OP_BRANCH= 7'b1100011;
parameter OP_JAL   = 7'b1101111;
parameter OP_JALR  = 7'b1100111;
parameter OP_LUI   = 7'b0110111;

always @(*) begin
reg_write   = 1'b0;
mem_read    = 1'b0;
mem_write   = 1'b0;
mem_to_reg  = 1'b0;
alu_src     = 1'b0;
branch      = 1'b0;
branch_ne   = 1'b0;
jal         = 1'b0;
jalr        = 1'b0;
lui         = 1'b0;
pc_mux1     = 1'b0;
pc_mux2     = 1'b0;
alu_control = ALU_ADD;

case (opcode)
// R-TYPE - add, sub, and, or, xor, sll, srl, sra, slt, sltu
      OP_RTYPE: begin
                reg_write = 1'b1;
                alu_src   = 1'b0;
                case (funct3)
                    3'b000: begin
                        if (funct7 == 7'b0000000)
                            alu_control = ALU_ADD;   // ADD
                        else if (funct7 == 7'b0100000)
                            alu_control = ALU_SUB;   // SUB
                    end
                    3'b111:
                        alu_control = ALU_AND;       // AND
                    3'b110:
                        alu_control = ALU_OR;        // OR
                    3'b100:
                        alu_control = ALU_XOR;       // XOR
                    3'b001:
                        alu_control = ALU_SLL;       // SLL
                    3'b101: begin
                        if (funct7 == 7'b0000000)
                            alu_control = ALU_SRL;   // SRL
                        else if (funct7 == 7'b0100000)
                            alu_control = ALU_SRA;   // SRA
                    end
                    3'b010:
                        alu_control = ALU_SLT;       // SLT
                    3'b011:
                        alu_control = ALU_SLTU;      // SLTU
                    default:
                        alu_control = ALU_ADD;
                endcase
            end
// I-TYPE ALU - addi, andi, ori, xori, slli, srli, srai, slti
        OP_ITYPE: begin
                reg_write = 1'b1;
                alu_src   = 1'b1;
                case (funct3)
                    3'b000:
                        alu_control = ALU_ADD;       // ADDI
                    3'b111:
                        alu_control = ALU_AND;       // ANDI
                    3'b110:
                        alu_control = ALU_OR;        // ORI
                    3'b100:
                        alu_control = ALU_XOR;       // XORI
                    3'b001:
                        alu_control = ALU_SLL;       // SLLI
                    3'b101: begin
                        if (funct7 == 7'b0000000)
                            alu_control = ALU_SRL;   // SRLI
                        else if (funct7 == 7'b0100000)
                            alu_control = ALU_SRA;   // SRAI
                    end
                    3'b010:
                        alu_control = ALU_SLT;       // SLTI
                    3'b011:
                        alu_control = ALU_SLTU;      // SLTIU
                    default:
                        alu_control = ALU_ADD;
                endcase
            end
// LOAD - lw
         OP_LOAD: begin
                reg_write  = 1'b1;
                mem_read   = 1'b1;
                mem_to_reg = 1'b1;
                alu_src    = 1'b1;
                // Address = rs1 + immediate
                alu_control = ALU_ADD;
            end
// STORE - sw
          OP_STORE: begin
                mem_write = 1'b1;
                alu_src   = 1'b1;
                // Address = rs1 + immediate
                alu_control = ALU_ADD;
            end
// BRANCH - beq, bne
          OP_BRANCH: begin
                branch = 1'b1;
                // rs1 - rs2
                alu_control = ALU_SUB;
                case (funct3)
                    3'b000: begin
                        // BEQ
                        branch_ne = 1'b0;
                    end
                    3'b001: begin
                        // BNE
                        branch_ne = 1'b1;
                    end
                    default: begin
                        branch_ne = 1'b0;
                    end
                endcase
            end
// JAL
          OP_JAL: begin
                jal       = 1'b1;
                reg_write = 1'b1;
                pc_mux1   = 1'b0;
                pc_mux2   = 1'b1;
            end
// JALR
         OP_JALR: begin
                jal       = 1'b1;
                jalr      = 1'b1;
                reg_write = 1'b1;
                alu_src   = 1'b1;
                pc_mux1   = 1'b1;
                pc_mux2   = 1'b1;
                // rs1 + immediate
                alu_control = ALU_ADD;
            end
// LUI
          OP_LUI: begin
                    reg_write = 1'b1;
                    alu_src   = 1'b1;
                    lui       = 1'b1;
             end
            default: begin
                reg_write   = 1'b0;
                mem_read    = 1'b0;
                mem_write   = 1'b0;
                mem_to_reg  = 1'b0;
                alu_src     = 1'b0;
                branch      = 1'b0;
                branch_ne   = 1'b0;
                jal         = 1'b0;
                jalr        = 1'b0;
                lui         = 1'b0;
                pc_mux1     = 1'b0;
                pc_mux2     = 1'b0;
            end
        endcase
    end

endmodule


