`timescale 1 ns / 100 ps
module SevenSegEncoder_tb;

	reg [6:0] Min;
	reg [5:0] Sec;
	reg [6:0] Dec;
	
	wire [6:0] Hex1;  //tens of minutes
	wire [6:0] Hex2;  //ones of minutes
	wire [6:0] Hex3;  //tens of seconds
	wire [6:0] Hex4;  //ones of seconds
	wire [6:0] Hex5;  //hundreds of miliseconds
	wire [6:0] Hex6;  //tens of miliseconds
	 
	SevenSegEncoder dut (
       		 Min,
		 Sec,
		 Dec,
		 Hex1,
		 Hex2,
		 Hex3,
		 Hex4,
		 Hex5,
		 Hex6
   );
	
	integer i, Min_, Sec_, Dec_;
	
initial begin
		 
	 for(i=0;i<10;i=i+1)
	 begin
	 
	   Min=$random()%99;
		Sec=$random()%59;
		Dec=$random()%99;
		
		Min_ = Min;
		Sec_ = Sec;
		Dec_ = Dec;
	 
	   //if the values of Segment correspond to the decimal numbers of Min_, Sec_ and Dec_, 
		//the simulation is successful:
		//7'b1000000//0
		//7'b1111001//1
		//7'b0100100//2
		//7'b0110000//3
		//7'b0011001//4
		//7'b0010010//5
		//7'b0000010//6
		//7'b1111000//7
		//7'b0000000//8
		//7'b0010000//9
		 
   #10;
	end
			
$stop;
end
	
endmodule
