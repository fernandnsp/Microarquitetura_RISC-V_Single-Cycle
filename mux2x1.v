module mux2x1 (
    input  wire [31:0] d0,   // RD2, ALUResult ou PCPlus4
    input  wire [31:0] d1,   // ImmExt, ReadData ou PCTarget
    input  wire        sel,  // ALUSrc, ResultSrc ou PCSrc
    output wire [31:0] y     // SrcB, Result ou PCNext
);

    assign y = sel ? d1 : d0;

endmodule