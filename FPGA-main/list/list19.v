`timescale 1ns / 1ps

module octal_counter(
	input wire clk,
	input wire a,
	output reg[2:0] q
);
	wire x;
	anti_chatter anti_chatter1( .clk(clk), .sw_in(a), .sw_out(x) );

	always @(negedge x) q<= q + 1'b1;
endmodule