module pc (
    input  wire        clk,
    input  wire        rst,
    input  wire [31:0] pc_next,
    output reg  [31:0] pc
);
    // Endereço inicial padrão do RISC-V
    localparam [31:0] PC_RESET = 32'h0000_1000;

    always @(posedge clk or posedge rst) begin
        if (rst)
            pc <= PC_RESET;
        else
            pc <= pc_next;
    end
endmodule
