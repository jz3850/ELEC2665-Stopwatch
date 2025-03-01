`timescale 1 ns / 100 ps
module Stopwatch_tb;

	reg CLK;         //100Hz square wave
	reg reset;       //reset switch, 0 means reset
	reg start_stop;  //start or stop button, 1-not pressed, 0-pressed
	reg hold;        //pause button, 1-not pressed, 0-pressed
	
	wire [6:0] Hex1;  //tens of minutes
	wire [6:0] Hex2;  //ones of minutes
	wire [6:0] Hex3;  //tens of seconds
	wire [6:0] Hex4;  //ones of seconds
	wire [6:0] Hex5;  //hundreds of miliseconds
	wire [6:0] Hex6;  //tens of miliseconds
	wire CLk_ind;     //Clock indication signal flash every 1 second
	wire Overflow;    //Overflow occurs when the timer reaches 99min99s99cs
	wire [8:0] OtherLED;     //Set other LEDs to be black
	 
	Stopwatch dut (
       		 CLK,
		 reset,
		 start_stop,
		 hold,
		 Hex1,
		 Hex2,
		 Hex3,
		 Hex4,
		 Hex5,
		 Hex6,
		 CLK_ind,
		 Overflow,
		 OtherLED
   );
	
	always begin
        		  CLK <= ~CLK;
		  #10;  //A 50MHz signal toggles every 10ns.
    	end

initial begin

	 CLK <= 1'b0;  //Initialisation
	 reset=1;
	 start_stop=1;
	 hold=1;

	 #50000000;     //The counter should be 0 for 0.05s.                //0s;
	 
	 start_stop=0;  //1.Press start/stop button for 0.05s.
	 #50000000;  
	 start_stop=1;
	 #50000000;     //The counter should increase from 0 to 100.        //0-0.1s;;
	 
	 hold=0;        //2.Hold the pause button for 0.05s.
	 #50000000;     //The counter should remain at 100 for 0.05s.       //0.1s;
	 hold=1;        
	 #50000000;     //The counter should increase from 100 to 150.      //0.1s-0.15s;
	 
	 start_stop=0;  //3.Press start/stop button again.
	 #50000000;  
	 start_stop=1;
	 #50000000;     //The counter should remain at 150 for 0.10s.       //0.15s;;
	 
	 start_stop=0;  //4.Press start/stop button once again.
	 #50000000;
	 start_stop=1;
	 #50000000;     //The counter should increase from 150 to 250.      //0.15s-0.25s;;
	 
	 reset=0;       //5.Switch the reset to be 0 (active).
	 #50000000;     //The counter should be reset to be 0 for 0.05s.    //0s;
	 
	 reset=1;       //6.Switch the reset to be 1 (inactive).
	 #50000000;     //The counter should increase from 0 to 0.05s.      //0-0.05s;
	 
	 //If the decimal values of Hex1-6 follow
	 //the theoretical phenomena mentioned above, the simulation is successful.
	 
$stop;
end
	
endmodule
