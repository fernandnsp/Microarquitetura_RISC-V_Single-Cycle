module pc_tb;
    reg  clk;      
    reg  rst;
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
        pc_next = 32'd0;
        #12;

        pc_next = 32'd15;

        #5;
        rst = 0;
        #5;

        pc_next = 32'd15;
        #20;
        pc_next = 32'd25;
        #40;
        $finish;
    end

endmodule