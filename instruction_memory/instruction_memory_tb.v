module instruction_memory_tb;
    reg  [31:0] a;  // PC
    wire [31:0] rd; // Instr

    instruction_memory #(
        .PATH_FILE("C:/Users/fehse/Documents/unifei/cidigital/fernanda/entregas/Trabalho/Microarquitetura_RISC-V_Single-Cycle/machine_language.txt"),
        .WIDTH_WORD(65535)
    ) DUT (
        .a(a),
        .rd(rd)
    );

    initial begin
        // lw x6, -4(x9)
        a = 32'h0000_1000;
        #10;
        $display("PC=%h | Instr=%h (esperado FFC4A303)", a, rd);

        // sw x6, 8(x9)
        a = 32'h0000_1004;
        #10;
        $display("PC=%h | Instr=%h (esperado 0064A423)", a, rd);

        // or x4, x5, x6
        a = 32'h0000_1008;
        #10;
        $display("PC=%h | Instr=%h (esperado 0062E233)", a, rd);

        // beq x4, x4, L7
        a = 32'h0000_100C;
        #10;
        $display("PC=%h | Instr=%h (esperado FE420AE3)", a, rd);

        // Teste de alinhamento (PC não múltiplo de 4)
        a = 32'h0000_1006;
        #10;
        $display("PC=%h | Instr=%h (esperado 0064A423)", a, rd);

        #30;
        $finish;
    end
endmodule
