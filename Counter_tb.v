`timescale 1 ns / 100 ps
module Counter_tb;

	reg clk;
	reg reset;
	reg start; 
	reg pause;
	wire [23:0] c;
	 
	Counter dut (
	    clk,  
	    reset,  
	    start,  
	    pause,  
	    c  
   );
	
	 always begin
        		  clk <= ~clk;
		  #10;  //The peiod of clock signal in this testbench is 20ns rather than 0.01s.
    	end
	
initial begin

	 clk <= 1'b0;  //Initialisation
	 start=0;
	 reset=1;
	 pause=0;
	 
	 #1000;  //The counter should be 0 for 1000ns.
	 
	 start=1;  //1.Press start/stop button.
	 #1000;  //The counter should increase from 0 to 50. (1000ns corresponds to 50 periods of clk)
	 
	 pause=1;  //2.Hold the pause button for 1000ns.
	 #1000;  //The counter should remain at 50 for 1000ns.
	 
	 pause=0;  //3.Unpress the hold button.
	 #1000;  //The counter should increase from 50 to 100.
	 
	 start=0;  //4.Press start/stop button.
	 #1000;  //The counter should remain at 100 for 1000ns.
	 
	 start=1;  //5.Press start/stop button.
	 #1000;  //The counter should increase from 100 to 150.
	 
	 reset=0;  //6.Switch the reset to be 0 (active).
	 #1000;  //The counter should be reset to be 0.
	 
	 reset=1;  //7.Switch the reset to be 1 (inactive).
	 #1000;  //The counter should increase from 0 to 50.
			
$stop;
end
	
endmodule
