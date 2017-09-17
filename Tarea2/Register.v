
 module Register
#(
	parameter WORD_LENGTH = 4
)

(
	// Input Ports
	input clk,
	input reset,
	input enable,
	input reset_sync,
	input [WORD_LENGTH-1 : 0] Data_Input,

	// Output Ports
	output [WORD_LENGTH-1 : 0] Data_Output
);

reg  [WORD_LENGTH-1 : 0] Data_reg;

//hay prioridades de asignaciòn
/*
El reset asìncrono tiene más prioridad (el primer if lo asigna al reset)
*/

//solo debe estar en la lista sensible el clk y el reset
always@(negedge clk or negedge reset ) begin
	
	//dominio del reset
	if(reset == 1'b0) 
		Data_reg <= 0;
		//dominio del clk
	else begin
		if(enable==1'b1) begin
		//if(reset_sync==1'b1) begin
		
			if(reset_sync==1'b1)
			//if(enable==1'b1)
				Data_reg <= Data_Input;
			else 
				Data_reg <= 0;
		end
	end
			
end

assign Data_Output = Data_reg;

endmodule
