module adder (
    input  wire [31:0] a,   // TOPO: PC
    input  wire [31:0] b,   // TOPO: 32'd4  (PCPlus4)
                           // TOPO: ImmExt (PCTarget)
    output wire [31:0] y    // TOPO: PCPlus4 ou PCTarget
);

    assign y = a + b;

endmodule