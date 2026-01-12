module instruction_memory #(
    parameter PATH_FILE = "./machine_language.txt",
    parameter WIDTH_WORD = 65535
) (
    input wire  [31:0] a, // PC
    output wire [31:0] rd // Instr
);
    localparam [31:0] PC_BASE_WORD = 32'h400;

    reg [31:0] rom [0:WIDTH_WORD];

    initial begin
        $readmemh(PATH_FILE, rom);
    end

    // 0x400 (1024) corresponde a 0x1000 >> 2
    // Necessário pois o PC inicia em 0x1000 (endereçado em bytes)
    // a[31:2] converte o PC para endereço por palavra
    assign rd = rom[a[31:2] - PC_BASE_WORD];
endmodule
