
module DrawScore(
	input clk,
	input [24:0] Clks,
	input Reset,
	input [15:0] PipesPosition1,
	input [15:0] PipesPosition2,
	input [15:0] CounterX,
	input [15:0] CounterY,
	input Button,
	input Status,
	output reg R_Score_on,
	output reg G_Score_on,
	output reg B_Score_on,
	output reg R_Score_off,
	output reg G_Score_off,
	output reg B_Score_off
);
//////////////////////////////////////////////////////////////////////////////////
reg [15:0] ScorePositionX = 320;
reg [15:0] ScorePositionY = 50;

reg [3:0] Ten = 0;
reg [3:0] Unit = 0;

reg ZeroBlack,ZeroWhite,OneBlack,OneWhite,TwoBlack,TwoWhite,ThreeBlack,ThreeWhite,FourBlack,FourWhite,FiveBlack,FiveWhite,SixBlack,SixWhite,SevenBlack,SevenWhite,EightBlack,EightWhite,NineBlack,NineWhite;
reg ScoreWhiteUnit,ScoreBlackUnit,ScoreWhiteTen,ScoreBlackTen;


always @ (posedge clk) begin : score1
	reg old_clks16;
	old_clks16 <= Clks[16];

	if (~old_clks16 && Clks[16]) begin
		if (!Reset) begin
			ScorePositionX <= 320;
			ScorePositionY <= 50;
			Ten <= 0;
			Unit <= 0;
		end


		if (PipesPosition1 == 10 || PipesPosition2 == 10) begin
			if (Unit == 9) begin
				Ten <= Ten + 1'd1;
				Unit <= 0;
			end else if (Ten == 10) begin
				Ten <= 0; Unit <= Unit + 1'd1;
			end else Unit <= Unit + 1'd1;
		end

		if (Status == 0) ScorePositionY <= 185;
	end
end

always @ (posedge clk) begin

case (Unit)
0 : begin

ScoreBlackUnit <=
            (CounterX>=ScorePositionX+3+0*3) && (CounterX<=ScorePositionX+3+9*3) && (CounterY>=ScorePositionY+0*3) && (CounterY<=ScorePositionY+1*3)

||          (CounterX>=ScorePositionX+3+0*3) && (CounterX<=ScorePositionX+3+1*3) && (CounterY>=ScorePositionY+1*3) && (CounterY<=ScorePositionY+4*3)
||          (CounterX>=ScorePositionX+3+8*3) && (CounterX<=ScorePositionX+3+9*3) && (CounterY>=ScorePositionY+1*3) && (CounterY<=ScorePositionY+4*3)

||          (CounterX>=ScorePositionX+3+0*3) && (CounterX<=ScorePositionX+3+1*3) && (CounterY>=ScorePositionY+4*3) && (CounterY<=ScorePositionY+10*3)
||          (CounterX>=ScorePositionX+3+4*3) && (CounterX<=ScorePositionX+3+5*3) && (CounterY>=ScorePositionY+4*3) && (CounterY<=ScorePositionY+10*3)
||          (CounterX>=ScorePositionX+3+8*3) && (CounterX<=ScorePositionX+3+9*3) && (CounterY>=ScorePositionY+4*3) && (CounterY<=ScorePositionY+10*3)

||          (CounterX>=ScorePositionX+3+0*3) && (CounterX<=ScorePositionX+3+1*3) && (CounterY>=ScorePositionY+10*3) && (CounterY<=ScorePositionY+13*3)
||          (CounterX>=ScorePositionX+3+8*3) && (CounterX<=ScorePositionX+3+9*3) && (CounterY>=ScorePositionY+10*3) && (CounterY<=ScorePositionY+13*3)

||          (CounterX>=ScorePositionX+3+0*3) && (CounterX<=ScorePositionX+3+9*3) && (CounterY>=ScorePositionY+13*3) && (CounterY<=ScorePositionY+14*3);

ScoreWhiteUnit <=
       (CounterX>=ScorePositionX+3+1*3) && (CounterX<=ScorePositionX+3+8*3) && (CounterY>=ScorePositionY+1*3)  && (CounterY<=ScorePositionY+4*3)

||     (CounterX>=ScorePositionX+3+1*3) && (CounterX<=ScorePositionX+3+4*3) && (CounterY>=ScorePositionY+4*3)  && (CounterY<=ScorePositionY+10*3)
||     (CounterX>=ScorePositionX+3+(5*3)) && (CounterX<=ScorePositionX+3+(8*3)) && (CounterY>=ScorePositionY+(4*3))  && (CounterY<=ScorePositionY+(10*3))

||     (CounterX>=ScorePositionX+3+(1*3)) && (CounterX<=ScorePositionX+3+(8*3)) && (CounterY>=ScorePositionY+(10*3)) && (CounterY<=ScorePositionY+(13*3));

end
1 : begin

ScoreBlackUnit <= (CounterX>=ScorePositionX+3+2*3) && (CounterX<=ScorePositionX+3+8*3) && (CounterY>=ScorePositionY+0*3) && (CounterY<=ScorePositionY+1*3)

||          (CounterX>=ScorePositionX+3+2*3) && (CounterX<=ScorePositionX+3+3*3) && (CounterY>=ScorePositionY+1*3) && (CounterY<=ScorePositionY+4*3)
||          (CounterX>=ScorePositionX+3+7*3) && (CounterX<=ScorePositionX+3+8*3) && (CounterY>=ScorePositionY+1*3) && (CounterY<=ScorePositionY+4*3)

||          (CounterX>=ScorePositionX+3+2*3) && (CounterX<=ScorePositionX+3+4*3) && (CounterY>=ScorePositionY+4*3) && (CounterY<=ScorePositionY+5*3)
||          (CounterX>=ScorePositionX+3+7*3) && (CounterX<=ScorePositionX+3+8*3) && (CounterY>=ScorePositionY+4*3) && (CounterY<=ScorePositionY+5*3)

||          (CounterX>=ScorePositionX+3+3*3) && (CounterX<=ScorePositionX+3+4*3) && (CounterY>=ScorePositionY+5*3) && (CounterY<=ScorePositionY+13*3)
||          (CounterX>=ScorePositionX+3+7*3) && (CounterX<=ScorePositionX+3+8*3) && (CounterY>=ScorePositionY+5*3) && (CounterY<=ScorePositionY+13*3)

||	    (CounterX>=ScorePositionX+3+3*3) && (CounterX<=ScorePositionX+3+8*3) && (CounterY>=ScorePositionY+13*3) && (CounterY<=ScorePositionY+14*3);

ScoreWhiteUnit <=  (CounterX>=ScorePositionX+3+3*3) && (CounterX<=ScorePositionX+3+7*3) && (CounterY>=ScorePositionY+1*3) && (CounterY<=ScorePositionY+4*3)

||	    (CounterX>=ScorePositionX+3+4*3) && (CounterX<=ScorePositionX+3+7*3) && (CounterY>=ScorePositionY+4*3) && (CounterY<=ScorePositionY+13*3);

end
2 : begin
ScoreBlackUnit <= (CounterX>=ScorePositionX+3+0*3) && (CounterX<=ScorePositionX+3+9*3) && (CounterY>=ScorePositionY+0*3) && (CounterY<=ScorePositionY+1*3)

||          (CounterX>=ScorePositionX+3+0*3) && (CounterX<=ScorePositionX+3+1*3) && (CounterY>=ScorePositionY+1*3) && (CounterY<=ScorePositionY+4*3)
||          (CounterX>=ScorePositionX+3+8*3) && (CounterX<=ScorePositionX+3+9*3) && (CounterY>=ScorePositionY+1*3) && (CounterY<=ScorePositionY+4*3)

||          (CounterX>=ScorePositionX+3+0*3) && (CounterX<=ScorePositionX+3+5*3) && (CounterY>=ScorePositionY+4*3) && (CounterY<=ScorePositionY+5*3)
||          (CounterX>=ScorePositionX+3+8*3) && (CounterX<=ScorePositionX+3+9*3) && (CounterY>=ScorePositionY+4*3) && (CounterY<=ScorePositionY+5*3)

||          (CounterX>=ScorePositionX+3+0*3) && (CounterX<=ScorePositionX+3+1*3) && (CounterY>=ScorePositionY+5*3) && (CounterY<=ScorePositionY+9*3)
||          (CounterX>=ScorePositionX+3+8*3) && (CounterX<=ScorePositionX+3+9*3) && (CounterY>=ScorePositionY+5*3) && (CounterY<=ScorePositionY+9*3)

||          (CounterX>=ScorePositionX+3+0*3) && (CounterX<=ScorePositionX+3+1*3) && (CounterY>=ScorePositionY+9*3) && (CounterY<=ScorePositionY+10*3)
||          (CounterX>=ScorePositionX+3+4*3) && (CounterX<=ScorePositionX+3+9*3) && (CounterY>=ScorePositionY+9*3) && (CounterY<=ScorePositionY+10*3)

||          (CounterX>=ScorePositionX+3+0*3) && (CounterX<=ScorePositionX+3+1*3) && (CounterY>=ScorePositionY+10*3) && (CounterY<=ScorePositionY+13*3)
||          (CounterX>=ScorePositionX+3+8*3) && (CounterX<=ScorePositionX+3+9*3) && (CounterY>=ScorePositionY+10*3) && (CounterY<=ScorePositionY+13*3)

||	    (CounterX>=ScorePositionX+3+0*3) && (CounterX<=ScorePositionX+3+9*3) && (CounterY>=ScorePositionY+13*3) && (CounterY<=ScorePositionY+14*3);


ScoreWhiteUnit <= (CounterX>=ScorePositionX+3+1*3) && (CounterX<=ScorePositionX+3+8*3) && (CounterY>=ScorePositionY+1*3) && (CounterY<=ScorePositionY+4*3)

||          (CounterX>=ScorePositionX+3+5*3) && (CounterX<=ScorePositionX+3+8*3) && (CounterY>=ScorePositionY+4*3) && (CounterY<=ScorePositionY+5*3)

||          (CounterX>=ScorePositionX+3+1*3) && (CounterX<=ScorePositionX+3+8*3) && (CounterY>=ScorePositionY+5*3) && (CounterY<=ScorePositionY+9*3)

||          (CounterX>=ScorePositionX+3+1*3) && (CounterX<=ScorePositionX+3+4*3) && (CounterY>=ScorePositionY+9*3) && (CounterY<=ScorePositionY+10*3)

||          (CounterX>=ScorePositionX+3+1*3) && (CounterX<=ScorePositionX+3+8*3) && (CounterY>=ScorePositionY+10*3) && (CounterY<=ScorePositionY+13*3);
end
3 : begin
ScoreBlackUnit <= (CounterX>=ScorePositionX+3+0*3) && (CounterX<=ScorePositionX+3+9*3) && (CounterY>=ScorePositionY+0*3) && (CounterY<=ScorePositionY+1*3)

||          (CounterX>=ScorePositionX+3+0*3) && (CounterX<=ScorePositionX+3+1*3) && (CounterY>=ScorePositionY+1*3) && (CounterY<=ScorePositionY+4*3)
||          (CounterX>=ScorePositionX+3+8*3) && (CounterX<=ScorePositionX+3+9*3) && (CounterY>=ScorePositionY+1*3) && (CounterY<=ScorePositionY+4*3)

||          (CounterX>=ScorePositionX+3+0*3) && (CounterX<=ScorePositionX+3+5*3) && (CounterY>=ScorePositionY+4*3) && (CounterY<=ScorePositionY+5*3)
||          (CounterX>=ScorePositionX+3+8*3) && (CounterX<=ScorePositionX+3+9*3) && (CounterY>=ScorePositionY+4*3) && (CounterY<=ScorePositionY+5*3)

||          (CounterX>=ScorePositionX+3+0*3) && (CounterX<=ScorePositionX+3+1*3) && (CounterY>=ScorePositionY+5*3) && (CounterY<=ScorePositionY+9*3)
||          (CounterX>=ScorePositionX+3+8*3) && (CounterX<=ScorePositionX+3+9*3) && (CounterY>=ScorePositionY+5*3) && (CounterY<=ScorePositionY+9*3)

||          (CounterX>=ScorePositionX+3+0*3) && (CounterX<=ScorePositionX+3+5*3) && (CounterY>=ScorePositionY+9*3) && (CounterY<=ScorePositionY+10*3)
||          (CounterX>=ScorePositionX+3+8*3) && (CounterX<=ScorePositionX+3+9*3) && (CounterY>=ScorePositionY+9*3) && (CounterY<=ScorePositionY+10*3)

||          (CounterX>=ScorePositionX+3+0*3) && (CounterX<=ScorePositionX+3+1*3) && (CounterY>=ScorePositionY+10*3) && (CounterY<=ScorePositionY+13*3)
||          (CounterX>=ScorePositionX+3+8*3) && (CounterX<=ScorePositionX+3+9*3) && (CounterY>=ScorePositionY+10*3) && (CounterY<=ScorePositionY+13*3)

||	    (CounterX>=ScorePositionX+3+0*3) && (CounterX<=ScorePositionX+3+9*3) && (CounterY>=ScorePositionY+13*3) && (CounterY<=ScorePositionY+14*3);


ScoreWhiteUnit <= (CounterX>=ScorePositionX+3+1*3) && (CounterX<=ScorePositionX+3+8*3) && (CounterY>=ScorePositionY+1*3) && (CounterY<=ScorePositionY+4*3)

||          (CounterX>=ScorePositionX+3+5*3) && (CounterX<=ScorePositionX+3+8*3) && (CounterY>=ScorePositionY+4*3) && (CounterY<=ScorePositionY+5*3)

||          (CounterX>=ScorePositionX+3+1*3) && (CounterX<=ScorePositionX+3+8*3) && (CounterY>=ScorePositionY+5*3) && (CounterY<=ScorePositionY+9*3)

||          (CounterX>=ScorePositionX+3+5*3) && (CounterX<=ScorePositionX+3+8*3) && (CounterY>=ScorePositionY+9*3) && (CounterY<=ScorePositionY+10*3)

||          (CounterX>=ScorePositionX+3+1*3) && (CounterX<=ScorePositionX+3+8*3) && (CounterY>=ScorePositionY+10*3) && (CounterY<=ScorePositionY+13*3);

////////////////////////////////////
end
4 : begin
ScoreBlackUnit <= (CounterX>=ScorePositionX+3+0*3) && (CounterX<=ScorePositionX+3+9*3) && (CounterY>=ScorePositionY+0*3) && (CounterY<=ScorePositionY+1*3)

||          (CounterX>=ScorePositionX+3+0*3) && (CounterX<=ScorePositionX+3+1*3) && (CounterY>=ScorePositionY+1*3) && (CounterY<=ScorePositionY+9*3)
||          (CounterX>=ScorePositionX+3+4*3) && (CounterX<=ScorePositionX+3+5*3) && (CounterY>=ScorePositionY+1*3) && (CounterY<=ScorePositionY+6*3)
||          (CounterX>=ScorePositionX+3+8*3) && (CounterX<=ScorePositionX+3+9*3) && (CounterY>=ScorePositionY+1*3) && (CounterY<=ScorePositionY+13*3)

||          (CounterX>=ScorePositionX+3+0*3) && (CounterX<=ScorePositionX+3+5*3) && (CounterY>=ScorePositionY+9*3) && (CounterY<=ScorePositionY+10*3)

||          (CounterX>=ScorePositionX+3+4*3) && (CounterX<=ScorePositionX+3+5*3) && (CounterY>=ScorePositionY+10*3) && (CounterY<=ScorePositionY+13*3)

||	    (CounterX>=ScorePositionX+3+4*3) && (CounterX<=ScorePositionX+3+9*3) && (CounterY>=ScorePositionY+13*3) && (CounterY<=ScorePositionY+14*3);


ScoreWhiteUnit <= (CounterX>=ScorePositionX+3+1*3) && (CounterX<=ScorePositionX+3+4*3) && (CounterY>=ScorePositionY+1*3) && (CounterY<=ScorePositionY+9*3)

||          (CounterX>=ScorePositionX+3+4*3) && (CounterX<=ScorePositionX+3+5*3) && (CounterY>=ScorePositionY+6*3) && (CounterY<=ScorePositionY+9*3)

||          (CounterX>=ScorePositionX+3+5*3) && (CounterX<=ScorePositionX+3+8*3) && (CounterY>=ScorePositionY+1*3) && (CounterY<=ScorePositionY+13*3);

////////////////////////////////////////
end
5 : begin
ScoreBlackUnit <= (CounterX>=ScorePositionX+3+0*3) && (CounterX<=ScorePositionX+3+9*3) && (CounterY>=ScorePositionY+0*3) && (CounterY<=ScorePositionY+1*3)
||          (CounterX>=ScorePositionX+3+0*3) && (CounterX<=ScorePositionX+3+1*3) && (CounterY>=ScorePositionY+1*3) && (CounterY<=ScorePositionY+13*3)
||          (CounterX>=ScorePositionX+3+8*3) && (CounterX<=ScorePositionX+3+9*3) && (CounterY>=ScorePositionY+1*3) && (CounterY<=ScorePositionY+13*3)
||          (CounterX>=ScorePositionX+3+4*3) && (CounterX<=ScorePositionX+3+8*3) && (CounterY>=ScorePositionY+4*3) && (CounterY<=ScorePositionY+5*3)
||          (CounterX>=ScorePositionX+3+1*3) && (CounterX<=ScorePositionX+3+5*3) && (CounterY>=ScorePositionY+9*3) && (CounterY<=ScorePositionY+10*3)
||	    (CounterX>=ScorePositionX+3+0*3) && (CounterX<=ScorePositionX+3+9*3) && (CounterY>=ScorePositionY+13*3) && (CounterY<=ScorePositionY+14*3);
ScoreWhiteUnit <= (CounterX>=ScorePositionX+3+1*3) && (CounterX<=ScorePositionX+3+8*3) && (CounterY>=ScorePositionY+1*3) && (CounterY<=ScorePositionY+4*3)
||          (CounterX>=ScorePositionX+3+1*3) && (CounterX<=ScorePositionX+3+4*3) && (CounterY>=ScorePositionY+4*3) && (CounterY<=ScorePositionY+5*3)
||          (CounterX>=ScorePositionX+3+1*3) && (CounterX<=ScorePositionX+3+8*3) && (CounterY>=ScorePositionY+5*3) && (CounterY<=ScorePositionY+9*3)
||          (CounterX>=ScorePositionX+3+5*3) && (CounterX<=ScorePositionX+3+8*3) && (CounterY>=ScorePositionY+9*3) && (CounterY<=ScorePositionY+10*3)
||          (CounterX>=ScorePositionX+3+1*3) && (CounterX<=ScorePositionX+3+8*3) && (CounterY>=ScorePositionY+10*3) && (CounterY<=ScorePositionY+13*3);
end
6 : begin
ScoreBlackUnit <= (CounterX>=ScorePositionX+3+0*3) && (CounterX<=ScorePositionX+3+9*3) && (CounterY>=ScorePositionY+0*3) && (CounterY<=ScorePositionY+1*3)
||          (CounterX>=ScorePositionX+3+0*3) && (CounterX<=ScorePositionX+3+1*3) && (CounterY>=ScorePositionY+1*3) && (CounterY<=ScorePositionY+13*3)
||          (CounterX>=ScorePositionX+3+8*3) && (CounterX<=ScorePositionX+3+9*3) && (CounterY>=ScorePositionY+1*3) && (CounterY<=ScorePositionY+13*3)
||          (CounterX>=ScorePositionX+3+4*3) && (CounterX<=ScorePositionX+3+8*3) && (CounterY>=ScorePositionY+4*3) && (CounterY<=ScorePositionY+5*3)
||          (CounterX>=ScorePositionX+3+4*3) && (CounterX<=ScorePositionX+3+5*3) && (CounterY>=ScorePositionY+9*3) && (CounterY<=ScorePositionY+10*3)
||	    (CounterX>=ScorePositionX+3+0*3) && (CounterX<=ScorePositionX+3+9*3) && (CounterY>=ScorePositionY+13*3) && (CounterY<=ScorePositionY+14*3);
ScoreWhiteUnit <= (CounterX>=ScorePositionX+3+1*3) && (CounterX<=ScorePositionX+3+8*3) && (CounterY>=ScorePositionY+1*3) && (CounterY<=ScorePositionY+4*3)
||          (CounterX>=ScorePositionX+3+1*3) && (CounterX<=ScorePositionX+3+4*3) && (CounterY>=ScorePositionY+4*3) && (CounterY<=ScorePositionY+5*3)
||          (CounterX>=ScorePositionX+3+1*3) && (CounterX<=ScorePositionX+3+8*3) && (CounterY>=ScorePositionY+5*3) && (CounterY<=ScorePositionY+9*3)
||          (CounterX>=ScorePositionX+3+1*3) && (CounterX<=ScorePositionX+3+4*3) && (CounterY>=ScorePositionY+9*3) && (CounterY<=ScorePositionY+10*3)
||          (CounterX>=ScorePositionX+3+5*3) && (CounterX<=ScorePositionX+3+8*3) && (CounterY>=ScorePositionY+9*3) && (CounterY<=ScorePositionY+10*3)
||          (CounterX>=ScorePositionX+3+1*3) && (CounterX<=ScorePositionX+3+8*3) && (CounterY>=ScorePositionY+10*3) && (CounterY<=ScorePositionY+13*3);
end
7 : begin
ScoreBlackUnit <= (CounterX>=ScorePositionX+3+0*3) && (CounterX<=ScorePositionX+3+9*3) && (CounterY>=ScorePositionY+0*3) && (CounterY<=ScorePositionY+1*3)
||          (CounterX>=ScorePositionX+3+0*3) && (CounterX<=ScorePositionX+3+1*3) && (CounterY>=ScorePositionY+1*3) && (CounterY<=ScorePositionY+4*3)
||          (CounterX>=ScorePositionX+3+0*3) && (CounterX<=ScorePositionX+3+5*3) && (CounterY>=ScorePositionY+4*3) && (CounterY<=ScorePositionY+5*3)
||          (CounterX>=ScorePositionX+3+4*3) && (CounterX<=ScorePositionX+3+5*3) && (CounterY>=ScorePositionY+5*3) && (CounterY<=ScorePositionY+13*3)
||          (CounterX>=ScorePositionX+3+8*3) && (CounterX<=ScorePositionX+3+9*3) && (CounterY>=ScorePositionY+1*3) && (CounterY<=ScorePositionY+13*3)
||	    (CounterX>=ScorePositionX+3+4*3) && (CounterX<=ScorePositionX+3+9*3) && (CounterY>=ScorePositionY+13*3) && (CounterY<=ScorePositionY+14*3);
ScoreWhiteUnit <= (CounterX>=ScorePositionX+3+1*3) && (CounterX<=ScorePositionX+3+8*3) && (CounterY>=ScorePositionY+1*3) && (CounterY<=ScorePositionY+4*3)
||          (CounterX>=ScorePositionX+3+5*3) && (CounterX<=ScorePositionX+3+8*3) && (CounterY>=ScorePositionY+4*3) && (CounterY<=ScorePositionY+13*3);
end
8 : begin
ScoreBlackUnit <= (CounterX>=ScorePositionX+3+0*3) && (CounterX<=ScorePositionX+3+9*3) && (CounterY>=ScorePositionY+0*3) && (CounterY<=ScorePositionY+1*3)
||          (CounterX>=ScorePositionX+3+0*3) && (CounterX<=ScorePositionX+3+1*3) && (CounterY>=ScorePositionY+1*3) && (CounterY<=ScorePositionY+13*3)
||          (CounterX>=ScorePositionX+3+8*3) && (CounterX<=ScorePositionX+3+9*3) && (CounterY>=ScorePositionY+1*3) && (CounterY<=ScorePositionY+13*3)
||          (CounterX>=ScorePositionX+3+4*3) && (CounterX<=ScorePositionX+3+5*3) && (CounterY>=ScorePositionY+4*3) && (CounterY<=ScorePositionY+5*3)
||          (CounterX>=ScorePositionX+3+4*3) && (CounterX<=ScorePositionX+3+5*3) && (CounterY>=ScorePositionY+9*3) && (CounterY<=ScorePositionY+10*3)
||	    (CounterX>=ScorePositionX+3+0*3) && (CounterX<=ScorePositionX+3+9*3) && (CounterY>=ScorePositionY+13*3) && (CounterY<=ScorePositionY+14*3);
ScoreWhiteUnit <= (CounterX>=ScorePositionX+3+1*3) && (CounterX<=ScorePositionX+3+4*3) && (CounterY>=ScorePositionY+1*3) && (CounterY<=ScorePositionY+13*3)
||          (CounterX>=ScorePositionX+3+5*3) && (CounterX<=ScorePositionX+3+8*3) && (CounterY>=ScorePositionY+1*3) && (CounterY<=ScorePositionY+13*3)
||          (CounterX>=ScorePositionX+3+4*3) && (CounterX<=ScorePositionX+3+5*3) && (CounterY>=ScorePositionY+1*3) && (CounterY<=ScorePositionY+4*3)
||          (CounterX>=ScorePositionX+3+4*3) && (CounterX<=ScorePositionX+3+5*3) && (CounterY>=ScorePositionY+5*3) && (CounterY<=ScorePositionY+9*3)
||          (CounterX>=ScorePositionX+3+4*3) && (CounterX<=ScorePositionX+3+5*3) && (CounterY>=ScorePositionY+10*3) && (CounterY<=ScorePositionY+13*3);
end
9 : begin
ScoreBlackUnit <= (CounterX>=ScorePositionX+3+0*3) && (CounterX<=ScorePositionX+3+9*3) && (CounterY>=ScorePositionY+0*3) && (CounterY<=ScorePositionY+1*3)
||          (CounterX>=ScorePositionX+3+0*3) && (CounterX<=ScorePositionX+3+1*3) && (CounterY>=ScorePositionY+1*3) && (CounterY<=ScorePositionY+13*3)
||          (CounterX>=ScorePositionX+3+8*3) && (CounterX<=ScorePositionX+3+9*3) && (CounterY>=ScorePositionY+1*3) && (CounterY<=ScorePositionY+13*3)
||          (CounterX>=ScorePositionX+3+4*3) && (CounterX<=ScorePositionX+3+5*3) && (CounterY>=ScorePositionY+4*3) && (CounterY<=ScorePositionY+5*3)
||          (CounterX>=ScorePositionX+3+1*3) && (CounterX<=ScorePositionX+3+5*3) && (CounterY>=ScorePositionY+9*3) && (CounterY<=ScorePositionY+10*3)
||	    (CounterX>=ScorePositionX+3+0*3) && (CounterX<=ScorePositionX+3+9*3) && (CounterY>=ScorePositionY+13*3) && (CounterY<=ScorePositionY+14*3);
ScoreWhiteUnit <= (CounterX>=ScorePositionX+3+1*3) && (CounterX<=ScorePositionX+3+4*3) && (CounterY>=ScorePositionY+1*3) && (CounterY<=ScorePositionY+9*3)
||          (CounterX>=ScorePositionX+3+5*3) && (CounterX<=ScorePositionX+3+8*3) && (CounterY>=ScorePositionY+1*3) && (CounterY<=ScorePositionY+13*3)
||          (CounterX>=ScorePositionX+3+1*3) && (CounterX<=ScorePositionX+3+5*3) && (CounterY>=ScorePositionY+10*3) && (CounterY<=ScorePositionY+13*3)
||          (CounterX>=ScorePositionX+3+4*3) && (CounterX<=ScorePositionX+3+5*3) && (CounterY>=ScorePositionY+1*3) && (CounterY<=ScorePositionY+4*3)
||          (CounterX>=ScorePositionX+3+4*3) && (CounterX<=ScorePositionX+3+5*3) && (CounterY>=ScorePositionY+5*3) && (CounterY<=ScorePositionY+9*3);
end

default: begin
	ScoreBlackUnit <= 0;
	ScoreWhiteUnit <= 0;
end
endcase

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
if (Ten > 0)
case (Ten)
0 : begin

ScoreBlackTen <= (CounterX>=ScorePositionX-30+0*3) && (CounterX<=ScorePositionX-30+9*3) && (CounterY>=ScorePositionY+0*3) && (CounterY<=ScorePositionY+1*3)

||          (CounterX>=ScorePositionX-30+0*3) && (CounterX<=ScorePositionX-30+1*3) && (CounterY>=ScorePositionY+1*3) && (CounterY<=ScorePositionY+4*3)
||          (CounterX>=ScorePositionX-30+8*3) && (CounterX<=ScorePositionX-30+9*3) && (CounterY>=ScorePositionY+1*3) && (CounterY<=ScorePositionY+4*3)

||          (CounterX>=ScorePositionX-30+0*3) && (CounterX<=ScorePositionX-30+1*3) && (CounterY>=ScorePositionY+4*3) && (CounterY<=ScorePositionY+10*3)
||          (CounterX>=ScorePositionX-30+4*3) && (CounterX<=ScorePositionX-30+5*3) && (CounterY>=ScorePositionY+4*3) && (CounterY<=ScorePositionY+10*3)
||          (CounterX>=ScorePositionX-30+8*3) && (CounterX<=ScorePositionX-30+9*3) && (CounterY>=ScorePositionY+4*3) && (CounterY<=ScorePositionY+10*3)

||          (CounterX>=ScorePositionX-30+0*3) && (CounterX<=ScorePositionX-30+1*3) && (CounterY>=ScorePositionY+10*3) && (CounterY<=ScorePositionY+13*3)
||          (CounterX>=ScorePositionX-30+8*3) && (CounterX<=ScorePositionX-30+9*3) && (CounterY>=ScorePositionY+10*3) && (CounterY<=ScorePositionY+13*3)

||	    (CounterX>=ScorePositionX-30+0*3) && (CounterX<=ScorePositionX-30+9*3) && (CounterY>=ScorePositionY+13*3) && (CounterY<=ScorePositionY+14*3);

ScoreWhiteTen <=  (CounterX>=ScorePositionX-30+1*3) && (CounterX<=ScorePositionX-30+8*3) && (CounterY>=ScorePositionY+1*3) && (CounterY<=ScorePositionY+4*3)

||	    (CounterX>=ScorePositionX-30+1*3) && (CounterX<=ScorePositionX-30+4*3) && (CounterY>=ScorePositionY+4*3) && (CounterY<=ScorePositionY+10*3)
||	    (CounterX>=ScorePositionX-30+5*3) && (CounterX<=ScorePositionX-30+8*3) && (CounterY>=ScorePositionY+4*3) && (CounterY<=ScorePositionY+10*3)

||	    (CounterX>=ScorePositionX-30+1*3) && (CounterX<=ScorePositionX-30+8*3) && (CounterY>=ScorePositionY+10*3) && (CounterY<=ScorePositionY+13*3);

end
1 : begin

ScoreBlackTen <= (CounterX>=ScorePositionX-30+2*3) && (CounterX<=ScorePositionX-30+8*3) && (CounterY>=ScorePositionY+0*3) && (CounterY<=ScorePositionY+1*3)

||          (CounterX>=ScorePositionX-30+2*3) && (CounterX<=ScorePositionX-30+3*3) && (CounterY>=ScorePositionY+1*3) && (CounterY<=ScorePositionY+4*3)
||          (CounterX>=ScorePositionX-30+7*3) && (CounterX<=ScorePositionX-30+8*3) && (CounterY>=ScorePositionY+1*3) && (CounterY<=ScorePositionY+4*3)

||          (CounterX>=ScorePositionX-30+2*3) && (CounterX<=ScorePositionX-30+4*3) && (CounterY>=ScorePositionY+4*3) && (CounterY<=ScorePositionY+5*3)
||          (CounterX>=ScorePositionX-30+7*3) && (CounterX<=ScorePositionX-30+8*3) && (CounterY>=ScorePositionY+4*3) && (CounterY<=ScorePositionY+5*3)

||          (CounterX>=ScorePositionX-30+3*3) && (CounterX<=ScorePositionX-30+4*3) && (CounterY>=ScorePositionY+5*3) && (CounterY<=ScorePositionY+13*3)
||          (CounterX>=ScorePositionX-30+7*3) && (CounterX<=ScorePositionX-30+8*3) && (CounterY>=ScorePositionY+5*3) && (CounterY<=ScorePositionY+13*3)

||	    (CounterX>=ScorePositionX-30+3*3) && (CounterX<=ScorePositionX-30+8*3) && (CounterY>=ScorePositionY+13*3) && (CounterY<=ScorePositionY+14*3);

ScoreWhiteTen <=  (CounterX>=ScorePositionX-30+3*3) && (CounterX<=ScorePositionX-30+7*3) && (CounterY>=ScorePositionY+1*3) && (CounterY<=ScorePositionY+4*3)

||	    (CounterX>=ScorePositionX-30+4*3) && (CounterX<=ScorePositionX-30+7*3) && (CounterY>=ScorePositionY+4*3) && (CounterY<=ScorePositionY+13*3);

end
2 : begin
ScoreBlackTen <= (CounterX>=ScorePositionX-30+0*3) && (CounterX<=ScorePositionX-30+9*3) && (CounterY>=ScorePositionY+0*3) && (CounterY<=ScorePositionY+1*3)

||          (CounterX>=ScorePositionX-30+0*3) && (CounterX<=ScorePositionX-30+1*3) && (CounterY>=ScorePositionY+1*3) && (CounterY<=ScorePositionY+4*3)
||          (CounterX>=ScorePositionX-30+8*3) && (CounterX<=ScorePositionX-30+9*3) && (CounterY>=ScorePositionY+1*3) && (CounterY<=ScorePositionY+4*3)

||          (CounterX>=ScorePositionX-30+0*3) && (CounterX<=ScorePositionX-30+5*3) && (CounterY>=ScorePositionY+4*3) && (CounterY<=ScorePositionY+5*3)
||          (CounterX>=ScorePositionX-30+8*3) && (CounterX<=ScorePositionX-30+9*3) && (CounterY>=ScorePositionY+4*3) && (CounterY<=ScorePositionY+5*3)

||          (CounterX>=ScorePositionX-30+0*3) && (CounterX<=ScorePositionX-30+1*3) && (CounterY>=ScorePositionY+5*3) && (CounterY<=ScorePositionY+9*3)
||          (CounterX>=ScorePositionX-30+8*3) && (CounterX<=ScorePositionX-30+9*3) && (CounterY>=ScorePositionY+5*3) && (CounterY<=ScorePositionY+9*3)

||          (CounterX>=ScorePositionX-30+0*3) && (CounterX<=ScorePositionX-30+1*3) && (CounterY>=ScorePositionY+9*3) && (CounterY<=ScorePositionY+10*3)
||          (CounterX>=ScorePositionX-30+4*3) && (CounterX<=ScorePositionX-30+9*3) && (CounterY>=ScorePositionY+9*3) && (CounterY<=ScorePositionY+10*3)

||          (CounterX>=ScorePositionX-30+0*3) && (CounterX<=ScorePositionX-30+1*3) && (CounterY>=ScorePositionY+10*3) && (CounterY<=ScorePositionY+13*3)
||          (CounterX>=ScorePositionX-30+8*3) && (CounterX<=ScorePositionX-30+9*3) && (CounterY>=ScorePositionY+10*3) && (CounterY<=ScorePositionY+13*3)

||	    (CounterX>=ScorePositionX-30+0*3) && (CounterX<=ScorePositionX-30+9*3) && (CounterY>=ScorePositionY+13*3) && (CounterY<=ScorePositionY+14*3);


ScoreWhiteTen <= (CounterX>=ScorePositionX-30+1*3) && (CounterX<=ScorePositionX-30+8*3) && (CounterY>=ScorePositionY+1*3) && (CounterY<=ScorePositionY+4*3)

||          (CounterX>=ScorePositionX-30+5*3) && (CounterX<=ScorePositionX-30+8*3) && (CounterY>=ScorePositionY+4*3) && (CounterY<=ScorePositionY+5*3)

||          (CounterX>=ScorePositionX-30+1*3) && (CounterX<=ScorePositionX-30+8*3) && (CounterY>=ScorePositionY+5*3) && (CounterY<=ScorePositionY+9*3)

||          (CounterX>=ScorePositionX-30+1*3) && (CounterX<=ScorePositionX-30+4*3) && (CounterY>=ScorePositionY+9*3) && (CounterY<=ScorePositionY+10*3)

||          (CounterX>=ScorePositionX-30+1*3) && (CounterX<=ScorePositionX-30+8*3) && (CounterY>=ScorePositionY+10*3) && (CounterY<=ScorePositionY+13*3);
end
3 : begin
ScoreBlackTen <= (CounterX>=ScorePositionX-30+0*3) && (CounterX<=ScorePositionX-30+9*3) && (CounterY>=ScorePositionY+0*3) && (CounterY<=ScorePositionY+1*3)

||          (CounterX>=ScorePositionX-30+0*3) && (CounterX<=ScorePositionX-30+1*3) && (CounterY>=ScorePositionY+1*3) && (CounterY<=ScorePositionY+4*3)
||          (CounterX>=ScorePositionX-30+8*3) && (CounterX<=ScorePositionX-30+9*3) && (CounterY>=ScorePositionY+1*3) && (CounterY<=ScorePositionY+4*3)

||          (CounterX>=ScorePositionX-30+0*3) && (CounterX<=ScorePositionX-30+5*3) && (CounterY>=ScorePositionY+4*3) && (CounterY<=ScorePositionY+5*3)
||          (CounterX>=ScorePositionX-30+8*3) && (CounterX<=ScorePositionX-30+9*3) && (CounterY>=ScorePositionY+4*3) && (CounterY<=ScorePositionY+5*3)

||          (CounterX>=ScorePositionX-30+0*3) && (CounterX<=ScorePositionX-30+1*3) && (CounterY>=ScorePositionY+5*3) && (CounterY<=ScorePositionY+9*3)
||          (CounterX>=ScorePositionX-30+8*3) && (CounterX<=ScorePositionX-30+9*3) && (CounterY>=ScorePositionY+5*3) && (CounterY<=ScorePositionY+9*3)

||          (CounterX>=ScorePositionX-30+0*3) && (CounterX<=ScorePositionX-30+5*3) && (CounterY>=ScorePositionY+9*3) && (CounterY<=ScorePositionY+10*3)
||          (CounterX>=ScorePositionX-30+8*3) && (CounterX<=ScorePositionX-30+9*3) && (CounterY>=ScorePositionY+9*3) && (CounterY<=ScorePositionY+10*3)

||          (CounterX>=ScorePositionX-30+0*3) && (CounterX<=ScorePositionX-30+1*3) && (CounterY>=ScorePositionY+10*3) && (CounterY<=ScorePositionY+13*3)
||          (CounterX>=ScorePositionX-30+8*3) && (CounterX<=ScorePositionX-30+9*3) && (CounterY>=ScorePositionY+10*3) && (CounterY<=ScorePositionY+13*3)

||	    (CounterX>=ScorePositionX-30+0*3) && (CounterX<=ScorePositionX-30+9*3) && (CounterY>=ScorePositionY+13*3) && (CounterY<=ScorePositionY+14*3);


ScoreWhiteTen <= (CounterX>=ScorePositionX-30+1*3) && (CounterX<=ScorePositionX-30+8*3) && (CounterY>=ScorePositionY+1*3) && (CounterY<=ScorePositionY+4*3)

||          (CounterX>=ScorePositionX-30+5*3) && (CounterX<=ScorePositionX-30+8*3) && (CounterY>=ScorePositionY+4*3) && (CounterY<=ScorePositionY+5*3)

||          (CounterX>=ScorePositionX-30+1*3) && (CounterX<=ScorePositionX-30+8*3) && (CounterY>=ScorePositionY+5*3) && (CounterY<=ScorePositionY+9*3)

||          (CounterX>=ScorePositionX-30+5*3) && (CounterX<=ScorePositionX-30+8*3) && (CounterY>=ScorePositionY+9*3) && (CounterY<=ScorePositionY+10*3)

||          (CounterX>=ScorePositionX-30+1*3) && (CounterX<=ScorePositionX-30+8*3) && (CounterY>=ScorePositionY+10*3) && (CounterY<=ScorePositionY+13*3);

////////////////////////////////////
end
4 : begin
ScoreBlackTen <= (CounterX>=ScorePositionX-30+0*3) && (CounterX<=ScorePositionX-30+9*3) && (CounterY>=ScorePositionY+0*3) && (CounterY<=ScorePositionY+1*3)

||          (CounterX>=ScorePositionX-30+0*3) && (CounterX<=ScorePositionX-30+1*3) && (CounterY>=ScorePositionY+1*3) && (CounterY<=ScorePositionY+9*3)
||          (CounterX>=ScorePositionX-30+4*3) && (CounterX<=ScorePositionX-30+5*3) && (CounterY>=ScorePositionY+1*3) && (CounterY<=ScorePositionY+6*3)
||          (CounterX>=ScorePositionX-30+8*3) && (CounterX<=ScorePositionX-30+9*3) && (CounterY>=ScorePositionY+1*3) && (CounterY<=ScorePositionY+13*3)

||          (CounterX>=ScorePositionX-30+0*3) && (CounterX<=ScorePositionX-30+5*3) && (CounterY>=ScorePositionY+9*3) && (CounterY<=ScorePositionY+10*3)

||          (CounterX>=ScorePositionX-30+4*3) && (CounterX<=ScorePositionX-30+5*3) && (CounterY>=ScorePositionY+10*3) && (CounterY<=ScorePositionY+13*3)

||	    (CounterX>=ScorePositionX-30+4*3) && (CounterX<=ScorePositionX-30+9*3) && (CounterY>=ScorePositionY+13*3) && (CounterY<=ScorePositionY+14*3);


ScoreWhiteTen <= (CounterX>=ScorePositionX-30+1*3) && (CounterX<=ScorePositionX-30+4*3) && (CounterY>=ScorePositionY+1*3) && (CounterY<=ScorePositionY+9*3)

||          (CounterX>=ScorePositionX-30+4*3) && (CounterX<=ScorePositionX-30+5*3) && (CounterY>=ScorePositionY+6*3) && (CounterY<=ScorePositionY+9*3)

||          (CounterX>=ScorePositionX-30+5*3) && (CounterX<=ScorePositionX-30+8*3) && (CounterY>=ScorePositionY+1*3) && (CounterY<=ScorePositionY+13*3);

////////////////////////////////////////
end
5 : begin
ScoreBlackTen <= (CounterX>=ScorePositionX-30+0*3) && (CounterX<=ScorePositionX-30+9*3) && (CounterY>=ScorePositionY+0*3) && (CounterY<=ScorePositionY+1*3)
||          (CounterX>=ScorePositionX-30+0*3) && (CounterX<=ScorePositionX-30+1*3) && (CounterY>=ScorePositionY+1*3) && (CounterY<=ScorePositionY+13*3)
||          (CounterX>=ScorePositionX-30+8*3) && (CounterX<=ScorePositionX-30+9*3) && (CounterY>=ScorePositionY+1*3) && (CounterY<=ScorePositionY+13*3)
||          (CounterX>=ScorePositionX-30+4*3) && (CounterX<=ScorePositionX-30+8*3) && (CounterY>=ScorePositionY+4*3) && (CounterY<=ScorePositionY+5*3)
||          (CounterX>=ScorePositionX-30+1*3) && (CounterX<=ScorePositionX-30+5*3) && (CounterY>=ScorePositionY+9*3) && (CounterY<=ScorePositionY+10*3)
||	    (CounterX>=ScorePositionX-30+0*3) && (CounterX<=ScorePositionX-30+9*3) && (CounterY>=ScorePositionY+13*3) && (CounterY<=ScorePositionY+14*3);
ScoreWhiteTen <= (CounterX>=ScorePositionX-30+1*3) && (CounterX<=ScorePositionX-30+8*3) && (CounterY>=ScorePositionY+1*3) && (CounterY<=ScorePositionY+4*3)
||          (CounterX>=ScorePositionX-30+1*3) && (CounterX<=ScorePositionX-30+4*3) && (CounterY>=ScorePositionY+4*3) && (CounterY<=ScorePositionY+5*3)
||          (CounterX>=ScorePositionX-30+1*3) && (CounterX<=ScorePositionX-30+8*3) && (CounterY>=ScorePositionY+5*3) && (CounterY<=ScorePositionY+9*3)
||          (CounterX>=ScorePositionX-30+5*3) && (CounterX<=ScorePositionX-30+8*3) && (CounterY>=ScorePositionY+9*3) && (CounterY<=ScorePositionY+10*3)
||          (CounterX>=ScorePositionX-30+1*3) && (CounterX<=ScorePositionX-30+8*3) && (CounterY>=ScorePositionY+10*3) && (CounterY<=ScorePositionY+13*3);
end
6 : begin
ScoreBlackTen <= (CounterX>=ScorePositionX-30+0*3) && (CounterX<=ScorePositionX-30+9*3) && (CounterY>=ScorePositionY+0*3) && (CounterY<=ScorePositionY+1*3)
||          (CounterX>=ScorePositionX-30+0*3) && (CounterX<=ScorePositionX-30+1*3) && (CounterY>=ScorePositionY+1*3) && (CounterY<=ScorePositionY+13*3)
||          (CounterX>=ScorePositionX-30+8*3) && (CounterX<=ScorePositionX-30+9*3) && (CounterY>=ScorePositionY+1*3) && (CounterY<=ScorePositionY+13*3)
||          (CounterX>=ScorePositionX-30+4*3) && (CounterX<=ScorePositionX-30+8*3) && (CounterY>=ScorePositionY+4*3) && (CounterY<=ScorePositionY+5*3)
||          (CounterX>=ScorePositionX-30+4*3) && (CounterX<=ScorePositionX-30+5*3) && (CounterY>=ScorePositionY+9*3) && (CounterY<=ScorePositionY+10*3)
||	    (CounterX>=ScorePositionX-30+0*3) && (CounterX<=ScorePositionX-30+9*3) && (CounterY>=ScorePositionY+13*3) && (CounterY<=ScorePositionY+14*3);
ScoreWhiteTen <= (CounterX>=ScorePositionX-30+1*3) && (CounterX<=ScorePositionX-30+8*3) && (CounterY>=ScorePositionY+1*3) && (CounterY<=ScorePositionY+4*3)
||          (CounterX>=ScorePositionX-30+1*3) && (CounterX<=ScorePositionX-30+4*3) && (CounterY>=ScorePositionY+4*3) && (CounterY<=ScorePositionY+5*3)
||          (CounterX>=ScorePositionX-30+1*3) && (CounterX<=ScorePositionX-30+8*3) && (CounterY>=ScorePositionY+5*3) && (CounterY<=ScorePositionY+9*3)
||          (CounterX>=ScorePositionX-30+1*3) && (CounterX<=ScorePositionX-30+4*3) && (CounterY>=ScorePositionY+9*3) && (CounterY<=ScorePositionY+10*3)
||          (CounterX>=ScorePositionX-30+5*3) && (CounterX<=ScorePositionX-30+8*3) && (CounterY>=ScorePositionY+9*3) && (CounterY<=ScorePositionY+10*3)
||          (CounterX>=ScorePositionX-30+1*3) && (CounterX<=ScorePositionX-30+8*3) && (CounterY>=ScorePositionY+10*3) && (CounterY<=ScorePositionY+13*3);
end
7 : begin
ScoreBlackTen <= (CounterX>=ScorePositionX-30+0*3) && (CounterX<=ScorePositionX-30+9*3) && (CounterY>=ScorePositionY+0*3) && (CounterY<=ScorePositionY+1*3)
||          (CounterX>=ScorePositionX-30+0*3) && (CounterX<=ScorePositionX-30+1*3) && (CounterY>=ScorePositionY+1*3) && (CounterY<=ScorePositionY+4*3)
||          (CounterX>=ScorePositionX-30+0*3) && (CounterX<=ScorePositionX-30+5*3) && (CounterY>=ScorePositionY+4*3) && (CounterY<=ScorePositionY+5*3)
||          (CounterX>=ScorePositionX-30+4*3) && (CounterX<=ScorePositionX-30+5*3) && (CounterY>=ScorePositionY+5*3) && (CounterY<=ScorePositionY+13*3)
||          (CounterX>=ScorePositionX-30+8*3) && (CounterX<=ScorePositionX-30+9*3) && (CounterY>=ScorePositionY+1*3) && (CounterY<=ScorePositionY+13*3)
||	    (CounterX>=ScorePositionX-30+4*3) && (CounterX<=ScorePositionX-30+9*3) && (CounterY>=ScorePositionY+13*3) && (CounterY<=ScorePositionY+14*3);
ScoreWhiteTen <= (CounterX>=ScorePositionX-30+1*3) && (CounterX<=ScorePositionX-30+8*3) && (CounterY>=ScorePositionY+1*3) && (CounterY<=ScorePositionY+4*3)
||          (CounterX>=ScorePositionX-30+5*3) && (CounterX<=ScorePositionX-30+8*3) && (CounterY>=ScorePositionY+4*3) && (CounterY<=ScorePositionY+13*3);
end
8 : begin
ScoreBlackTen <= (CounterX>=ScorePositionX-30+0*3) && (CounterX<=ScorePositionX-30+9*3) && (CounterY>=ScorePositionY+0*3) && (CounterY<=ScorePositionY+1*3)
||          (CounterX>=ScorePositionX-30+0*3) && (CounterX<=ScorePositionX-30+1*3) && (CounterY>=ScorePositionY+1*3) && (CounterY<=ScorePositionY+13*3)
||          (CounterX>=ScorePositionX-30+8*3) && (CounterX<=ScorePositionX-30+9*3) && (CounterY>=ScorePositionY+1*3) && (CounterY<=ScorePositionY+13*3)
||          (CounterX>=ScorePositionX-30+4*3) && (CounterX<=ScorePositionX-30+5*3) && (CounterY>=ScorePositionY+4*3) && (CounterY<=ScorePositionY+5*3)
||          (CounterX>=ScorePositionX-30+4*3) && (CounterX<=ScorePositionX-30+5*3) && (CounterY>=ScorePositionY+9*3) && (CounterY<=ScorePositionY+10*3)
||	    (CounterX>=ScorePositionX-30+0*3) && (CounterX<=ScorePositionX-30+9*3) && (CounterY>=ScorePositionY+13*3) && (CounterY<=ScorePositionY+14*3);
ScoreWhiteTen <= (CounterX>=ScorePositionX-30+1*3) && (CounterX<=ScorePositionX-30+4*3) && (CounterY>=ScorePositionY+1*3) && (CounterY<=ScorePositionY+13*3)
||          (CounterX>=ScorePositionX-30+5*3) && (CounterX<=ScorePositionX-30+8*3) && (CounterY>=ScorePositionY+1*3) && (CounterY<=ScorePositionY+13*3)
||          (CounterX>=ScorePositionX-30+4*3) && (CounterX<=ScorePositionX-30+5*3) && (CounterY>=ScorePositionY+1*3) && (CounterY<=ScorePositionY+4*3)
||          (CounterX>=ScorePositionX-30+4*3) && (CounterX<=ScorePositionX-30+5*3) && (CounterY>=ScorePositionY+5*3) && (CounterY<=ScorePositionY+9*3)
||          (CounterX>=ScorePositionX-30+4*3) && (CounterX<=ScorePositionX-30+5*3) && (CounterY>=ScorePositionY+10*3) && (CounterY<=ScorePositionY+13*3);
end
9 : begin
ScoreBlackTen <= (CounterX>=ScorePositionX-30+0*3) && (CounterX<=ScorePositionX-30+9*3) && (CounterY>=ScorePositionY+0*3) && (CounterY<=ScorePositionY+1*3)
||          (CounterX>=ScorePositionX-30+0*3) && (CounterX<=ScorePositionX-30+1*3) && (CounterY>=ScorePositionY+1*3) && (CounterY<=ScorePositionY+13*3)
||          (CounterX>=ScorePositionX-30+8*3) && (CounterX<=ScorePositionX-30+9*3) && (CounterY>=ScorePositionY+1*3) && (CounterY<=ScorePositionY+13*3)
||          (CounterX>=ScorePositionX-30+4*3) && (CounterX<=ScorePositionX-30+5*3) && (CounterY>=ScorePositionY+4*3) && (CounterY<=ScorePositionY+5*3)
||          (CounterX>=ScorePositionX-30+1*3) && (CounterX<=ScorePositionX-30+5*3) && (CounterY>=ScorePositionY+9*3) && (CounterY<=ScorePositionY+10*3)
||	    (CounterX>=ScorePositionX-30+0*3) && (CounterX<=ScorePositionX-30+9*3) && (CounterY>=ScorePositionY+13*3) && (CounterY<=ScorePositionY+14*3);
ScoreWhiteTen <= (CounterX>=ScorePositionX-30+1*3) && (CounterX<=ScorePositionX-30+4*3) && (CounterY>=ScorePositionY+1*3) && (CounterY<=ScorePositionY+9*3)
||          (CounterX>=ScorePositionX-30+5*3) && (CounterX<=ScorePositionX-30+8*3) && (CounterY>=ScorePositionY+1*3) && (CounterY<=ScorePositionY+13*3)
||          (CounterX>=ScorePositionX-30+1*3) && (CounterX<=ScorePositionX-30+5*3) && (CounterY>=ScorePositionY+10*3) && (CounterY<=ScorePositionY+13*3)
||          (CounterX>=ScorePositionX-30+4*3) && (CounterX<=ScorePositionX-30+5*3) && (CounterY>=ScorePositionY+1*3) && (CounterY<=ScorePositionY+4*3)
||          (CounterX>=ScorePositionX-30+4*3) && (CounterX<=ScorePositionX-30+5*3) && (CounterY>=ScorePositionY+5*3) && (CounterY<=ScorePositionY+9*3);


end
default: begin
	ScoreBlackTen <= 0;
	ScoreWhiteTen <= 0;
end
endcase

R_Score_on <=   ScoreWhiteUnit | ScoreWhiteTen;
G_Score_on <=	ScoreWhiteUnit | ScoreWhiteTen;
B_Score_on <=	ScoreWhiteUnit | ScoreWhiteTen;

R_Score_off <=  ScoreBlackUnit | ScoreBlackTen;
G_Score_off <=  ScoreBlackUnit | ScoreBlackTen;
B_Score_off <=  ScoreBlackUnit | ScoreBlackTen;

end
endmodule
