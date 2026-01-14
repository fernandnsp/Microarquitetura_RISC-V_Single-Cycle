module system_cycle (
    input  wire        clk,
    input  wire        rst,
    input  wire [31:0] ReadData,
    input  wire [31:0] Instr,
    output wire [31:0] PC,
    output wire        MemWrite,
    output wire [31:0] ALUResult,
    output wire [31:0] WriteData
);
    // datapath
    wire       PCSrc;
    wire       ResultSrc;
    wire       ALUSrc;
    wire       RegWrite;
    wire       Zero;
    wire [1:0] ImmSrc;
    wire [2:0] ALUControl;

    // control_unit
    wire [6:0] op;
    wire [2:0] funct3;
    wire       funct7_5;

    assign op = Instr[6:0];
    assign funct3 = Instr[14:12];
    assign funct7_5 = Instr[30];

    datapath DATAPATH (
        .clk(clk),               // input modulo
        .rst(rst),               // input modulo
        .PCSrc(PCSrc),           // input control_unit
        .ResultSrc(ResultSrc),   // input control_unit
        .ALUSrc(ALUSrc),         // input control_unit
        .RegWrite(RegWrite),     // input control_unit
        .ImmSrc(ImmSrc),         // input control_unit
        .ALUControl(ALUControl), // input control_unit
        .ReadData(ReadData),     // input modulo
        .Instr(Instr),           // input modulo
        .ALUResult(ALUResult),   // saida
        .WriteData(WriteData),   // saida
        .PC(PC),                 // saida
        .Zero(Zero)              // saida
    );

    control_unit CONTROL_UNIT (
        .op(op),                // input instruction_memory
        .funct3(funct3),        // input instruction_memory
        .funct7_5(funct7_5),    // input instruction_memory
        .Zero(Zero),            // input datapath
        .PCSrc(PCSrc),          // saida
        .ResultSrc(ResultSrc),  // saida
        .MemWrite(MemWrite),    // saida
        .ALUSrc(ALUSrc),        // saida
        .RegWrite(RegWrite),    // saida
        .ImmSrc(ImmSrc),        // saida
        .ALUControl(ALUControl) // saida
    );
endmodule
