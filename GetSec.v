module GetSec(

	input clk,
	input [23:0] c,
	output reg [5:0] Sec
	
);

	reg [23:0] Sec_;
	
	initial begin
		Sec_ = 0;
	end

	always @(negedge clk) begin
		Sec_ = c / 100;  //What the counter counts is the centisecond, and one second equals to 100 centiseconds.
		Sec_ = Sec_ % 60;  //To get the remainder of seconds divided by 60. The number of seconds can reach  
		Sec[5:0] = Sec_[5:0];  //the maximum of 60 seconds. Once overflow occurs, second number is reset to be 0.
	end

endmodule
