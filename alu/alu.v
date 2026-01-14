module alu (
    input  wire signed [31:0] a,         // TOPO: SrcA (geralmente RD1)
    input  wire signed [31:0] b,         // TOPO: SrcB (RD2 ou ImmExt via ALUSrc)
    input  wire signed [2:0]  alu_ctrl,  // TOPO: ALUControl
    output reg  signed [31:0] result,    // TOPO: ALUResult
    output reg  signed zero       // TOPO: Zero (para branch)
);
    reg [31:0] ResultReg;

    always @(*) begin
        if (result == 0) zero = 1;
        else zero = 0;

        case (alu_ctrl)
            3'b000: result <= a + b;                           // ADD (lw/sw)
            3'b001: result <= a - b;                           // SUB (beq)
            3'b010: result <= a & b;                           // AND
            3'b011: result <= a | b;                           // OR
            3'b101: result <= ($signed(a) < $signed(b)) ? 32'd1 : 32'd0; // SLT
            default: result <= 32'b0;
        endcase
    end
endmodule
