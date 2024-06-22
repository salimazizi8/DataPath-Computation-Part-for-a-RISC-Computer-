module datapath (datapath_in, asel, bsel, vsel, writenum, write, readnum, clk, loada, loadb, loadc, loads, shift, ALUop, datapath_out, Z_out) ;
    input [15:0] datapath_in;
    input [2:0] writenum, readnum;
    input [1:0] shift, ALUop;
    input asel, bsel, vsel, write, clk, loada, loadb, loadc, loads;
    output [15:0] datapath_out;
    output Z_out;
    wire [15:0] data_in, data_out, in, aselin, sout, ain, bin, out;
    wire _Z;
    wire [15:0] datapath_out;
    
    regfile REGFILE (data_in, writenum, write, readnum, clk, data_out); //Istantiate the main register module.
    //Instantiate the 3 other registers the hold values throughout the datapath.
    register reg_A (data_out, loada, clk, aselin);
    register reg_B (data_out, loadb, clk, in);
    register reg_C (out, loadc, clk, datapath_out);
    register #(1) status (_Z, loads, clk, Z_out);
    shifter U1 (in, shift, sout); //Instantiate the shifter module that shifts bits based on the shift input.
    ALU U2 (ain, bin, ALUop, out, _Z); //Instatiate the ALU that adds, subtracts, ands, or nots based on the value of ALUop.


    assign data_in = vsel ? datapath_in : datapath_out; //A MUX that chooses which data should be passed on to the main register module.
    assign ain = asel ? 16'b0 : aselin; //A MUX that decides the value of the ain for the ALU module based on the value of asel.
    assign bin = bsel ? {11'b0, datapath_in[4:0]} : sout; //A MUX that decides the value of the bin for the ALU module based on the value of bsel.


endmodule