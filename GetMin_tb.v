`timescale 1 ns / 100 ps
module GetMin_tb;

	reg clk;
	reg [23:0] c;
	wire [6:0] Min;
	 
	GetMin dut(
       		 clk,
		 c,
		 Min
   );
	
	integer Min_;
	
	always begin
       		 clk <= ~clk;
		 Min_ <= Min;
		 #10;  //The peiod of clock signal in this testbench is 20ns rather than 0.01s.
   	end
	 
initial begin

    clk <= 1'b0;  //Initialisation. 
    
	 for(c=0;c<620000;c=c+1)  //We want the number of minutes to be more than 100 (600000 centiseconds) to see the overflow
	 begin
    #20;  //20ns,i.e. 1 period of the clock signal, which corresponds to 1 centisecond added in the counter
	 end
	 
	 //If Min_ increases from 0 to 99 and it is finally reset, the simulation is successful.
			
$stop;
end
	
endmodule
