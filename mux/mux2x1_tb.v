module mux2x1_tb;
    reg  [31:0] d0;
    reg  [31:0] d1;
    reg         sel;
    wire [31:0] y;

    mux2x1 DUT (
        .d0(d0),
        .d1(d1),
        .sel(sel),
        .y(y)
    );

    initial begin
        d0 = 32'd10;
        d1 = 32'd20;

        sel = 0;
        #10;
        $display("sel=0 -> y=%d (esperado 10)", y);

        sel = 1;
        #10;
        $display("sel=1 -> y=%d (esperado 20)", y);

        $finish;
    end

    initial begin
        $dumpfile("mux2x1_tb.vcd");
        $dumpvars(0, mux2x1_tb);
    end
endmodule
