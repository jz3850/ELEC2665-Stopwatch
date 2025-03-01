module StopwatchLogic(

	input clk,  //100Hz square wave
	input reset,  //reset switch, 0 means reset
	input start_stop,  //start or stop button, 1-not pressed, 0-pressed
	input hold,  //pause button, 1-not pressed, 0-pressed
	
	output [6:0] Min,
	output [5:0] Sec,
	output [6:0] Dec,
	output CLK_ind,
	output Overflow
	
);

	reg start;     //Start flag, 1 allows counting.
	wire pause;    //Pause flag, 1 means the hold button is pressed.
	reg overflow;  //Overflow flag, 1 means that overflow occures.
	reg clk_ind;   //Clock indicator flag
	wire [23:0] c; //counting number
	
	initial begin
		start = 0;  
		overflow = 0;
		clk_ind = 0;
	end
	
	assign Overflow = overflow;  //Overflow and clock indicator are both outputs, and they cannot be directly assigned,
	assign CLK_ind = clk_ind;    //so we need to use wires to assign them
	
   // stopwatch control
	always @(negedge start_stop) begin  //When start/stop button is pressed, if the hold button is not pressed
		if (reset && ~pause) begin  //and the reset switch = 1 (inactive), change the state of start flag.
			start <= ~start;  //Start=1 -- Start=0, i.e. stop counting; Start=0 -- Start=1, i.e. begin counting.
		end
	end
	 
	assign pause = ~hold;  //If hold is true (not pressed), assign 0 to pause; 
	                       //else (pressed) assign 1 to pause.
	
	always @(negedge clk) begin  //If the counter reaches 99min,99s,990ms, overslow occurs
		if (c == 599999) begin
			overflow = 1;
		end 
		
		else begin
			overflow = 0;
		end
	end
	
	always @(negedge clk) begin  //The clock indicator toggles every 50ms when it is counting.
		if (c%50==0 && start && ~pause && reset) begin
			clk_ind = ~clk_ind;
		end 
	end
	
	Counter counter(  // timer
		clk,
		reset,
		start,
		pause,
		c[23:0]
	);
	
	GetDec dec(  //get decimal second of the counter
		clk,
		c[23:0],
		Dec[6:0]
	);
	
	GetSec sec(  //get second of the counter
		clk,
		c[23:0],
		Sec[5:0]
	);
	
	GetMin min(  //get minute of the counter
		clk,
		c[23:0],
		Min[6:0]
	);

endmodule
