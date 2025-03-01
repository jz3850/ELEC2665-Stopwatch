module GetMin(

	input clk,
	input [23:0] c,
	output reg [6:0] Min
	
);

	reg [23:0] Min_;
	
	initial begin
		Min_ = 0;
	end

	always @(negedge clk) begin
		Min_ = c / 6000;  //What the counter counts is the centisecond, and one minute equals to 6000 centiseconds.
		Min_ = Min_ % 100;  //To get the remainder of minutes divided by 100. The number of minute can reach  
		Min[6:0] = Min_[6:0];  //the maximum of 100 minutes. Once overflow occurs, minute number is reset to be 0.
	end

endmodule
