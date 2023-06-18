
module TopModule(Clk,Button,sys_reset, vga_h_sync, vga_v_sync, vga_h_blank, vga_v_blank, vga_R, vga_G, vga_B,Speaker);
input Clk,Button,sys_reset;
output vga_h_sync, vga_v_sync, vga_h_blank, vga_v_blank, vga_R, vga_G, vga_B ,Speaker;

wire [15:0] CounterX;
wire [15:0] CounterY;
wire [24:0] Clks;
wire Status;
wire [15:0] Pattern1;
wire [15:0] Pattern2;
wire [15:0] PipesPosition1;
wire [15:0] PipesPosition2;
wire Button;

wire [2:0] background, onbackground_on, onbackground_off, bird_on, bird_off, pipes_on, pipes_off,
	pipes2_on, pipes2_off, score_on, score_off, item_on, item_off, board_on, board_off;


wire hblank, vblank;
VGAOut syncgen(
	.Clk(Clk),
	.vga_h_sync(vga_h_sync),
	.vga_v_sync(vga_v_sync),
	.vblank(vblank),
	.hblank(hblank),
	.CounterX(CounterX),
	.CounterY(CounterY)
);

//Debouncer deb (Clk,Button,Button);

reg [14:0] reset_cnt = 0;

wire Reset = ~|reset_cnt;

always @(posedge Clk) begin
	if (~sys_reset)
		reset_cnt <= 1;

	if (reset_cnt > 0)
		reset_cnt <= reset_cnt + 1'd1;
end

SlowClock s1 (
	Clk,
	Reset,
	Clks
);

////////////////////////////////////////////////////////////////////////////////////////////////////////////
StatusChecker s7 (
	Clk,
	Reset,
	CounterX,
	pipes_off[0],
	pipes2_off[0],
	bird_off[0],
	Status
);

DrawBackground s2 (
	Clk,
	Clks,
	Status,
	CounterX,
	CounterY,
	background[0],
	background[1],
	background[2]
);

DrawOnBackground s22 (
	Clk,
	Clks,
	CounterX,
	CounterY,
	onbackground_on[0],
	onbackground_on[1],
	onbackground_on[2],
	onbackground_off[0],
	onbackground_off[1],
	onbackground_off[2]
);

DrawBird s3 (
	Clk,
	Clks,
	Reset,
	CounterX,
	CounterY,
	Button,
	Status,
	bird_on[0],
	bird_on[1],
	bird_on[2],
	bird_off[0],
	bird_off[1],
	bird_off[2]
);

DrawPipes s4 (
	Clk,
	Clks,
	Reset,
	CounterX,
	CounterY,
	Button,
	Status,
	Pattern1,
	pipes_on[0],
	pipes_on[1],
	pipes_on[2],
	pipes_off[0],
	pipes_off[1],
	pipes_off[2],
	PipesPosition1
);

DrawPipes2 s44 (
	Clk,
	Clks,
	Reset,
	CounterX,
	CounterY,
	Button,
	Status,
	Pattern2,
	pipes2_on[0],
	pipes2_on[1],
	pipes2_on[2],
	pipes2_off[0],
	pipes2_off[1],
	pipes2_off[2],
	PipesPosition2
);

Pattern p (
	Clk,
	Clks,
	Reset,
	PipesPosition1,
	PipesPosition2,
	Button,
	Pattern1,
	Pattern2
);
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
DrawScore s5 (
	Clk,
	Clks,
	Reset,
	PipesPosition1,
	PipesPosition2,
	CounterX,
	CounterY,
	Button,
	Status,
	score_on[0],
	score_on[1],
	score_on[2],
	score_off[0],
	score_off[1],
	score_off[2]
);

Sound so (
	Clk,
	PipesPosition1,
	PipesPosition2,
	Speaker
);

DrawItem s6 (
	Clk,
	Clks,
	CounterX,
	CounterY,
	Button,
	item_on[0],
	item_on[1],
	item_on[2],
	item_off[0],
	item_off[1],
	item_off[2]
);

DrawBoard dd (
	Clk,
	Clks,
	Reset,
	CounterX,
	CounterY,
	Button,
	Status,
	board_on[0],
	board_on[1],
	board_on[2],
	board_off[0],
	board_off[1],
	board_off[2]
);

wire RLayer0 = (background[0] | onbackground_on[0]) & ~onbackground_off[0];
wire GLayer0 = (background[1] | onbackground_on[1]) & ~onbackground_off[1];
wire BLayer0 = (background[2] | onbackground_on[2]) & ~onbackground_off[2];

wire RLayer1 = (RLayer0 & ~pipes_off[0]) & ~pipes2_off[0];
wire GLayer1 = ((GLayer0 | pipes_on[1] | pipes2_on[1]) & ~pipes_off[1]) & ~pipes2_off[1];
wire BLayer1 = (BLayer0 & ~pipes_off[2]) & ~pipes2_off[2];

wire RLayer2 = (RLayer1 | board_on[0]) &~board_off[0];
wire GLayer2 = (GLayer1 | board_on[1]) &~board_off[1];
wire BLayer2 = (BLayer1 | board_on[2]) &~board_off[2];

wire RLayer3 = (RLayer2 | bird_on[0]) & ~bird_off[0];
wire GLayer3 = (GLayer2 | bird_on[1]) & ~bird_off[1];
wire BLayer3 = (BLayer2 | bird_on[2]) & ~bird_off[2];

wire RLayer4 = (RLayer3 | score_on[0]) & ~score_off[0];
wire GLayer4 = (GLayer3 | score_on[1]) & ~score_off[1];
wire BLayer4 = (BLayer3 | score_on[2]) & ~score_off[2];

reg vga_R, vga_G, vga_B;
reg vga_h_blank, vga_v_blank;
always @(posedge Clk)
	begin
		vga_R <= RLayer4;
		vga_G <= GLayer4;
		vga_B <= BLayer4;
		vga_h_blank <= hblank;
		vga_v_blank <= vblank;
	end
endmodule
