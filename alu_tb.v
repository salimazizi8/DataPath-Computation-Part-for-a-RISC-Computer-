module ALU_tb;
    // Declaring internal signals for our Testbench:

    reg [15:0] Ain, Bin;
    reg [1:0] ALUop;
    wire [15:0] out;
    wire Z;
    // Error signal:
    reg err;
    

    // Instantiating ALU (Arithmetic Logic Unit) module:
    ALU DUT (Ain, Bin, ALUop, out, Z);

    // Declaring a Task (Self-Checking Test) to avoid repetitive testing:
    task self_checker;
        // The inputs to our self_checking module (Testing inputs):
        input [15:0] expected_output;
        input expected_Z;

        begin
            //'ALU_tb.DUT.out' checks the internal signals of DUT
            if (ALU_tb.DUT.out !== expected_output) begin   
                $display("ERROR: ** out is %b, expected %b", ALU_tb.DUT.out, expected_output );
                err = 1'b1;
            end

            if (ALU_tb.DUT.Z !== expected_Z) begin
                $display("ERROR: ** Z is %b, expected %b", ALU_tb.DUT.Z, expected_Z);
                err = 1'b1;
            end

        
        end

    endtask

    initial begin
	// At the beginning the 'err' signal is set to 0:
	err= 1'b0;
        ALUop = 2'b00; // Adding
        Ain = 16'b1110_0011_1010_1101;
        Bin = 16'b0100_0011_1000_1011;

	#10; 
        self_checker(16'b0010_0111_0011_1000, 1'b0);

	// Subtracting Ain and Bin:
        ALUop= 2'b01;
	#10;
        self_checker(16'b1010000000100010, 1'b0);


        // ANDing Ain and Bin:
        ALUop = 2'b10;
	#10;
        self_checker(16'b01000_0111_0001_001, 1'b0);
        
        

        // NOT Bin:
        ALUop = 2'b11;
	#10;
        self_checker(16'b1011_1100_0111_0100, 1'b0);


        if (~err) begin 
		 $display("PASSED");
        end else begin 
		$display("FAILED");
	end

    end

endmodule