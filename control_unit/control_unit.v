module control_unit (
    input  wire [6:0] op,
    input  wire [2:0] funct3,
    input  wire       funct7_5,
    input  wire       Zero,
    output wire       PCSrc,
    output wire       ResultSrc,
    output wire       MemWrite,
    output wire       ALUSrc,
    output wire       RegWrite,
    output wire [1:0] ImmSrc,
    output wire [2:0] ALUControl
);
    wire [1:0] ALUOp;
    wire Branch;

    main_decoder MainDecoder (
        .op(op),
        .ResultSrc(ResultSrc),
        .MemWrite(MemWrite),
        .RegWrite(RegWrite),
        .Branch(Branch),
        .ALUSrc(ALUSrc),
        .ImmSrc(ImmSrc),
        .ALUOp(ALUOp)
    );

    alu_decoder ALUDecoder (
        .ALUOp(ALUOp),
        .funct3(funct3),
        .funct7_5(funct7_5),
        .op_5(op[5]),
        .ALUControl(ALUControl)
    );

    assign PCSrc = Zero & Branch;
endmodule
