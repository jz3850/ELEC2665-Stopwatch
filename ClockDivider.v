module ClockDivider(
	input CLK, //50MHz
	input reset,  //reset switch, 0 means reset
	output reg clk  //100Hz
);
	
	reg[17:0] c;  //counting number
	
	initial begin
		c[17:0] <= 0;
		clk <= 0;
	end
	
	always @(negedge CLK) begin
	
		if (~reset) begin  //The reset is switched to 0 (active)
			clk = 0;
			c[17:0] <= 0;
		end
		
		else if (c >= 250000) begin  //for every 250,000 times the 50MHz changes the level, the 100Hz changes once
			c <= 0;
			clk <= ~clk;
		end
		
		else begin
			c <= c + 1;
		end
		
	end

endmodule
