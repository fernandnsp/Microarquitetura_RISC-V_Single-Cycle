module alu_tb;
    reg  [31:0] a;
    reg  [31:0] b;
    reg  [2:0]  alu_ctrl;
    wire [31:0] result;
    wire        zero;

    alu DUT (
        .a(a),
        .b(b),
        .alu_ctrl(alu_ctrl),
        .result(result),
        .zero(zero)
    );

    initial begin
        // ADD
        a = 32'd10; b = 32'd5; alu_ctrl = 3'b010;
        #10;
        $display("ADD: %d + %d = %d", a, b, result);

        // SUB
        alu_ctrl = 3'b110;
        #10;
        $display("SUB: %d - %d = %d | zero=%b", a, b, result, zero);

        // AND
        alu_ctrl = 3'b000;
        #10;
        $display("AND: %b & %b = %b", a, b, result);

        // OR
        alu_ctrl = 3'b001;
        #10;
        $display("OR : %b | %b = %b", a, b, result);

        // SLT
        a = 32'd5; b = 32'd10; alu_ctrl = 3'b111;
        #10;
        $display("SLT: %d < %d = %d", a, b, result);

        // BEQ (zero flag) iguais
        a = 32'd20; b = 32'd20; alu_ctrl = 3'b110;
        #10;
        $display("BEQ test iguais: result=%d zero=%b", result, zero);

        // BEQ (zero flag) diferentes
        a = 32'd20; b = 32'd10; alu_ctrl = 3'b110;
        #10;
        $display("BEQ test diferentes: result=%d zero=%b", result, zero);

        $finish;
    end

    initial begin
        $dumpfile("alu_tb.vcd");
        $dumpvars(0, alu_tb);
    end
endmodule
