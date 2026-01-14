### Instruções
Necessário alterar o valor do campo `PATH_FILE` para o caminho completo que estiver o arquivo `machine_language.txt`, caso contrário, se tiver o gtkwave instalado rode o comando `gtkwave .\riscv_cpu.vcd` que está presente na raiz do projeto. Mas se quiser rodar novamente siga os passos abaixo.

Passos usando **iverilog** e **gtkwave**:
- Primeiro comando:
    ```shell
    iverilog .\adder\adder.v .\alu\alu.v .\control_unit\alu_decoder.v .\control_unit\control_unit.v .\control_unit\main_decoder.v .\data_memory\data_memory.v .\extend\extend.v .\instruction_memory\instruction_memory.v .\mux\mux2x1.v .\pc\pc.v .\register_file\register_file.v .\datapath\datapath.v .\system_cycle\cpu.v .\system_cycle\system_cycle.v .\system_cycle\tb_cpu.v
    ```
- Segundo comando: `vvp .\a.out`
- Terceiro comando: `gtkwave .\riscv_cpu.vcd`

