module main_decoder (
    input  wire [6:0] op,
    output wire       ResultSrc,
    output wire       MemWrite,
    output wire       RegWrite,
    output wire       Branch,
    output wire       ALUSrc,
    output wire [1:0] ImmSrc,
    output wire [1:0] ALUOp
);
    // Decodificador de instruções para a undiade de controle
    reg [8:0] instruction;

    always @(*) begin
        case (op)
            7'b0000011: instruction = 1_00_1_0_1_0_00; // lw (load word)
            7'b0100011: instruction = 0_01_1_1_0_0_00; // sw (store word)
            7'b0110011: instruction = 1_00_0_0_0_0_10; // R-type (add, sub, and, or, slt)
            7'b1100011: instruction = 0_10_0_0_0_1_01; // beq
            default: instruction = 0_00_0_0_0_0_00;
        endcase
    end

    assign {
        RegWrite,  // instruction[8] - Habilita escrita no banco de registradores
        ImmSrc,    // instruction[7:6] - Seleciona tipo de imediato (00=I, 01=S, 10=B) -> No livro explica melhor
        ALUSrc,    // instruction[5] - Seleciona entrada B da ALU (0=RD2, 1=ImmExt)
        MemWrite,  // instruction[4] - Habilita escrita na memória de dados
        ResultSrc, // instruction[3] - Seleciona resultado (00=ALU, 01=Mem)
        Branch,    // instruction[2] - Indica instrução de branch
        ALUOp      // instruction[1:0] - Tipo de operação para o ALUDecoder
    } = instruction;
endmodule