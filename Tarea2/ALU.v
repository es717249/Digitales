 /******************************************************************* 
* Name:
*	ALU.v
* Description:
* 	This module is a behavioral ALU with a parameter.
* Inputs:
*	input [WORD_LENGTH-1:0] dataA,//first data value
*	input [WORD_LENGTH-1:0] dataB,//second data value
*	input [4:0] control,

* Outputs:
*	output [WORD_LENGTH-1:0]carry,//carry output
*	output [WORD_LENGTH-1:0] dataC //result

* Versión:  
*	1.0
* Author: 
*	Nestor Damian Garcia Hernandez
* Fecha: 
*	04/09/2017
*********************************************************************/

module ALU
#(
	parameter WORD_LENGTH =3
)
(
	input [WORD_LENGTH-1:0] dataA,
	input [WORD_LENGTH-1:0] dataB,
	input [4:0] control,
	output [WORD_LENGTH-1:0]carry,
	output [WORD_LENGTH-1:0] dataC //result
	
);

reg [WORD_LENGTH:0]result_reg; 				//1 bit more to handle carry in the sum
reg [WORD_LENGTH-1:0]carry_reg=0; 									//this stores the carry indicator
reg [WORD_LENGTH:0]mask= 1<< WORD_LENGTH; //mask to check the carry			
reg [WORD_LENGTH:0]compl_B;
				


always@(*)begin 

			
	compl_B=(~dataB)+1; 	
	
	case(control)
		5'b00000:   /*Sum */
		begin
			result_reg= dataA+dataB; 	
			carry_reg=(result_reg & mask)?1:0;			 				
		end			
			
		5'b00001: //subtract 
		begin						
			//(A > B)
			if(dataA > dataB)
			begin				
				result_reg = dataA-dataB;				
				carry_reg=(result_reg & mask)?1:0; 
			end
			
			else //(dataA < dataB)
			begin								
			
			//The carry flag is turned on if it is negative result	
				carry_reg=((dataA+compl_B) & mask)?1:0;
					//complement the result to obtain the real magnitude
				result_reg  =(~(dataA+compl_B))+1;
			end			
		end
		
		5'b00010: //multiplicacion
		begin
			result_reg=dataA * dataB;
			carry_reg=0;
		end
		
		5'b00011:  //negado
		begin
			result_reg=~dataA;
			carry_reg=0;
		end
		
		5'b00100://complemento
		begin
			result_reg=(~dataA)+1;
			carry_reg=0;
		end 	
		5'b00101: //AND
		begin
			result_reg=(dataA & dataB);
			carry_reg=0;
		end
		5'b00110: //OR
		begin
			result_reg=(dataA | dataB);
			carry_reg=0;
		end
		5'b00111: //XOR
		begin
			result_reg=(dataA ^ dataB);
			carry_reg=0;
		end		
		5'b01000: //corrimiento
		begin
			if(control[4]==1'b1) //	11000
			begin
				result_reg= dataA << dataB;
			end
			else begin
				result_reg= dataA >> dataB;
			end
			
			
			carry_reg=0;
		end		
		default:
		begin 
			result_reg=	1'd0;
			carry_reg=	1'd0;			
		end
		
	endcase
	
end

assign dataC = result_reg;
assign carry = carry_reg;
endmodule