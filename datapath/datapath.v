module datapath (
    input  wire        clk,
    input  wire        rst,
    input  wire        PCSrc,
    input  wire        ResultSrc,
    input  wire        ALUSrc,
    input  wire        RegWrite,
    input  wire [1:0]  ImmSrc,
    input  wire [2:0]  ALUControl,
    input  wire [31:0] ReadData,
    input  wire [31:0] Instr,
    output wire [31:0] ALUResult,
    output wire [31:0] WriteData,
    output wire [31:0] PC,
    output wire        Zero
);
    // Sinais internos
    wire [31:0] PCNext, PCPlus4, PCTarget;
    wire [31:0] ImmExt;
    wire [31:0] SrcA, SrcB;
    wire [31:0] Result;

    // ========== Program Counter ==========
    pc PC_REG (
        .clk(clk),
        .rst(rst),
        .pc_next(PCNext),
        .pc(PC)
    );

    // PC + 4
    adder PC_ADDER (
        .a(PC),
        .b(32'd4),
        .y(PCPlus4)
    );

    // PC Target (para branches)
    adder PC_TARGET_ADDER (
        .a(PC),
        .b(ImmExt),
        .y(PCTarget)
    );

    // Mux para selecionar próximo PC
    mux2x1 PC_MUX (
        .d0(PCPlus4),
        .d1(PCTarget),
        .sel(PCSrc),
        .y(PCNext)
    );

    // ========== Register File ==========
    register_file REGISTER_FILE (
        .clk(clk),
        .rst(rst),
        .we3(RegWrite),
        .ra1(Instr[19:15]),
        .ra2(Instr[24:20]),
        .wa3(Instr[11:7]),
        .wd3(Result),
        .rd1(SrcA),
        .rd2(WriteData)
    );

    // ========== Extend Unit ==========
    extend EXTEND_UNIT (
        .Instr(Instr[31:0]),
        .ImmSrc(ImmSrc),
        .ImmExt(ImmExt)
    );

    // ========== ALU ==========
    // Mux para segundo operando da ALU
    mux2x1 ALU_SRC_MUX (
        .d0(WriteData),
        .d1(ImmExt),
        .sel(ALUSrc),
        .y(SrcB)
    );

    // ALU
    alu ALU (
        .a(SrcA),
        .b(SrcB),
        .alu_ctrl(ALUControl),
        .result(ALUResult),
        .zero(Zero)
    );

    // ========== Result Mux ==========
    mux2x1 RESULT_MUX (
        .d0(ALUResult),
        .d1(ReadData),
        .sel(ResultSrc),
        .y(Result)
    );

endmodule