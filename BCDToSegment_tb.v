`timescale 1 ns / 100 ps
module BCDToSegment_tb;

  reg [3:0] B;
	wire [6:0] S;
	 
	BCDToSegment dut (
       		 B,
		 S
   );
	
initial begin
		 
	 for(B=4'b0000;B<4'b1010;B=B+4'b0001)
	 begin
	 
		//if the value of Segment corresponds to the following 7 bit numbers, the simulation is successful:
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
