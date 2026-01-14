module register_file(
    input wire         clk,
    input wire         rst,           // rst assíncrono para simulação
    input wire         we3,           // (RegWrite) Write Enable
    input wire  [4:0]  ra1, ra2, wa3, // Endereços dos registradores
    input wire  [31:0] wd3,           // Dado a ser escrito
    output wire [31:0] rd1, rd2       // Dados lidos
);
    reg [31:0] registers[31:0];       // Banco de registradores
    integer i;

    // Escrita síncrona
    always @(posedge clk) begin
        if (rst) begin
            for (i = 0; i < 32; i = i + 1)
                registers[i] = 32'b0;

            registers[5] <= 32'd6;
            registers[9] <= 32'h2004;
        end else if (we3 && wa3 != 0) begin
            // Escreve no registrador se habilitado e diferente de x0
            registers[wa3] <= wd3;
        end
    end
    // Leitura assíncrona
    assign rd1 = (ra1 != 0) ? registers[ra1] : 32'b0;
    assign rd2 = (ra2 != 0) ? registers[ra2] : 32'b0;
endmodule
