module pc_tb;
    reg         clk;
    reg         rst;
    reg  [31:0] pc_next;
    wire [31:0] pc;

    pc DUT (
        .clk(clk),
        .rst(rst),
        .pc_next(pc_next),
        .pc(pc)
    );

    always #5 clk = ~clk;

    initial begin
        clk = 0;
        rst = 1;
        pc_next = 32'h0000_0000;

        #10;
        rst = 0;

        $display("PC = %h (esperado 00001000)", pc);
        #10;

        pc_next = 32'h0000_1004;
        #10;
        $display("PC = %h (esperado 00001004)", pc);

        pc_next = 32'h0000_1008;
        #10;
        $display("PC = %h (esperado 00001008)", pc);

        pc_next = 32'h0000_1010;
        #10;
        $display("PC = %h (esperado 00001010)", pc);

        #30;
        $finish;
    end

    initial begin
        $dumpfile("pc_tb.vcd");
        $dumpvars(0, pc_tb);
    end
endmodule
