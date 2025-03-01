`timescale 1 ns / 100 ps
module ClockDivider_tb;

   reg CLK;
	 reg reset;
	 wire clk;
	 
	 ClockDivider dut (
        	                CLK,
		  reset,
        		  clk
    );
	 
	 always begin
        		#10;
        		CLK <= ~CLK;  //The period of a 50MHz signal is 20ns, so its level changes every 10ns
   	 end
	 
	 initial begin

		 CLK <= 1'b0;
		 
		 reset = 1;  //Not reset
		 #20000000 //500000 periods of 50MHz signal correspond to 1 period of 100Hz signal
		 //Here are 1000000 periods of 50MHz signal, so there should be two periods of the clk signal
		 
		 reset = 0;  //Reset
		 #20000000   //The counting number is reset. The clk signal should remian unchanged.
		 
		 reset = 1;  //Not reset
		 #20000000   //The counting number continues to increase. There should be two periods of the clk signal
			
	 $stop;
	 end
	
endmodule
