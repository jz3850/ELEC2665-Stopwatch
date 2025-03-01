module Counter(

	input clk,  //100Hz square wave
	input reset,  //reset switch, 0 means reset
	input start,  //start or stop
	input pause,  //pause
	output reg [23:0] c  //counting number
	
);

	initial begin
		c[23:0] <= 0;
	end

	always @(negedge clk or negedge reset) begin
	
		if (~reset) begin  //If the reset switch is 0 (active)
			c[23:0] <= 0;   //Reset the counter to be 0
		end
		
		else if (~start || (start && pause)) begin  //If (stop counting||allow counting but paused)
			c <= c;                                  //Pause counting
		end
	
		else if (start && ~pause && c < 599999) begin  //If (allow counting && not paused && below time limitation)
			c <= c + 1;                                 //Counting
		end
		
		else begin
			c <= 599999;  //The counter has reached 99min,99s,990ms
		end
		
	end
endmodule
