module alu_decoder (
    input  wire [1:0] ALUOp,
    input  wire [2:0] funct3,
    input  wire       funct7_5, // Bit 30 da instrução (Instr[30]) e bit 5 do funct7 para definir se add ou sub
    input  wire       op_5, // Bit 5 do opcode (distingue R-type de I-type)
    output reg  [2:0] ALUControl
);
    always @(*) begin
        case (ALUOp)
            2'b00: ALUControl = 3'b000; // ADD (lw/sw) -> Não depende do funct3, nem op5 e funct7_5
            2'b01: ALUControl = 3'b001; // SUB para comparação (beq) -> Não depende do funct3, nem op5 e funct7_5
            2'b10: begin // R-type ou I-type ALU
                case (funct3)
                    3'b000: begin // depende do op5 e funct7_5
                        if (op_5 && funct7_5)
                            ALUControl = 3'b001; // SUB (sub instrução)
                        else
                            ALUControl = 3'b000; // // ADD (add)
                    end
                    3'b010: ALUControl = 3'b101; // SLT
                    3'b110: ALUControl = 3'b011; // OR
                    3'b111: ALUControl = 3'b010; // AND
                    default: ALUControl = 3'bx;
                endcase
            end
            default: ALUControl = 3'bx;
        endcase
    end
endmodule
