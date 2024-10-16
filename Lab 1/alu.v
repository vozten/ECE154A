module alu(input [31:0] a, b,
	input [2:0] f,
	output [31:0] result,
	output zero,
	output overflow,
	output carry,
	output negative);
	
	wire [31:0] twomuxout; // output of 2-1 mux controlled by ALUControl_0
	wire cout; // carry out bit of 32-bit adder
	wire [31:0] sum; // sum of 32-bit adder
	wire xnorout; // wire to hold value of XNOR output
	wire xorout; // wire to hold value of XOR output
	wire [31:0] zeroed; // output after ZeroExt
	
	assign twomuxout = (f[0]) ? ~b : b;
	
	assign {cout, sum} = a + twomuxout + f[0];

	assign carry = (cout & (~f[1])); // based on ALU schematic

	assign xnorout = ~(a[31] ^ b[31] ^ f[0]);

	assign xorout = a[31] ^ sum[31];

	assign overflow = xnorout & xorout & (~f[1]); // based on ALU schmeatic

	assign zeroed = {31'b0, (overflow ^ sum[31])};

	assign result = (f == 3'b000) ? sum : // addition
			(f == 3'b001) ? sum : // subtraction
			(f == 3'b010) ? a & b : // AND
			(f == 3'b011) ? a | b : // OR
			(f == 3'b101) ? zeroed : 32'b0; // SLT and default statement
	
	assign negative = result[31]; // based on ALU schematic

	assign zero = ~|result; // based on ALU schematic
endmodule
