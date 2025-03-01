module Stopwatch(

	input CLK,         //50MHz clock signal
	input reset,       //reset switch, 0 means reset
	input start_stop,  //start or stop button, 1-not pressed, 0-pressed
	input hold,        //pause button, 1-not pressed, 0-pressed
	
	output [6:0] Hex1,  //tens of minutes
	output [6:0] Hex2,  //ones of minutes
	output [6:0] Hex3,  //tens of seconds
	output [6:0] Hex4,  //ones of seconds
	output [6:0] Hex5,  //hundreds of miliseconds
	output [6:0] Hex6,  //tens of miliseconds
	output CLk_ind,     //Clock indication signal flash every 1 second
	output Overflow,    //Overflow occurs when the timer reaches 99min99s99cs
	output [8:0] OtherLED     //Set other LEDs to be black
	
);

	wire clk;  //100Hz clock signal
	wire[6:0] Min;  //number of miutes
	wire[5:0] Sec;  //number of seconds
	wire[6:0] Dec;  //number of centiseconds
	
	assign OtherLED = 7'b0000000;  //Set other LEDs to be black

	ClockDivider divider(
		CLK,
		reset,
		clk
	);

	StopwatchLogic logic(
		clk,
		reset,
		start_stop,
		hold,
		
		Min[6:0],
		Sec[5:0],
		Dec[6:0],
		CLk_ind,  
		Overflow
	);

	SevenSegEncoder encoder(
		Min[6:0],
		Sec[5:0],
		Dec[6:0],
		
		Hex1[6:0],
		Hex2[6:0],
		Hex3[6:0],
		Hex4[6:0],
		Hex5[6:0],
		Hex6[6:0]
	);

endmodule
