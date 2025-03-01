`timescale 1 ns / 100 ps
module EightBinaryToBCD_tb;

   	reg [7:0] Binary;
	wire [11:0] BCD;
	 
	EightBinaryToBCD dut (
       		 Binary,
		 BCD
   );
	
	integer i, One, Ten, Hundred;
	
	always begin
       		 One <= BCD[3:0];
		 Ten <= BCD[7:4];
		 Hundred <= BCD[11:8];
		 #0.1;  //This time has to be as short as possible, otherwise there will be obvious time delay between
		 //the values of these three digits and i in the simulation result.
   	end
	
initial begin
		 
	 for(Binary=8'b00000000;Binary<8'b11111111;Binary=Binary+8'b00000001)
	 begin
	 
	   i = Binary;  //If the values of the three digits are consistent with i, 
		//the simulation is successful. 
   	#10;
	end
			
$stop;
end
	
endmodule
