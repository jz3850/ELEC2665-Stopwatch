`timescale 1 ns / 100 ps
module GetDec_tb;

	reg clk;
	reg [23:0] c;
	wire [6:0] Dec;
	 
	GetDec dut(
       		 clk,
		 c,
		 Dec
   );
	
	integer Dec_;
	
	always begin
       		 clk <= ~clk;
		 #10;  //The peiod of clock signal in this testbench is 20ns rather than 0.01s.
   	end
	
	always begin
		 Dec_ <= Dec;
		 #0.1;  //This time needs to be as small as possible, otherwise there will be obvious time delay between Dec and Dec_
   	end
	 
initial begin

    	 clk <= 1'b0;  //Initialisation. 
    
	 for(c=0;c<102;c=c+1)  //We want the number of seconds to be more than 100 to see the overflow
	 begin
    #20;  //20ns,i.e. 1 period of the clock signal, which corresponds to 1 centisecond added in the counter
	 end
	 
	 //If Dec_ increases from 0 to 99 and it is finally reset, the simulation is successful.
			
$stop;
end
	
endmodule
