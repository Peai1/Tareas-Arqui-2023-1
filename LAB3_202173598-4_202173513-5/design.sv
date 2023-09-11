// Code your design here
module contador_binario(clk, reset, count);
    input logic clk, reset;
    output logic [5:0] count;

    always @ (posedge clk or posedge reset) begin
        if (reset) begin
            count <= 6'b0;
        end else begin
            count <= count + 1;
        end
    end
endmodule

module memoria_ROM(
    input logic [5:0] direccion,
    output logic [18:0] dato);
  
  	reg [18:0] mem [63:0];

    initial begin
    mem[0] = 19'b000_00010111_00010011;
    mem[1] = 19'b001_00000111_01001100;
    mem[2] = 19'b010_00011111_00000101;
    mem[3] = 19'b011_00011111_00000010;
    mem[4] = 19'b100_01011101_01010010;
    mem[5] = 19'b101_01011101_01010010;
    mem[6] = 19'b110_01011101_01010010;
    mem[7] = 19'b111_01011101_01010010;
      
    mem[8] = 19'b000_00011111_01110100;
    mem[9] = 19'b001_00101001_11001011;
    mem[10] = 19'b010_01010110_00101101;
    mem[11] = 19'b011_01100000_10010011;
    mem[12] = 19'b100_10010111_01010011;
    mem[13] = 19'b101_10101000_10101001;
    mem[14] = 19'b110_11011101_00001110;
    mem[15] = 19'b111_11101001_10110100;
    mem[16] = 19'b000_00001100_10101001;
    mem[17] = 19'b001_00111001_00100010;
    mem[18] = 19'b010_01000110_10000111;
    mem[19] = 19'b011_01110101_11110001;
    mem[20] = 19'b100_10000010_00100101;
    mem[21] = 19'b101_10110111_10110011;
    mem[22] = 19'b110_11001000_00010101;
    mem[23] = 19'b111_11111011_01111011;
    mem[24] = 19'b000_00001111_00100110;
    mem[25] = 19'b001_00111000_10010011;
    mem[26] = 19'b010_01000101_11101110;
    mem[27] = 19'b011_01110100_01011001;
    mem[28] = 19'b100_10000011_11011110;
    mem[29] = 19'b101_10110110_01001001;
    mem[30] = 19'b110_11001001_10100111;
    mem[31] = 19'b111_11111010_00010010;
    mem[32] = 19'b000_00001001_11011011;
    mem[33] = 19'b001_00111100_01001110;
    mem[34] = 19'b010_01000011_10100001;
    mem[35] = 19'b011_01110010_00010110;
    mem[36] = 19'b100_10000101_10001000;
    mem[37] = 19'b101_10110010_00111111;
    mem[38] = 19'b110_11001111_10010010;
    mem[39] = 19'b111_11111100_11101100;
    mem[40] = 19'b000_00001010_01111001;
    mem[41] = 19'b000_00001111_00100110;
    mem[42] = 19'b001_00111000_10010011;
    mem[43] = 19'b010_01000101_11101110;
    mem[44] = 19'b011_01110100_01011001;
    mem[45] = 19'b100_10000011_11011110;
    mem[46] = 19'b101_10110110_01001001;
    mem[47] = 19'b110_11001001_10100111;
    mem[48] = 19'b111_11111010_00010010;
    mem[49] = 19'b000_00001001_11011011;
    mem[50] = 19'b001_00111100_01001110;
    mem[51] = 19'b010_01000011_10100001;
    mem[52] = 19'b011_01110010_00010110;
    mem[53] = 19'b100_10000101_10001000;
    mem[54] = 19'b101_10110010_00111111;
    mem[55] = 19'b110_11001111_10010010;
    mem[56] = 19'b111_11111100_11101100;
    mem[57] = 19'b000_00001010_01111001;
    mem[58] = 19'b000_00001001_10001110;
    mem[59] = 19'b000_00001010_10101011;
    mem[60] = 19'b000_00001011_11011111;
    mem[61] = 19'b000_00001100_00110011;
    mem[62] = 19'b000_00001101_01101101;
    mem[63] = 19'b000_00001110_11111001;
  end

    always @ (direccion) begin
        dato = mem[direccion];
    end
endmodule

module splitter (
  input logic [18:0] dato,
  output logic [2:0] operacion,
  output logic [7:0] A,
  output logic [7:0] B );

  always @(*) begin
      operacion = dato[18:16];
      A = dato[15:8];
      B = dato[7:0];
  end

endmodule

module prefix_adder (
    input [7:0] A, 
    input [7:0] B, 
    output [7:0] SUM, 
    output cout
);
    logic [7:0] g, p, k, s;
    genvar i;

    // Propagacion y generacion
    assign p = A ^ B;
    assign g = A & B;

    // Kogge-Stone
    generate 
        for(i = 0; i < 8; i = i + 1) 
        begin : PREFIX
            if(i == 0) 
                assign k[i] = g[i];
            else 
                assign k[i] = g[i] | (p[i] & k[i-1]);
        end
    endgenerate

    // Carry out
    assign cout = k[7];

    // Suma
    assign s[0] = p[0];
    generate 
        for(i = 1; i < 8; i = i + 1) 
        begin : SUMA
            assign s[i] = p[i] ^ k[i-1];
        end
    endgenerate
    assign SUM = s;
endmodule


module ALU (
  input logic [2:0] operacion,
  input logic [7:0] A,
  input logic [7:0] B,
  output logic [7:0] resultado);
  
  logic [7:0] suma, resta, complementodos_B;
  logic cout1, cout2;
  
  // Complemento a dos
  assign complementodos_B = ~B + 8'b00000001; 
  
  prefix_adder prefix_suma(.A(A),.B(B),.SUM(suma),.cout(cout1));
  prefix_adder prefix_resta(.A(A),.B(complementodos_B),.SUM(resta),.cout(cout2));
  
  always @(*) begin
    case(operacion)
      3'b000:
        begin
          // SUMA
          resultado = suma;      
        end
      3'b001:
        begin
          // RESTA
          resultado = resta;
        end
      3'b010:
        begin
          // BITSHIFT IZQUIERDA
          resultado = A << B;
        end
      3'b011:
        begin
          // BITSHIFT DERECHA
          resultado = A >> B;
        end
      3'b100:
        begin
          // COMPOSICION 
          resultado = A & B;
        end
      3'b101:
        begin
          // DISYUNCION
          resultado = A | B;
        end
      3'b110:
        begin
          // EXCLUSION
          resultado = A ^ B;
        end
      3'b111:
        begin
          // NEGACION
          resultado = ~A;
        end
      
      default: resultado = 8'b0000_0000;
    endcase
  end
 
endmodule

module main (
  input logic clk,
  input logic reset,
  output logic [7:0] resultado,
  output logic [7:0] A_out,
  output logic [2:0] operacion_out,
  output logic [7:0] B_out,
  output logic [18:0] dato_out,
);

  logic [5:0] count;
  logic [18:0] dato;
  logic [2:0] operacion;
  logic [7:0] A, B;

  contador_binario contador(.clk(clk), .reset(reset), .count(count));
  memoria_ROM memoria(.direccion(count), .dato(dato));
  splitter splitter_inst(.dato(dato), .operacion(operacion), .A(A), .B(B));
  ALU alu_inst(.operacion(operacion), .A(A), .B(B), .resultado(resultado));

  assign A_out = A;
  assign operacion_out = operacion;
  assign B_out = B;
  assign dato_out = dato;
  
endmodule

