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
        $display("I - PC=%h | Instr=%h (esperado FFC4A303) | imm=%b - rs1=%b - f3=%b - rd=%b - op=%b", a, rd, rd[31:20], rd[19:15], rd[14:12], rd[11:7], rd[6:0]);

        // sw x6, 8(x9)
        a = 32'h0000_1004;
        #10;
        $display("S - PC=%h | Instr=%h (esperado 0064A423) | imm=%b - rs2=%b - rs1=%b - f3=%b - rd=%b - op=%b", a, rd, rd[31:25], rd[24:20], rd[19:15], rd[14:12], rd[11:7], rd[6:0]);

        // or x4, x5, x6
        a = 32'h0000_1008;
        #10;
        $display("R - PC=%h | Instr=%h (esperado 0062E233) | imm=%b - rs2=%b - rs1=%b - f3=%b - rd=%b - op=%b", a, rd, rd[31:25], rd[24:20], rd[19:15], rd[14:12], rd[11:7], rd[6:0]);

        // beq x4, x4, L7
        a = 32'h0000_100C;
        #10;
        $display("B - PC=%h | Instr=%h (esperado FE420AE3) | imm=%b - rs2=%b - rs1=%b - f3=%b - rd=%b - op=%b", a, rd, rd[31:25], rd[24:20], rd[19:15], rd[14:12], rd[11:7], rd[6:0]);

        #30;
        $finish;
    end
endmodule
