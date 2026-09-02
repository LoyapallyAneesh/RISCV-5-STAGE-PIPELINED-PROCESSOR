`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 24.08.2026 18:19:36
// Design Name: 
// Module Name: riscv_pipeline
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


module riscv_pipeline(
input wire clk,
input wire reset
);
// IF STAGE
wire [31:0] current_pc;
wire [31:0] next_pc;
wire [31:0] instruction;
 // IF/ID REGISTER OUTPUTS
wire [31:0] if_id_pc;
wire [31:0] if_id_pc_plus4;
wire [31:0] if_id_instruction;
// CONTROL FOR STALL / FLUSH
wire pc_write;
wire if_id_write;
wire control_stall;
wire if_id_flush;
wire id_ex_flush;

//ID STAGE
// Instruction fields
wire [6:0] id_opcode;
wire [4:0] id_rs1;
wire [4:0] id_rs2;
wire [4:0] id_rd;
wire [2:0] id_funct3;
wire [6:0] id_funct7;

// CONTROL SIGNALS FROM DECODER
wire id_reg_write;
wire id_mem_read;
wire id_mem_write;
wire id_mem_to_reg;
wire id_alu_src;
wire [3:0] id_alu_control;
wire id_branch;
wire id_branch_ne;
wire id_jal;
wire id_jalr;
wire id_lui;
wire  id_pc_mux1;
wire  id_pc_mux2;

// REGISTER FILE
wire [31:0] id_rs1_data;
wire [31:0] id_rs2_data;
wire [31:0] wb_write_data;
// IMMEDIATE GENERATOR
wire [31:0] id_immediate;

// ID/EX REGISTER
wire [31:0] id_ex_pc;
wire [31:0] id_ex_pc_plus4;
wire [31:0] id_ex_rs1_data;
wire [31:0] id_ex_rs2_data;
wire [31:0] id_ex_immediate;
wire [4:0] id_ex_rs1;
wire [4:0] id_ex_rs2;
wire [4:0] id_ex_rd;
wire id_ex_reg_write;
wire id_ex_mem_read;
wire id_ex_mem_write;
wire id_ex_mem_to_reg;
wire id_ex_alu_src;
wire [3:0] id_ex_alu_control;
wire id_ex_branch;
wire id_ex_branch_ne;
wire id_ex_jal;
wire id_ex_jalr;
wire id_ex_lui;
wire id_ex_pc_mux1;
wire id_ex_pc_mux2;

// FORWARDING
wire [1:0] forward_a;
wire [1:0] forward_b;

// FORWARDED ALU INPUTS
wire [31:0] ex_alu_a;
wire [31:0] ex_forwarded_rs2;
wire [31:0] ex_alu_b;
wire [31:0] ex_alu_result;
wire  ex_zero;

//EXECUTE STAGE
wire ex_branch_taken;
wire [31:0] pc_mux1_output;
wire [31:0] pc_mux2_output;

// EX/MEM REGISTER
wire [31:0] ex_mem_alu_result;
wire [31:0] ex_mem_rs2_data;
wire [31:0] ex_mem_pc;
wire [31:0] ex_mem_immediate;
wire [4:0]  ex_mem_rd;
wire ex_mem_reg_write;
wire ex_mem_mem_read;
wire ex_mem_mem_write;
wire ex_mem_mem_to_reg;
wire ex_mem_jal;
wire ex_mem_lui;
wire control_transfer;

wire [31:0] mem_read_data;
wire [31:0] mem_wb_memory_data;
wire [31:0] mem_wb_alu_result;
wire [31:0] mem_wb_pc;
wire [31:0] mem_wb_immediate;
wire [4:0] mem_wb_rd;
wire mem_wb_reg_write;
wire mem_wb_mem_to_reg;
wire mem_wb_jal;
wire mem_wb_lui;


// PC
pc_pipeline PC_UNIT (.clk(clk),.reset(reset),.stall(!pc_write),
.next_pc(next_pc),.current_pc(current_pc));

// INSTRUCTION MEMORY
instruction_memory IMEM (.address(current_pc),.instruction(instruction));

// IF/ID PIPELINE REGISTER
if_id_reg IF_ID ( .clk(clk),.reset(reset),.stall(!if_id_write),.flush(if_id_flush),
.pc_in(current_pc),.instruction_in(instruction),.pc_out(if_id_pc),.instruction_out(if_id_instruction) );


assign id_opcode = if_id_instruction[6:0];
assign id_rd     = if_id_instruction[11:7];
assign id_funct3 = if_id_instruction[14:12];
assign id_rs1    = if_id_instruction[19:15];
assign id_rs2    = if_id_instruction[24:20];
assign id_funct7 = if_id_instruction[31:25];

// DECODER
riscv_decoder_pipeline DECODER (.opcode(id_opcode),.funct3(id_funct3),.funct7(id_funct7),
.reg_write(id_reg_write),.mem_read(id_mem_read),.mem_write(id_mem_write),
.mem_to_reg(id_mem_to_reg),.alu_src(id_alu_src),.alu_control(id_alu_control),
.branch(id_branch),.branch_ne(id_branch_ne),
.jal(id_jal),.jalr(id_jalr),.lui(id_lui),.pc_mux1(id_pc_mux1),.pc_mux2(id_pc_mux2));


// MEM/WB outputs are declared later
// but can be used here for write-back
register_file REG_FILE (.clk(clk),.reset(reset),.rs1(id_rs1),.rs2(id_rs2),.rd(mem_wb_rd),.write_data(wb_write_data),
.reg_write(mem_wb_reg_write),.read_data1(id_rs1_data),.read_data2(id_rs2_data));


// IMMEDIATE GENERATOR
immediate_generator IMM_GEN (.instruction(if_id_instruction),.immediate(id_immediate));

// HAZARD DETECTION
hazard_detection_unit HAZARD (.id_rs1(id_rs1),.id_rs2(id_rs2),.id_ex_rd(id_ex_rd),.id_ex_mem_read(id_ex_mem_read),
.pc_write(pc_write),.if_id_write(if_id_write),.control_stall(control_stall));

// ID/EX FLUSH
assign id_ex_flush = control_stall | if_id_flush;

id_ex_reg ID_EX (.clk(clk),.reset(reset),.flush(id_ex_flush),.pc_in(if_id_pc),
.rs1_data_in(id_rs1_data),.rs2_data_in(id_rs2_data),.immediate_in(id_immediate),.rs1_in(id_rs1),.rs2_in(id_rs2),
.rd_in(id_rd),.reg_write_in(id_reg_write),.mem_read_in(id_mem_read),.mem_write_in(id_mem_write),
.mem_to_reg_in(id_mem_to_reg),.alu_src_in(id_alu_src),.alu_control_in(id_alu_control),.branch_in(id_branch),
.branch_ne_in(id_branch_ne),.jal_in(id_jal),
.jalr_in(id_jalr),.lui_in(id_lui),.pc_mux1_in(id_pc_mux1),.pc_mux2_in(id_pc_mux2),

.pc_out(id_ex_pc),.rs1_data_out(id_ex_rs1_data),.rs2_data_out(id_ex_rs2_data),
.immediate_out(id_ex_immediate),.rs1_out(id_ex_rs1),.rs2_out(id_ex_rs2),.rd_out(id_ex_rd),.reg_write_out(id_ex_reg_write),
.mem_read_out(id_ex_mem_read),.mem_write_out(id_ex_mem_write),.mem_to_reg_out(id_ex_mem_to_reg),.alu_src_out(id_ex_alu_src),
.alu_control_out(id_ex_alu_control),.branch_out(id_ex_branch),.branch_ne_out(id_ex_branch_ne),
.jal_out(id_ex_jal),.jalr_out(id_ex_jalr),.lui_out(id_ex_lui),.pc_mux1_out(id_ex_pc_mux1),.pc_mux2_out(id_ex_pc_mux2));

//EX STAGE

// FORWARDING
forwarding_unit FORWARD (.id_ex_rs1(id_ex_rs1),.id_ex_rs2(id_ex_rs2),.ex_mem_rd(ex_mem_rd),.ex_mem_reg_write(ex_mem_reg_write),
.mem_wb_rd(mem_wb_rd),.mem_wb_reg_write(mem_wb_reg_write),.forward_a(forward_a),.forward_b(forward_b));

forwarding_mux FORWARD_MUX (.original_a(id_ex_rs1_data),.original_b(id_ex_rs2_data),.ex_mem_result(ex_mem_alu_result),
.mem_wb_result(wb_write_data),.forward_a(forward_a),.forward_b(forward_b),.alu_a(ex_alu_a),.forwarded_b(ex_forwarded_rs2));

// ALU INPUT B MUX
alu_input_mux_pipeline ALU_INPUT_MUX (.forwarded_rs2(ex_forwarded_rs2),
.immediate(id_ex_immediate),.alu_src(id_ex_alu_src),.alu_input_b(ex_alu_b));

// ALU
riscv_alu ALU (.a(ex_alu_a),.b(ex_alu_b),
.alu_control(id_ex_alu_control),.result(ex_alu_result),.zero(ex_zero));

// BRANCH CONDITION
branch_condition BRANCH_CONDITION (.branch(id_ex_branch),.branch_ne(id_ex_branch_ne),
.zero(ex_zero),.branch_taken(ex_branch_taken));

// ACTUAL CONTROL-FLOW REDIRECTION
assign control_transfer = ex_branch_taken |id_ex_jal | id_ex_jalr;

// PC MUX 1
    pc_mux1 pcmux1(.pc(id_ex_pc),.rs1(ex_alu_a),.pc_mux1_control(id_ex_pc_mux1),.pc_mux1_output(pc_mux1_output));
// PC MUX 2
     pc_mux2 pcmux2(.pc_mux2_control(id_ex_pc_mux2),.branch_taken(ex_branch_taken),.immediate(id_ex_immediate),.pc_mux2_output(pc_mux2_output));
 // NEXT PC
    pc_adder pc_value(.pc_mux1(pc_mux1_output),.pc_mux2(pc_mux2_output),.jalr(id_ex_jalr),
    .pc_next(next_pc));

// FLUSH
assign if_id_flush = control_transfer;

ex_mem_reg EX_MEM (.clk(clk),.reset(reset),
.alu_result_in(ex_alu_result),.rs2_data_in(ex_forwarded_rs2),
.pc_in(id_ex_pc),.immediate_in(id_ex_immediate),.rd_in(id_ex_rd),.reg_write_in(id_ex_reg_write),
.mem_read_in(id_ex_mem_read),.mem_write_in(id_ex_mem_write),.mem_to_reg_in(id_ex_mem_to_reg),.jal_in(id_ex_jal),.lui_in(id_ex_lui),

.alu_result_out(ex_mem_alu_result),.rs2_data_out(ex_mem_rs2_data),
.pc_out(ex_mem_pc),.immediate_out(ex_mem_immediate),.rd_out(ex_mem_rd),.reg_write_out(ex_mem_reg_write),
.mem_read_out(ex_mem_mem_read),.mem_write_out(ex_mem_mem_write),.mem_to_reg_out(ex_mem_mem_to_reg),.jal_out(ex_mem_jal),.lui_out(ex_mem_lui));

//MEM STAGE
data_memory DMEM (.clk(clk),.mem_read(ex_mem_mem_read),.mem_write(ex_mem_mem_write),.address(ex_mem_alu_result),
.write_data(ex_mem_rs2_data),.read_data(mem_read_data));


//MEM/WB REGISTER
mem_wb_reg MEM_WB (.clk(clk),.reset(reset),.memory_data_in(mem_read_data),
.alu_result_in(ex_mem_alu_result),.pc_in(ex_mem_pc),.immediate_in(ex_mem_immediate),.rd_in(ex_mem_rd),
.reg_write_in(ex_mem_reg_write),.mem_to_reg_in(ex_mem_mem_to_reg),.jal_in(ex_mem_jal),.lui_in(ex_mem_lui),
.memory_data_out(mem_wb_memory_data),.alu_result_out(mem_wb_alu_result),
.pc_out(mem_wb_pc),.immediate_out(mem_wb_immediate),.rd_out(mem_wb_rd),.reg_write_out(mem_wb_reg_write),
.mem_to_reg_out(mem_wb_mem_to_reg),.jal_out(mem_wb_jal),.lui_out(mem_wb_lui));

//WB STAGE
write_back_mux WB_MUX (.alu_result(mem_wb_alu_result),.memory_data(mem_wb_memory_data),.pc(mem_wb_pc),.immediate(mem_wb_immediate),
.mem_to_reg(mem_wb_mem_to_reg),.jal(mem_wb_jal),.lui(mem_wb_lui),.write_back_data(wb_write_data));

endmodule
