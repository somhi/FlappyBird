
module StatusChecker(input clk, input Reset,CounterX,input [15:0] R_Pipes_off,input [15:0] R_Pipes2_off,input [15:0] R_Bird_off,output reg Status);
initial Status = 1;
always @ (posedge clk)
begin

if (!Reset) Status <= 1;
if ((R_Pipes_off && R_Bird_off) || (R_Pipes2_off && R_Bird_off)) Status <= 0;

end
endmodule
