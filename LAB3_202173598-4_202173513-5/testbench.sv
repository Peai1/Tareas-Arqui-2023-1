module testbench;
  logic clk, reset;
  logic [7:0] resultado, A_out, B_out;
  logic [2:0] operacion_out;
  logic [18:0] dato_out;
  
  // Instanciar el módulo main
  main main_inst(.clk(clk), .reset(reset), .resultado(resultado), .A_out(A_out), .operacion_out(operacion_out), .B_out(B_out), .dato_out(dato_out));
  
  // Generar una señal de reloj
  always #5 clk = ~clk;
  always #10 clk = ~clk;
  
  // Proceso de reset y lectura de memoria por cada dirección
  initial begin
    $dumpfile("dump.vcd");
  	$dumpvars(0, testbench);
    clk = 0;
    reset = 1;
    #10 
    reset = 0; // Desactivar reset
    $display("Instruccion (Hex)  Operacion  Inmediato A  Inmediato B  Resultado");
    
    // Leer cada dirección de memoria
    repeat (64) begin
      #10;      
      if (operacion_out == 3'b111)
        $display("%h              %b        %b     Ignorado     %b", dato_out, operacion_out, A_out, resultado);
      else
        $display("%h              %b        %b     %b     %b", dato_out, operacion_out, A_out, B_out, resultado);
      #10;
    end
    
    $finish; // Terminar la simulación después de leer todas las direcciones
  end
endmodule