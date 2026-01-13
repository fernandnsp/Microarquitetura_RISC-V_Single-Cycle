module extend (
    input  wire [31:7] Instr,  // Instrucao que vem do instruction memory
    input  wire [1:0]  ImmSrc, // Vem do Control Unit
    output reg  [31:0] ImmExt
);
    always @(*) begin
        case (ImmSrc)
            2'b00: ImmExt = {{20{Instr[31]}}, Instr[31:20]}; // tipo I (lw)
            2'b01: ImmExt = {{20{Instr[31]}}, Instr[31:25], Instr[11:7]}; // tipo S (sw)
            2'b10: ImmExt = {{20{Instr[31]}}, Instr[7], Instr[30:25], Instr[11:8], 1'b0}; // B-type (beq)
            default: ImmExt = 32'b0; //melhor 0 pois temos esse tratamento na ALU do que o xxx..
        endcase
    end
endmodule
