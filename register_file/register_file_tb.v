module register_file_tb;
    reg         clk;
    reg         rst;
    reg         we3;
    reg  [4:0]  ra1, ra2, wa3;
    reg  [31:0] wd3;
    wire [31:0] rd1, rd2;

    register_file dut (
        .clk(clk),
        .rst(rst),
        .we3(we3),
        .ra1(ra1),
        .ra2(ra2),
        .wa3(wa3),
        .wd3(wd3),
        .rd1(rd1),
        .rd2(rd2)
    );

    always #5 clk = ~clk;

    initial begin
        clk = 0;
        rst = 1;
        we3 = 0;
        ra1 = 0;
        ra2 = 0;
        wa3 = 0;
        wd3 = 0;

        #10;
        rst = 0;

        // Escrita no registrador x1
        we3 = 1;
        wa3 = 5'd1;
        wd3 = 32'hAAAAAAAA;
        #10;
        we3 = 0;

        // Leitura assíncrona
        ra1 = 5'd1;
        ra2 = 5'd0; // x0
        #5;

        // Escrita no registrador x2
        we3 = 1;
        wa3 = 5'd2;
        wd3 = 32'h12345678;
        #10;
        we3 = 0;

        ra1 = 5'd2;
        ra2 = 5'd1;
        #5;

        // Tentativa de escrita no x0
        we3 = 1;
        wa3 = 5'd0;
        wd3 = 32'hFFFFFFFF;
        #10;
        we3 = 0;

        ra1 = 5'd0;
        ra2 = 5'd1;
        #5;

        // Escrita e leitura simultânea
        we3 = 1;
        wa3 = 5'd3;
        wd3 = 32'hDEADBEEF;
        ra1 = 5'd3;
        ra2 = 5'd2;
        #10;
        we3 = 0;
        #30;
        $finish;
    end

    initial begin
        $dumpfile("register_file_tb.vcd");
        $dumpvars(0, register_file_tb);
    end
endmodule
