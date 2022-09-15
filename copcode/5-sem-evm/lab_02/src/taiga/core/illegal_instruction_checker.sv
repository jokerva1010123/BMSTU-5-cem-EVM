/*
 * Copyright © 2020 Eric Matthews,  Lesley Shannon
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 *
 * Initial code developed under the supervision of Dr. Lesley Shannon,
 * Reconfigurable Computing Lab, Simon Fraser University.
 *
 * Author(s):
 *             Eric Matthews <ematthew@sfu.ca>
 */

module  illegal_instruction_checker
    import taiga_config::*;
    (
        input logic [31:0] instruction,
        output logic illegal_instruction
    );

    ////////////////////////////////////////////////////
    //Instruction Patterns for Illegal Instruction Checking

    //Base ISA
    localparam [31:0] BEQ = 32'b?????????????????000?????1100011;
    localparam [31:0] BNE = 32'b?????????????????001?????1100011;
    localparam [31:0] BLT = 32'b?????????????????100?????1100011;
    localparam [31:0] BGE = 32'b?????????????????101?????1100011;
    localparam [31:0] BLTU = 32'b?????????????????110?????1100011;
    localparam [31:0] BGEU = 32'b?????????????????111?????1100011;
    localparam [31:0] JALR = 32'b?????????????????000?????1100111;
    localparam [31:0] JAL = 32'b?????????????????????????1101111;
    localparam [31:0] LUI = 32'b?????????????????????????0110111;
    localparam [31:0] AUIPC = 32'b?????????????????????????0010111;
    localparam [31:0] ADDI = 32'b?????????????????000?????0010011;
    localparam [31:0] SLLI = 32'b000000???????????001?????0010011;
    localparam [31:0] SLTI = 32'b?????????????????010?????0010011;
    localparam [31:0] SLTIU = 32'b?????????????????011?????0010011;
    localparam [31:0] XORI = 32'b?????????????????100?????0010011;
    localparam [31:0] SRLI = 32'b000000???????????101?????0010011;
    localparam [31:0] SRAI = 32'b010000???????????101?????0010011;
    localparam [31:0] ORI = 32'b?????????????????110?????0010011;
    localparam [31:0] ANDI = 32'b?????????????????111?????0010011;
    localparam [31:0] ADD = 32'b0000000??????????000?????0110011;
    localparam [31:0] SUB = 32'b0100000??????????000?????0110011;
    localparam [31:0] SLL = 32'b0000000??????????001?????0110011;
    localparam [31:0] SLT = 32'b0000000??????????010?????0110011;
    localparam [31:0] SLTU = 32'b0000000??????????011?????0110011;
    localparam [31:0] XOR = 32'b0000000??????????100?????0110011;
    localparam [31:0] SRL = 32'b0000000??????????101?????0110011;
    localparam [31:0] SRA = 32'b0100000??????????101?????0110011;
    localparam [31:0] OR = 32'b0000000??????????110?????0110011;
    localparam [31:0] AND = 32'b0000000??????????111?????0110011;
    localparam [31:0] LB = 32'b?????????????????000?????0000011;
    localparam [31:0] LH = 32'b?????????????????001?????0000011;
    localparam [31:0] LW = 32'b?????????????????010?????0000011;
    localparam [31:0] LBU = 32'b?????????????????100?????0000011;
    localparam [31:0] LHU = 32'b?????????????????101?????0000011;
    localparam [31:0] SB = 32'b?????????????????000?????0100011;
    localparam [31:0] SH = 32'b?????????????????001?????0100011;
    localparam [31:0] SW = 32'b?????????????????010?????0100011;
    localparam [31:0] FENCE = 32'b?????????????????000?????0001111;
    localparam [31:0] FENCE_I = 32'b?????????????????001?????0001111;
    localparam [31:0] ECALL = 32'b00000000000000000000000001110011;
    localparam [31:0] EBREAK = 32'b00000000000100000000000001110011;

    localparam [31:0] CSRRW = 32'b?????????????????001?????1110011;
    localparam [31:0] CSRRS = 32'b?????????????????010?????1110011;
    localparam [31:0] CSRRC = 32'b?????????????????011?????1110011;
    localparam [31:0] CSRRWI = 32'b?????????????????101?????1110011;
    localparam [31:0] CSRRSI = 32'b?????????????????110?????1110011;
    localparam [31:0] CSRRCI = 32'b?????????????????111?????1110011;

    //Mul
    localparam [31:0] MUL = 32'b0000001??????????000?????0110011;
    localparam [31:0] MULH = 32'b0000001??????????001?????0110011;
    localparam [31:0] MULHSU = 32'b0000001??????????010?????0110011;
    localparam [31:0] MULHU = 32'b0000001??????????011?????0110011;
    //Div
    localparam [31:0] DIV = 32'b0000001??????????100?????0110011;
    localparam [31:0] DIVU = 32'b0000001??????????101?????0110011;
    localparam [31:0] REM = 32'b0000001??????????110?????0110011;
    localparam [31:0] REMU = 32'b0000001??????????111?????0110011;

    //AMO
    localparam [31:0] AMO_ADD = 32'b00000????????????010?????0101111;
    localparam [31:0] AMO_XOR = 32'b00100????????????010?????0101111;
    localparam [31:0] AMO_OR = 32'b01000????????????010?????0101111;
    localparam [31:0] AMO_AND = 32'b01100????????????010?????0101111;
    localparam [31:0] AMO_MIN = 32'b10000????????????010?????0101111;
    localparam [31:0] AMO_MAX = 32'b10100????????????010?????0101111;
    localparam [31:0] AMO_MINU = 32'b11000????????????010?????0101111;
    localparam [31:0] AMO_MAXU = 32'b11100????????????010?????0101111;
    localparam [31:0] AMO_SWAP = 32'b00001????????????010?????0101111;
    localparam [31:0] LR = 32'b00010??00000?????010?????0101111;
    localparam [31:0] SC = 32'b00011????????????010?????0101111;

    //Machine/Supervisor
    localparam [31:0] SRET = 32'b00010000001000000000000001110011;
    localparam [31:0] MRET = 32'b00110000001000000000000001110011;
    localparam [31:0] SFENCE_VMA = 32'b0001001??????????000000001110011;
    localparam [31:0] WFI = 32'b00010000010100000000000001110011;

	 
    logic base_legal;
    logic mul_legal;
    logic div_legal;
    logic amo_legal;
    logic machine_legal;
    logic supervisor_legal;
    ////////////////////////////////////////////////////
    //Implementation

    assign base_legal = (instruction ==? BEQ) |
								(instruction ==? BNE) |
								(instruction ==? BLT) |
								(instruction ==? BGE) |
								(instruction ==? BLTU) |
								(instruction ==? BGEU) |
								(instruction ==? JALR) |
								(instruction ==? JAL) |
								(instruction ==? LUI ) |
								(instruction ==? AUIPC) |
								(instruction ==? ADDI) |
								(instruction ==? SLLI) |
								(instruction ==? SLTI) |
								(instruction ==? SLTIU) |
								(instruction ==? XORI) |
								(instruction ==? SRLI) |
								(instruction ==? SRAI) |
								(instruction ==? ORI) |
								(instruction ==? ANDI) |
								(instruction ==? ADD) |
								(instruction ==? SUB) |
								(instruction ==? SLL) |
								(instruction ==? SLT) |
								(instruction ==? SLTU) |
								(instruction ==? XOR) |
								(instruction ==? SRL) |
								(instruction ==? SRA) |
								(instruction ==? OR) |
								(instruction ==? AND) |
								(instruction ==? LB) |
								(instruction ==? LH) |
								(instruction ==? LW) |
								(instruction ==? LBU) |
								(instruction ==? LHU) |
								(instruction ==? SB) |
								(instruction ==? SH) |
								(instruction ==? SW) |
								(instruction ==? FENCE) |
								(instruction ==? FENCE_I) |
								(instruction ==? CSRRW) |
								(instruction ==? CSRRS) |
								(instruction ==? CSRRC) |
								(instruction ==? CSRRWI) |
								(instruction ==? CSRRSI) |
								(instruction ==? CSRRCI);

    assign mul_legal = 	(instruction ==? MUL) |
								(instruction ==? MULH) | 
								(instruction ==? MULHSU) |
								(instruction ==? MULHU);

    assign div_legal =  (instruction ==? DIV) |
								(instruction ==? DIVU) |
								(instruction ==? REM) |
								(instruction ==? REMU);

    assign amo_legal = 	(instruction ==? AMO_ADD) |
								(instruction ==? AMO_XOR) |
								(instruction ==? AMO_OR) |
								(instruction ==? AMO_AND) |
								(instruction ==? AMO_MIN) |
								(instruction ==? AMO_MAX) |
								(instruction ==? AMO_MINU) |
								(instruction ==? AMO_MAXU) |
								(instruction ==? AMO_SWAP) |
								(instruction ==? LR) |
								(instruction ==? SC);

    assign machine_legal = (instruction ==? MRET) |
									(instruction ==? ECALL) | 
									(instruction ==? EBREAK);

    assign supervisor_legal = (instruction ==? SRET) | 
										(instruction ==? SFENCE_VMA) | 
										(instruction ==? WFI);
    assign illegal_instruction = ~(
        base_legal |
        (USE_MUL & mul_legal) |
        (USE_DIV & div_legal) |
        (USE_AMO & amo_legal) |
        (ENABLE_M_MODE & machine_legal) |
        (ENABLE_S_MODE & supervisor_legal) 
    );

endmodule
