`timescale 1 ns / 100 ps
module StopwatchLogic_tb;

	reg clk;         //100Hz square wave
	reg reset;       //reset switch, 0 means reset
	reg start_stop;  //start or stop button, 1-not pressed, 0-pressed
	reg hold;        //pause button, 1-not pressed, 0-pressed
	
	wire [6:0] Min;
	wire [5:0] Sec;
	wire [6:0] Dec;
	wire CLK_ind;
	wire Overflow;
	 
	StopwatchLogic dut (
       		 clk,
		 reset,
		 start_stop,
		 hold,
		 Min,
		 Sec,
		 Dec,
		 CLK_ind,
		 Overflow
   );
	
	integer i, Min_, Sec_, Dec_;
	
	always begin
        		  clk <= ~clk;
		  #10;  //The peiod of clock signal in this testbench is 20ns rather than 0.01s.
    	end
	 
	 always begin
		 Min_ <= Min;
		 Sec_ <= Sec;
		 Dec_ <= Dec;
		 #0.1;  //This time needs to be as small as possible, otherwise there will be obvious time delay between 
   	 end        //these check values and the actual values
	
initial begin

	 clk <= 1'b0;  //Initialisation
	 reset=1;
	 start_stop=1;
	 hold=1;
	 i=0;
	 
	 #10000;  //The counter should be 0 for 10000ns.  //0s;
	 
	 start_stop=0;  //1.Press start/stop button for 10000ns.
	 #10000;  
	 start_stop=1;
	 #10000;  //The counter should increase from 0 to 1000. (10000ns corresponds to 500 periods of clk)  //0-10s;;
	 
	 hold=0;  //2.Hold the pause button for 10000ns.
	 #10000;  //The counter should remain at 1000 for 10000ns.  //10s;
	 
	 hold=1;  //3.Unpress the hold button.
	 #10000;  //The counter should increase from 1000 to 1500.  //10s-15s;
	 
	 start_stop=0;  //4.Press start/stop button again.
	 #10000;  
	 start_stop=1;
	 #10000;  //The counter should remain at 1500 for 10000ns.  //15s;;
	 
	 start_stop=0;  //5.Press start/stop button once again.
	 #10000;
	 start_stop=1;
	 #10000;  //The counter should increase from 1500 to 2500.  //15s-25s;;
	 
	 reset=0;  //6.Switch the reset to be 0 (active).
	 #10000;  //The counter should be reset to be 0 for 10000ns.  //0s;
	 
	 reset=1;  //7.Switch the reset to be 1 (inactive).
	 //The counter should increase from 0 to 599999, and then 0 to 19999  //0s-99min59s99cs; 0s-3min19s99cs
	 
	 for(i=0;i<620000;i=i+1)  //We want the number of minutes to be more than 100 (600000 centiseconds) to see the overflow
	 begin
    #20;  //20ns,i.e. 1 period of the clock signal, which corresponds to 1 centisecond added in the counter
	 end
	 
	 //If the values of Min_, Sec_ and Dec_ increase and overflow normally (minute 0-99, second 0-59, centisecond 0-99)
	 //and the theoretical phenomena mentioned above are followed, the simulation is successful.
	 //Besides, the CLK_ind should toggle every 50ns.
	 
$stop;
end
	
endmodule
