module cpu (
    input  wire        clk,
    input  wire        rst,
    output wire        MemWrite,
    output wire [31:0] WriteData,
    output wire [31:0] ALUResult,
    output wire [31:0] Instr
);
    wire [31:0] PC, ReadData;

    system_cycle SYSTEM (
        // datapath
        .clk(clk),               // input modulo
        .rst(rst),               // input modulo
        .Instr(Instr),           // input modulo
        .ReadData(ReadData),     // input modulo
        .PC(PC),                 // saida
        .MemWrite(MemWrite),     // saida
        .ALUResult(ALUResult),   // saida
        .WriteData(WriteData)    // saida
    );

    instruction_memory #(
        .PATH_FILE("C:/Users/nandinhaplay/Documents/unifei/cidigital/fernanda/entregas/Trabalho/Microarquitetura_RISC-V_Single-Cycle/machine_language.txt")
    ) INSTR (
        .a(PC),     // input datapath
        .rd(Instr)  // saida
    );

    data_memory DATA_MEMORY (
        .clk(clk),
        .we(MemWrite),  // input control_unit
        .a(ALUResult),  // input datapath
        .wd(WriteData), // input datapath
        .rd(ReadData)   // saida
    );
endmodule
