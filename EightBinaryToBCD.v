module EightBinaryToBCD(
    input [7:0] Binary,
    output reg [11:0] BCD
);
    
    reg [3:0] i;   //There are 8 bits of the binary input, the shift needs to be operated 8 times,
		             //and so a variable of three bits that exactly reptesents 0-7 is needed.
	 always @(Binary)
	 begin
		BCD = 0; 
		for (i = 4'd0; i < 4'd8; i = i + 4'd1) begin
	
			 BCD = {BCD[10:0],Binary[7-i]};   //shift the binary bit left
			  
			 if(i < 7 && BCD[3:0] > 4)        //if the four bits binary number is more than 4, add 3
				  BCD[3:0] = BCD[3:0] + 4'd3;
			 
			 if(i < 7 && BCD[7:4] > 4)
				  BCD[7:4] = BCD[7:4] + 4'd3;
			  
			 if(i < 7 && BCD[11:8] > 4)
				  BCD[11:8] = BCD[11:8] + 4'd3;  
				  
		end
end     			 
endmodule
