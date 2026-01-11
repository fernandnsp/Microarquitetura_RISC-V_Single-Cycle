module adder_tb;
    reg  [31:0] a;
    reg  [31:0] b;
    wire [31:0] y;

    adder DUT (
        .a(a),
        .b(b),
        .y(y)
    );

    initial begin
        $monitor("%d + %d = %d" , a, b, y);

        a = 32'd0; b = 32'd4;
        #10;

        a = 32'd100; b = 32'd4;
        #10;

        a = 32'd20; b = 32'd16;
        #10;

        $finish;
    end

    initial begin
        $dumpfile("adder_tb.vcd");
        $dumpvars(0, adder_tb);
    end
endmodule