module data_memory (
    input wire         clk,
    input wire         we, // MemWrite
    input wire  [31:0] a,  // ALUResult (endereço em bytes)
    input wire  [31:0] wd, // WriteData
    output wire [31:0] rd  // ReadData
);
    reg [31:0] ram [0:65535]; // memória de 64k palavras de 32 bits

    wire [31:0] addr_word;
    assign addr_word = a[31:2]; // converte byte -> palavra

    // Leitura assíncrona
    assign rd = ram[addr_word];

    // Escrita síncrona
    always @(posedge clk) begin
        if (we)
            ram[addr_word] <= wd;
    end

    // Inicialização para simulação
    initial begin
        ram[32'h2000 >> 2] = 32'd10;
    end
endmodule
