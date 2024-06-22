module datapath_tb;
    reg [15:0] datapath_in;
    reg err, asel, bsel, vsel, write, clk, loada, loadb, loadc, loads;
    reg [2:0] writenum, readnum;
    reg [1:0] shift, ALUop;
    wire [15:0] datapath_out;
    wire Z_out;
    
    datapath DUT ( .clk (clk),

     // register operand fetch stage
    .readnum     (readnum),
    .vsel        (vsel),
    .loada       (loada),
    .loadb       (loadb),

    // computation stage (sometimes called "execute")
    .shift       (shift),
    .asel        (asel),
    .bsel        (bsel),
    .ALUop       (ALUop),
    .loadc       (loadc),
    .loads       (loads),

    // set when "writing back" to register file
    .writenum    (writenum),
    .write       (write),  
    .datapath_in (datapath_in),

    // outputs
    .Z_out       (Z_Out),
    .datapath_out(datapath_out)
    );

    task check_Reg ; //Create an automated checker that compares the states and outputs.
  	    input [15:0] expected_out ;
	    begin
		    if( datapath_tb.DUT.REGFILE.data_out !== expected_out ) begin //If the outputs are not the same then print stating the wrong output and the expected output.
			    $display ("ERROR ** output is %b, expected %b",
				    datapath_tb.DUT.REGFILE.data_out, expected_out ) ;
			    err = 1'b1;
		    end
	    end
	endtask

    task check_ALU;
        // The inputs to our self_checking module (Testing inputs):
        input [15:0] expected_output;
        input expected_Z;
        begin
            //'ALU_tb.DUT.out' checks the internal signals of DUT
            if (datapath_tb.DUT.U2.out !== expected_output) begin   
                $display("ERROR: ** out is %b, expected %b", datapath_tb.DUT.U2.out, expected_output );
                err = 1'b1;
            end

            if (datapath_tb.DUT.U2.Z !== expected_Z) begin
                $display("ERROR: ** Z is %b, expected %b",datapath_tb.DUT.U2.Z, expected_Z);
                err = 1'b1;
            end
        end
    endtask

    initial begin
        clk = 0; #5;
        forever begin
            clk = 1; #5;
            clk = 0; #5;
        end
    end

    initial begin
        err = 1'b0;
        
        datapath_in = 16'd7; vsel = 1'b1; writenum = 3'b000; write = 1'b1; readnum = 3'b000; #10;
        check_Reg(16'd7);

        datapath_in = 16'd2; vsel = 1'b1; writenum = 3'b001; write = 1'b1; readnum = 3'b001; #10;
        check_Reg(16'd2);

        //R2 = R1 + (R0 shifted to the left by 1) = 2 + 14 = 16.
        write = 1'b0; readnum = 3'b001; loada = 1'b1; #10;
        readnum = 3'b000; loada = 1'b0; loadb = 1'b1; #10;
        loadb = 1'b0; shift = 2'b01; asel = 0; bsel = 0; ALUop = 2'b00; loadc = 1; loads = 1; #10;
        check_ALU(16'd16, 1'b0);

        loadb = 1'b0; loada = 1'b0; loadc = 1'b0; loads = 1'b0; vsel = 1'b0; writenum = 1'b010; write = 1'b1; readnum = 1'b010; #10;
        check_Reg(16'd16);

        if (~err) $display("PASSED");
        else $display("FAILED");
        $stop;
    end
endmodule