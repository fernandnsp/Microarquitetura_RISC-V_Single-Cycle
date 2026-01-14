module extend (
    input  wire [31:0] Instr,  // Instrucao que vem do instruction memory
    input  wire [1:0]  ImmSrc, // Vem do Control Unit
    output wire [31:0] ImmExt
);
    reg [31:0] ImmExtReg;

    always @(*) begin
        case (ImmSrc)
            2'b00: ImmExtReg = {{20{Instr[31]}}, Instr[31:20]}; // tipo I (lw)
            2'b01: ImmExtReg = {{20{Instr[31]}}, Instr[31:25], Instr[11:7]}; // tipo S (sw)
            2'b10: ImmExtReg = {{20{Instr[31]}}, Instr[7], Instr[30:25], Instr[11:8], 1'b0}; // B-type (beq)
            default: ImmExtReg = 32'b0;
        endcase
    end

    assign ImmExt = ImmExtReg;
endmodule
