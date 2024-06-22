module ALU (Ain, Bin, ALUop, out, Z);
    input [15:0] Ain, Bin;
    input [1:0] ALUop;
    output reg [15:0] out;
    output reg Z;
   // wire [15:0] add, subtract, anded, noted;


        // Compute the output value based on the ALU-operation input value
  /*  add = Ain + Bin;
    subtract = Ain - Bin;
    anded = Ain & Bin;
    noted = ~Bin;

    muxALU #(16) mx(add, subtract, anded, noted, ALUop, out); 
        
    assign Z = out ? 1'b0 : 1'b1; */
   



// 5 input k-wide multiplexer, with input signal ALUop.
/*module muxALU(add, subtract, anded, noted, ALUop, out);
	parameter k=1;
	input [k-1:0] add, subtract, anded, noted;
	input [1:0] ALUop;
	output reg[k-1:0] out;
	*/
	always @(*) begin
		case(ALUop)
			2'b00: out = Ain + Bin;
			2'b01: out = Ain - Bin;
			2'b10: out = Ain & Bin;
			2'b11: out = ~Bin;
			default: out = {16{1'bx}};
		endcase

		Z = out ? 1'b0 : 1'b1;
	end
endmodule













