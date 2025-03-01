`timescale 1 ns / 100 ps
module GetSec_tb;

	reg clk;
	reg [23:0] c;
	wire [5:0] Sec;
	 
	GetSec dut(
       		 clk,
		 c,
		 Sec
   );
	
	integer Sec_;
	
	always begin
       		 clk <= ~clk;
		 Sec_ <= Sec;
		 #10;  //The peiod of clock signal in this testbench is 20ns rather than 0.01s.
   	end
	 
initial begin

    clk <= 1'b0;  //Initialisation. 
    
	 for(c=0;c<6200;c=c+1)  //We want the number of seconds to be more than 60 (6000 centiseconds) to see the overflow
	 begin
    #20;  //20ns,i.e. 1 period of the clock signal, which corresponds to 1 centisecond added in the counter
	 end
	 
	 //If Sec_ increases from 0 to 59 and it is finally reset, the simulation is successful.
			
$stop;
end
	
endmodule
