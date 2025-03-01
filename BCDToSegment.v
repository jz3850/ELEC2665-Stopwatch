module BCDToSegment(
	input [3:0] B,  //BCD
	output reg [6:0] S   //Segment
);

always @ (B) begin
		case(B)
			4'b0000: S = 7'b1000000; //0
			4'b0001: S = 7'b1111001; //1
			4'b0010: S = 7'b0100100; //2
			4'b0011: S = 7'b0110000; //3
			4'b0100: S = 7'b0011001; //4
			4'b0101: S = 7'b0010010; //5
			4'b0110: S = 7'b0000010; //6
			4'b0111: S = 7'b1111000; //7
			4'b1000: S = 7'b0000000; //8
			4'b1001: S = 7'b0010000; //9
			default: S = 7'b1000000; //0
		endcase
end

endmodule
