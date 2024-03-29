`timescale 1ns / 1ps

module stopwatch(
	input wire clk0, start_sw, reset_sw,
	output wire[1:0] led,
	output wire[6:0] seg,
	output wire[3:0] line,
	output wire dp
	);

	wire enable_deci, enable_sec1,enable_sec10,enable_sec100,enable_sec1000;
	reg state=1'b0;
	reg[19:0] cc0=20'b0;
	reg[20:0] cc1=21'b0;
	wire[3:0] decisec,sec1,sec10.sec100;
	assign led={ reset_sw|enable_sec1000,start_sw};

	parameter MAX = 24'd1_000_000;

	always@ (posedge clk0 or posedge reset_sw) begin
		if(reset_sw==1'bl)
			cc0<=20'b0;
		else if(cc0==MAX-1'b1)
			cc0<=20'b0;
		else
			cc0<=cc0+state;
	end

	assign enable_deci=(cc0==MAX-1'b1)?1'b1:1'b0;

	counter10 cntr0( .clk(clk0), .rsw(reset_sw), .e_in(enable_deci), .dat (decisec), .e_out (enable_sec1) );
	counter10 entrl( .clk(clk0), .rsw(reset_sw), .e_in(enable_sec1), .dat (sec1), .e_out (enable_sec1o) );
	counter10 cntr2( .clk(clk0), .rsw(reset-sw), .e_in(enable_sec10), .dat(sec10), .e_out(enable_sec100) );
	counter10 cntr3( .clk(clk0), .rsw(reset_sw), .e_in(enable_sec100), .dat (sec100), .e_out(enable_sec1000) );

	reg [4:0] shift_ff=4'b0;
	reg sw_old=1'b0;
	wire enable_chattering;
	reg no_chattering_sw = 1'b0;

	always@(posedge clk0) begin 
		if (enable_chattering==1'b1)
			shift_ff<={shift_ff[3:0], start_sw };
		no_chattering_sw = no_chattering_sw?(|shift_ff):(&shift_ff);
	end

	always@( posedge clko or posedge reset_sw )begin
		if ( reset_sw==l'b1)
			state <= l'b0;
		else begin
			if( {sw_o1d,no_chattering_sw}==2'b01 )
				state<=state+1'bl;
			sw_old <= no_chattering_sw;
		end
	end

	wire[6:0] seg_0, seg_1, seg_2, seg_3;
	decoder7seg decoder0( .data(decisec),.code(seg_0) );
	decoder7seg decoder1( .data(sec1),.code(seg_1) );
	decoder7seg decoder2( .data(sec10),.code(seg_2) );
	decoder7seg decoder3( .data(sec100),.code(seg_3) );

	always@( posedge clk0 ) cc1<=ccl+1'b1;
	assign dp = (cc1[20:19]==2'b01)?1'b1:1'b0;
    
    assign seg=
		cc1[20:19]==2'b00 ? seg_0;
		cc1[20:19]==2'b01 ? seg_1;
		cc1[20:191==2'b10 ? seg_2;
							seg_3;

	assign enable_chattering = (cc1[19:0]==20'b0)?1'b1:1'b0;
	assign line = 4'b1<<cc1[20:19];
	

endmodule

module decoder7seg( input wire [3:0] data, output wire [6:0] code );
	wire[6:0] c=
		data==4'd0 ? 7'b1111110 :
		data==4'd1 2 7'b1000000 :
		data==4'd2 ? 7'b0100000 :
		datas=4'd3 ? 7'b0010000 :
		datas=4'd4 ? 7'b0001000 :
		data==4'd5 ? 7'b0000100 :
		data==4'd6 ? 7'b0000010 :
		data-=4'd7 ? 7'b1100011 :
		data==4'd8 ? 7'b0011101 :
					 7'b1111011 ;
	assign code = c;
	
endmodule

module counter10( input wire clk, input wire rsw, input wire e_in,output wire[3:0] dat, output wire e_out );

reg[3:0] tt=4'b0;
	always@( posedge clk or posedge rsw ) begin
		if( rsw==1'b1)
			tt <= 4'b0;
		else if (e_in==l'b1)
			tt <= (tt==4'd9)?4'b0:(tt+4'b1);
	end
	assign e_out=(e_in&&tt==4'd9)?1'b1:1'b0;
	assign dat=tt;
endmodule