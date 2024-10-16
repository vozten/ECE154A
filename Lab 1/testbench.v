module testbench;
	reg[31:0] a,b;
	reg[2:0] f;
	wire[31:0] result;
	wire zero;
	wire overflow;
	wire carry;
	wire negative;

	reg [31:0] expected_result;
    	reg expected_zero, expected_overflow, expected_carry, expected_negative;
	integer fd, r, i, n;

	

	alu u(
		.a(a),
		.b(b),
		.f(f),
		.result(result),
		.zero(zero),
		.overflow(overflow),
		.carry(carry),
		.negative(negative)
	);

	initial begin
        	fd = $fopen("alu.tv", "r");

		if (fd == 0) begin
			$display("Error: Failed to open file.");
			$finish;
		end
		
		for (i = 0; i < 23; i = i + 1) begin //loop to iterate through test vector list
			n = i + 1;
			r = $fscanf(fd,"%d %h %h %h %b %b %b %b\n", f, a, b, expected_result, expected_zero, expected_overflow, expected_carry, expected_negative); // parse numbers into variables
			#100; // time step of 100ns
            		if ((result !== expected_result) || (zero !== expected_zero) || (overflow !== expected_overflow) || (carry !== expected_carry) || (negative !== expected_negative)) begin // check if values match
                		$display("Test #%d: Mismatch!", n);
            		end else begin
                		$display("Test #%d: Match!", n);
            		end
		end
        	$fclose(fd);
		$stop;
	end

endmodule

