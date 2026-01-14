`timescale 1ns/1ps

module datapath_tb;

    // Sinais do clock e reset
    reg clk;
    reg rst;

    // Sinais de controle
    reg        PCSrc;
    reg        ResultSrc;
    reg        ALUSrc;
    reg        RegWrite;
    reg  [1:0] ImmSrc;
    reg  [2:0] ALUControl;

    // Sinais de memória
    wire [31:0] ALUResult;
    wire [31:0] WriteData;
    reg  [31:0] ReadData;
    wire [31:0] PC;
    reg  [31:0] Instr;
    wire        Zero;

    // Instanciação do datapath
    datapath dut (
        .clk(clk),
        .rst(rst),
        .PCSrc(PCSrc),
        .ResultSrc(ResultSrc),
        .ALUSrc(ALUSrc),
        .RegWrite(RegWrite),
        .ImmSrc(ImmSrc),
        .ALUControl(ALUControl),
        .ALUResult(ALUResult),
        .WriteData(WriteData),
        .ReadData(ReadData),
        .PC(PC),
        .Instr(Instr),
        .Zero(Zero)
    );

    // Geração do clock (período de 10ns)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    // Simulação de memórias externas
    reg [31:0] data_mem [0:1023];
    reg [31:0] instr_mem [0:1023];

    // Inicialização das memórias
    initial begin
        // Instruções do programa exemplo (Figure 7.2)
        instr_mem[0] = 32'hFFC4A303; // lw x6, -4(x9)   @ 0x1000
        instr_mem[1] = 32'h0064A423; // sw x6, 8(x9)    @ 0x1004
        instr_mem[2] = 32'h0062E233; // or x4, x5, x6   @ 0x1008
        instr_mem[3] = 32'hFE420AE3; // beq x4, x4, L7  @ 0x100C

        // Inicialização da memória de dados
        data_mem[32'h2000 >> 2] = 32'd10; // Endereço 0x2000 contém 10
    end

    // Lógica para simular memória de instruções
    always @(*) begin
        Instr = instr_mem[(PC - 32'h1000) >> 2];
    end

    // Lógica para simular memória de dados
    always @(*) begin
        ReadData = data_mem[ALUResult >> 2];
    end

    // Escrita na memória de dados (síncrona com clock)
    always @(posedge clk) begin
        if (RegWrite && ResultSrc) begin // sw instruction
            data_mem[ALUResult >> 2] <= WriteData;
        end
    end

    // Teste do programa
    initial begin
        $dumpfile("datapath_tb.vcd");
        $dumpvars(0, datapath_tb);

        // Inicialização
        rst = 1;
        PCSrc = 0;
        ResultSrc = 0;
        ALUSrc = 0;
        RegWrite = 0;
        ImmSrc = 2'b00;
        ALUControl = 3'b000;
        ReadData = 32'b0;

        // Inicializar registradores x5 e x9 manualmente
        #10;
        rst = 0;

        // Forçar valores iniciais nos registradores (simulando estado inicial)
        force dut.RegFile.registers[5] = 32'd6;      // x5 = 6
        force dut.RegFile.registers[9] = 32'h2004;   // x9 = 0x2004
        #1;
        release dut.RegFile.registers[5];
        release dut.RegFile.registers[9];

        $display("\n========== INÍCIO DA SIMULAÇÃO ==========");
        $display("Estado inicial:");
        $display("  x5 = %d", dut.RegFile.registers[5]);
        $display("  x9 = 0x%h", dut.RegFile.registers[9]);
        $display("  mem[0x2000] = %d", data_mem[32'h2000 >> 2]);

        // ========== Ciclo 1: lw x6, -4(x9) ==========
        $display("\n========== CICLO 1: lw x6, -4(x9) @ PC=0x%h ==========", PC);
        RegWrite = 1;
        ImmSrc = 2'b00;    // Tipo I
        ALUSrc = 1;        // SrcB = ImmExt
        MemWrite = 0;
        ResultSrc = 1;     // Result = ReadData
        PCSrc = 0;
        ALUControl = 3'b000; // ADD

        #10;
        $display("  ImmExt = 0x%h (signed: %d)", dut.ImmExt, $signed(dut.ImmExt));
        $display("  SrcA = 0x%h", dut.SrcA);
        $display("  SrcB = 0x%h", dut.SrcB);
        $display("  ALUResult (endereço) = 0x%h", ALUResult);
        $display("  ReadData = %d", ReadData);
        $display("  x6 = %d (após escrita)", dut.RegFile.registers[6]);

        // ========== Ciclo 2: sw x6, 8(x9) ==========
        #10;
        $display("\n========== CICLO 2: sw x6, 8(x9) @ PC=0x%h ==========", PC);
        RegWrite = 0;
        ImmSrc = 2'b01;    // Tipo S
        ALUSrc = 1;
        MemWrite = 1;
        ResultSrc = 0;     // Don't care
        PCSrc = 0;
        ALUControl = 3'b000;

        #10;
        $display("  ImmExt = 0x%h (%d)", dut.ImmExt, $signed(dut.ImmExt));
        $display("  ALUResult (endereço) = 0x%h", ALUResult);
        $display("  WriteData = %d", WriteData);
        $display("  mem[0x%h] = %d (após escrita)", ALUResult, data_mem[ALUResult >> 2]);

        // ========== Ciclo 3: or x4, x5, x6 ==========
        #10;
        $display("\n========== CICLO 3: or x4, x5, x6 @ PC=0x%h ==========", PC);
        RegWrite = 1;
        ImmSrc = 2'b00;    // Don't care
        ALUSrc = 0;        // SrcB = RD2
        MemWrite = 0;
        ResultSrc = 0;     // Result = ALUResult
        PCSrc = 0;
        ALUControl = 3'b011; // OR

        #10;
        $display("  SrcA (x5) = %d (0b%b)", dut.SrcA, dut.SrcA[3:0]);
        $display("  SrcB (x6) = %d (0b%b)", dut.SrcB, dut.SrcB[3:0]);
        $display("  ALUResult = %d (0b%b)", ALUResult, ALUResult[3:0]);
        $display("  x4 = %d (após escrita)", dut.RegFile.registers[4]);

        // ========== Ciclo 4: beq x4, x4, L7 ==========
        #10;
        $display("\n========== CICLO 4: beq x4, x4, L7 @ PC=0x%h ==========", PC);
        RegWrite = 0;
        ImmSrc = 2'b10;    // Tipo B
        ALUSrc = 0;
        MemWrite = 0;
        ResultSrc = 0;     // Don't care
        ALUControl = 3'b001; // SUB (para comparação)

        // Calcular PCSrc baseado em Zero
        #1;
        PCSrc = Zero; // Branch taken se Zero = 1

        #9;
        $display("  SrcA (x4) = %d", dut.SrcA);
        $display("  SrcB (x4) = %d", dut.SrcB);
        $display("  Zero = %b (branch %s)", Zero, Zero ? "taken" : "not taken");
        $display("  ImmExt (offset) = 0x%h (%d)", dut.ImmExt, $signed(dut.ImmExt));
        $display("  PCTarget = 0x%h", dut.PCTarget);
        $display("  PCNext = 0x%h", dut.PCNext);

        // ========== Verificação do branch (volta para 0x1000) ==========
        #10;
        $display("\n========== Após Branch @ PC=0x%h ==========", PC);
        $display("  PC voltou para 0x1000? %s", (PC == 32'h1000) ? "SIM" : "NÃO");

        // Estado final
        $display("\n========== ESTADO FINAL DOS REGISTRADORES ==========");
        $display("  x4 = %d", dut.RegFile.registers[4]);
        $display("  x5 = %d", dut.RegFile.registers[5]);
        $display("  x6 = %d", dut.RegFile.registers[6]);
        $display("  x9 = 0x%h", dut.RegFile.registers[9]);

        $display("\n========== ESTADO FINAL DA MEMÓRIA ==========");
        $display("  mem[0x2000] = %d", data_mem[32'h2000 >> 2]);
        $display("  mem[0x200C] = %d", data_mem[32'h200C >> 2]);

        // Executar mais alguns ciclos para ver o loop
        $display("\n========== LOOP: Executando mais 4 ciclos ==========");
        repeat(4) #10;

        #50;
        $display("\n========== FIM DA SIMULAÇÃO ==========\n");
        $finish;
    end

    // Monitor para debug contínuo
    initial begin
        $monitor("Time=%0t | PC=0x%h | Instr=0x%h | Zero=%b | ALUResult=0x%h",
                 $time, PC, Instr, Zero, ALUResult);
    end

endmodule