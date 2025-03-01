module GetDec(

	input clk,
	input [23:0] c,
	output reg [6:0] Dec
	
);

	reg [23:0] Dec_;
	
	initial begin
		Dec_ = 0;
	end

	always @(negedge clk) begin
		Dec_ = c;  //The number of centiseconds equals to the counter number.
		Dec_ = Dec_ % 100;  //To get the remainder of centiseconds divided by 100. The number of centiseconds can  
		Dec[6:0] = Dec_[6:0];  //reach the maximum of 100. Once overflow occurs, centisecond number is reset to be 0.
	end

endmodule
