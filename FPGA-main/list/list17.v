`timescale 1ns / 1ps

module ff_no_chattering(
	input wire clk,
	input wire a,
	output reg[3:0] q
);
	reg x=0;

	always @(negedge clk) x <= a;

	always @(negedge x) q[0] <= !q[0];
	always @(negedge q[0])q[1] <= !q[1];
	always @(negedge q[1])q[2] <= !q[2];
	always @(negedge q[2])q[3] <= !q[3];
endmodule

module anti_chatter(
	input wire clk,
	input wire sw_in,
	output wire sw_out
);
	assign sw_out=anti_chatter_sw;
	reg [4:0] shift_ff = 0;
	reg [15:0] cc=0;
	reg anti_chatter_sw=0;
	always@(posedge clk) begin
		cc <= cc+1'b1;
		if( &cc )bigin
			shift_ff <= { shift_ff[3:0], sw_in};
			anti_chatter_sw <= anti_chatter_sw?(|shift_ff):(&shift_ff);
		end
	end
endmodule