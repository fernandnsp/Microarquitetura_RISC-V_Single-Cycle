module tb_cpu;
    reg clk, rst;
    wire [31:0] WriteData, ALUResult;
    wire MemWrite;
    wire [31:0] Instr;

    // Clock: alterna a cada 10 unidades de tempo
    always #10 clk = ~clk;

    // Instância da CPU
    cpu DUT (
        .clk(clk),
        .rst(rst),
        .WriteData(WriteData),
        .ALUResult(ALUResult),
        .MemWrite(MemWrite),
        .Instr(Instr)
    );

    // Dump para GTKWave
    initial begin
        $dumpfile("riscv_cpu.vcd");
        $dumpvars(0, tb_cpu);
    end

    initial begin
        // Inicialização
        clk = 0;
        rst = 1;
        #25 rst = 0;

        // Roda a simulação por tempo máximo
        #1000;

        $display("Simulacao terminou por timeout");
        $finish;
    end

    // Monitoramento da escrita na memória
    always @(posedge clk) begin
        if (MemWrite) begin
            $display("STORE: Addr=%0d, Data=%0d", ALUResult, WriteData);
        end
    end
endmodule