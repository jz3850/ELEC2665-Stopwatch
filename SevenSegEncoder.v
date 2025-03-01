module SevenSegEncoder(
	input [6:0] Min,  //Binary input of minutes 0-99
	input [5:0] Sec,  //Binary input of seconds 0-59
	input [6:0] Dec,  //Binary input of tens of miliseconds 0-99
	
	output [6:0] Hex1,  //tens of minutes
	output [6:0] Hex2,  //ones of minutes
	output [6:0] Hex3,  //tens of seconds
	output [6:0] Hex4,  //ones of seconds
	output [6:0] Hex5,  //hundreds of miliseconds
	output [6:0] Hex6   //tens of miliseconds
);

	wire [11:0] BCD1;  //BCD of minutes
	wire [11:0] BCD2;  //BCD of seconds
	wire [11:0] BCD3;  //BCD of tens of miliseconds
	//Actually only two decimal bits are used, i.e. [7:0] of BCD is used
	
	reg [3:0] Min_10;  //BCD of tens of minutes
	reg [3:0] Min_1;   //BCD of ones of minutes
	reg [3:0] Sec_10;  //BCD of tens of seconds
	reg [3:0] Sec_1;   //BCD of ones of seconds
	reg [3:0] Dec_10;  //BCD of hundreds of miliseconds
	reg [3:0] Dec_1;   //BCD of tens of miliseconds
	
	EightBinaryToBCD b0(
	{1'b0, Min},   //Add excessive 0 bits to match thse 8 bit input
	BCD1
	);  
	
	EightBinaryToBCD b1(
	{1'b0, 1'b0, Sec},
	BCD2
	);
	
	EightBinaryToBCD b2(
	{1'b0, Dec},
	BCD3
	);
	
	always @ (*) begin
		Min_10[3:0] <= BCD1[7:4];
		Min_1[3:0]  <= BCD1[3:0];
		Sec_10[3:0] <= BCD2[7:4];
		Sec_1[3:0]  <= BCD2[3:0];
		Dec_10[3:0] <= BCD3[7:4];
		Dec_1[3:0]  <= BCD3[3:0];
	end
	
	BCDToSegment dis0(
		Dec_1[3:0],
		Hex6[6:0]
	);
	
	BCDToSegment dis1(
		Dec_10[3:0],
		Hex5[6:0]
	);
	
	BCDToSegment dis2(
		Sec_1[3:0],
		Hex4[6:0]
	);
	
	BCDToSegment dis3(
		Sec_10[3:0],
		Hex3[6:0]
	);
	
	BCDToSegment dis4(
		Min_1[3:0],
		Hex2[6:0]
	);
	
	BCDToSegment dis5(
		Min_10[3:0],
		Hex1[6:0]
	);
	
endmodule
