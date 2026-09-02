`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 24.08.2026 20:47:54
// Design Name: 
// Module Name: riscv_pipeline_tb
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


module riscv_pipeline_tb();
reg clk;
reg reset;

riscv_pipeline DUT (.clk(clk),.reset(reset));

// CLOCK-10 ns period
initial begin
    clk = 1'b0;forever #5 clk = ~clk;
end

initial begin
// ALU TESTS
// 0: addi x1, x0, 5 - x1 = 5
DUT.IMEM.memory[0] = 32'h00500093;
// 1: addi x2, x0, 10 - x2 = 10
DUT.IMEM.memory[1] = 32'h00A00113;
// 2: add x3, x1, x2 - x3 = 5 + 10 = 15
DUT.IMEM.memory[2] = 32'h002081B3;
// 3: sub x4, x2, x1 - x4 = 10 - 5 = 5
DUT.IMEM.memory[3] = 32'h40110233;
// 4: and x5, x3, x4 - x5 = 15 & 5 = 5
DUT.IMEM.memory[4] = 32'h0041F2B3;
// 5: or x6, x3, x4 - x6 = 15 | 5 = 15
DUT.IMEM.memory[5] = 32'h0041E333;
// 6: xor x7, x3, x4 - x7 = 15 ^ 5 = 10
DUT.IMEM.memory[6] = 32'h0041C3B3;
// 7: sw x7, 0(x0) - memory[0] = 10
DUT.IMEM.memory[7] = 32'h00702023;
// 8: lw x8, 0(x0) - x8 = 10
DUT.IMEM.memory[8] = 32'h00002403;
// 9: lui x9, 0x12345 - x9 = 0x12345000
DUT.IMEM.memory[9] = 32'h123454B7;
// 10: beq x1, x1, +8 - Branch is TAKEN. Skip instruction 11 and go to instruction 12.
DUT.IMEM.memory[10] = 32'h00108463;
// 11: addi x10, x0, 999 SHOULD BE FLUSHED / NOT EXECUTED
DUT.IMEM.memory[11] = 32'h3E700513;
// 12: bne x1, x2, +8 - 5 != 10 -> branch TAKEN.Skip instruction 13 and go to instruction 14.
DUT.IMEM.memory[12] = 32'h00209463;
// 13: addi x11, x0, 999 - SHOULD BE FLUSHED / NOT EXECUTED
DUT.IMEM.memory[13] = 32'h3E700593;
// 14: jal x12, +8 - PC = 56
// x12 = PC + 4 = 60
// Target = PC + 8 = 64  Therefore jump to instruction 16.Instruction 15 should be skipped.
DUT.IMEM.memory[14] = 32'h0080066F;
// 15: addi x10, x0, 888 SHOULD BE FLUSHED / NOT EXECUTED
DUT.IMEM.memory[15] = 32'h37800513;
// 16: addi x14, x0, 80 - x14 = 80
DUT.IMEM.memory[16] = 32'h05000713;
// 17: jalr x13, 0(x14)-Current PC = 68
// x13 = PC + 4 = 72
// Target = x14 + 0 = 80 - Address 80 = instruction 20.Instructions 18 and 19 should be skipped.
DUT.IMEM.memory[17] = 32'h000706E7;
// 18: addi x10, x0, 777 SHOULD BE FLUSHED
DUT.IMEM.memory[18] = 32'h30900513;
// 19: addi x11, x0, 666 SHOULD BE FLUSHED
DUT.IMEM.memory[19] = 32'h29A00593;
// JALR TARGET  20: addi x11, x0, 77 This instruction should execute after JALR.
DUT.IMEM.memory[20] = 32'h04D00593;
// INFINITE LOOP
// 21: jal x0, 0
DUT.IMEM.memory[21] = 32'h0000006F;

end
// RESET
initial begin
 reset = 1'b1;
 #20;
 reset = 1'b0;
end

// CHECK RESULTS
initial begin
// Give the pipeline enough time.53 cycles is intentionally used here because the program contains branches, JAL and JALR, which introduce pipeline flushes.
#20;
repeat(53)
@(posedge clk);
#1;
$display("");
$display("==================================================");
$display("      RISC-V PIPELINE COMPLETE TEST");
$display("==================================================");
// ADDI
if (DUT.REG_FILE.registers[1] == 32'd5)
     $display("PASS: ADDI  x1 = 5");
else
     $display("FAIL: ADDI  x1 = %0d",
         DUT.REG_FILE.registers[1]);
if (DUT.REG_FILE.registers[2] == 32'd10)
     $display("PASS: ADDI  x2 = 10");
else
     $display("FAIL: ADDI  x2 = %0d",
         DUT.REG_FILE.registers[2]);
// ADD
if (DUT.REG_FILE.registers[3] == 32'd15)
     $display("PASS: ADD   x3 = 15");
else
     $display("FAIL: ADD   x3 = %0d",
          DUT.REG_FILE.registers[3]);
// SUB
if (DUT.REG_FILE.registers[4] == 32'd5)
     $display("PASS: SUB   x4 = 5");
else
     $display("FAIL: SUB   x4 = %0d",
          DUT.REG_FILE.registers[4]);
// AND
if (DUT.REG_FILE.registers[5] == 32'd5)
     $display("PASS: AND   x5 = 5");
else
     $display("FAIL: AND   x5 = %0d",
          DUT.REG_FILE.registers[5]);
// OR
if (DUT.REG_FILE.registers[6] == 32'd15)
     $display("PASS: OR    x6 = 15");
else
     $display("FAIL: OR    x6 = %0d",
          DUT.REG_FILE.registers[6]);
// XOR
if (DUT.REG_FILE.registers[7] == 32'd10)
     $display("PASS: XOR   x7 = 10");
else
     $display("FAIL: XOR   x7 = %0d",
          DUT.REG_FILE.registers[7]);
// STORE
if (DUT.DMEM.memory[0] == 32'd10)
     $display("PASS: SW    memory[0] = 10");
else
     $display("FAIL: SW    memory[0] = %0d",
          DUT.DMEM.memory[0]);
// LOAD
if (DUT.REG_FILE.registers[8] == 32'd10)
     $display("PASS: LW    x8 = 10");
else
     $display("FAIL: LW    x8 = %0d",
          DUT.REG_FILE.registers[8]);
// LUI
if (DUT.REG_FILE.registers[9] == 32'h12345000)
     $display("PASS: LUI   x9 = 0x12345000");
else
     $display("FAIL: LUI   x9 = %h",
           DUT.REG_FILE.registers[9]);
// BEQ
// x10 should NOT become 999 because instruction 11 - was supposed to be flushed.
if (DUT.REG_FILE.registers[10] != 32'd999)
     $display("PASS: BEQ   instruction correctly skipped");
else
     $display("FAIL: BEQ   wrong-path instruction executed");
// BNE
// x11 should NOT become 999 or 666.- It eventually becomes 77 at instruction 20.
if (DUT.REG_FILE.registers[11] == 32'd77)
     $display("PASS: BNE   branch/flush works");
else
     $display("FAIL: BNE   x11 = %0d",
           DUT.REG_FILE.registers[11]);
// JAL
// Instruction 14 is at PC = 56. JAL stores PC+4 = 60 into x12.
if (DUT.REG_FILE.registers[12] == 32'd60)
     $display("PASS: JAL   x12 = 60");
else
     $display("FAIL: JAL   x12 = %0d",
            DUT.REG_FILE.registers[12]);
// JALR
// Instruction 17 is at PC = 68. JALR stores PC+4 = 72 into x13.
if (DUT.REG_FILE.registers[13] == 32'd72)
     $display("PASS: JALR  x13 = 72");
else
     $display("FAIL: JALR  x13 = %0d",
            DUT.REG_FILE.registers[13]);
// JALR TARGET
if (DUT.REG_FILE.registers[11] == 32'd77)
     $display("PASS: JALR  target instruction executed");
else
     $display("FAIL: JALR  target not reached");
// FINAL RESULT
$display("");
$display("==================================================");
$display("              TEST COMPLETE");
$display("==================================================");

$finish;

end

endmodule
