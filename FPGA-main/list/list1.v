`timescale 1ns / 1ps

module test(
	input wire clk0,
	output wire led	
);

	reg[26:0] c=0;
	assign led=c[26];

	always @( posedge clk0 )begin
			if( c==27'd99999999 )
				c <= 0;
			else
				c <= c + 1'b1;
	end

endmodule