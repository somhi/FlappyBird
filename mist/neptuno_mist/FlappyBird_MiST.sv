module FlappyBird_MiST
(
input         CLOCK_27,
output        LED,

output  [5:0] VGA_R,
output  [5:0] VGA_G,
output  [5:0] VGA_B,
output        VGA_HS,
output        VGA_VS,

input         SPI_SCK,
inout         SPI_DO,
input         SPI_DI,
input         SPI_SS2,
input         SPI_SS3,
input         SPI_SS4,
input         CONF_DATA0,


output        AUDIO_L,
output        AUDIO_R,

`ifdef DEMISTIFY
output [15:0] DAC_L,
output [15:0] DAC_R,
`endif

//NeptUNO
input	[1:0] KEY,
output 		  STM_RST_O,

output [12:0] SDRAM_A,
inout  [15:0] SDRAM_DQ,
output        SDRAM_DQML,
output        SDRAM_DQMH,
output        SDRAM_nWE,
output        SDRAM_nCAS,
output        SDRAM_nRAS,
output        SDRAM_nCS,
output  [1:0] SDRAM_BA,
output        SDRAM_CLK,
output        SDRAM_CKE
);

//disable STM32 NeptUNO FPGA
assign STM_RST_O = 1'b0;

assign LED  = 0;
assign {SDRAM_DQ, SDRAM_A, SDRAM_BA, SDRAM_CKE, SDRAM_CLK, SDRAM_DQML, SDRAM_DQMH, SDRAM_nWE, SDRAM_nCAS, SDRAM_nRAS, SDRAM_nCS} = 'Z;

`include "build_id.v"
parameter CONF_STR = {
	"FLAPPY;;",
	"O45,Scanlines,Off,25%,50%,75%;",
	"O6,Swap Joystick,Off,On;",
	"T0,Reset;",
	"V,v",`BUILD_DATE
};

reg        reset_OSD = 0;
reg [16:0] clr_addr  = 0;
always @(posedge clk) begin
	if(~&clr_addr) clr_addr  <= clr_addr + 1'd1;
	else           reset_OSD <= 0;

	if(status[0]) begin
		clr_addr  <= 0;
		reset_OSD <= 1;
	end
end

wire reset = reset_OSD | buttons[1] | ~KEY[1] ;

wire [31:0] status;

wire [1:0]  buttons;
wire [19:0] joystick_0;
wire [19:0] joystick_1;
wire        key_pressed;
wire  [7:0] key_code;
wire        key_strobe;
wire  [1:0] scanlines = status[5:4];
wire        joyswap   = status[6];
wire        scandoublerD;

user_io #(.STRLEN(($size(CONF_STR)>>3))) user_io
(
	.clk_sys        (clk            ),
	.conf_str       (CONF_STR       ),
	.SPI_CLK        (SPI_SCK        ),
	.SPI_SS_IO      (CONF_DATA0     ),
	.SPI_MISO       (SPI_DO         ),
	.SPI_MOSI       (SPI_DI         ),
	.buttons        (buttons        ),
	.status         (status         ),
	.scandoubler_disable (scandoublerD),
	.key_strobe     (key_strobe     ),
	.key_pressed    (key_pressed    ),
	.key_code       (key_code       ),
	.joystick_0     (joystick_0     ),
	.joystick_1     (joystick_1     )
);

wire m_up1, m_down1, m_left1, m_right1, m_up1B, m_down1B, m_left1B, m_right1B;
wire m_up2, m_down2, m_left2, m_right2, m_up2B, m_down2B, m_left2B, m_right2B;
wire [11:0] m_fire1, m_fire2;

wire [19:0] joystick_0_o;
wire [19:0] joystick_1_o;

arcade_inputs inputs 
(
	.clk         ( clk         ),
	.key_strobe  ( key_strobe  ),
	.key_pressed ( key_pressed ),
	.key_code    ( key_code    ),
	.joystick_0  ( joystick_0  ),
	.joystick_1  ( joystick_1  ),
	.joyswap     ( joyswap     ),
	.oneplayer   ( 0   		   ),
	.player1     ( {m_up1B, m_down1B, m_left1B, m_right1B, m_fire1, m_up1, m_down1, m_left1, m_right1} ),
	.player2     ( {m_up2B, m_down2B, m_left2B, m_right2B, m_fire2, m_up2, m_down2, m_left2, m_right2} )
	// .player1     ( joystick_0_o ),
	// .player2     ( joystick_1_o )

);


wire clk;

pll_mist pll
(
	.inclk0	(CLOCK_27),
	.c0		(clk     )
);

wire [15:0] audio = {1'b0, speaker, 14'd0};
wire speaker;

assign AUDIO_L   = speaker;
assign AUDIO_R   = speaker;

`ifdef DEMISTIFY
assign DAC_L = audio;
assign DAC_R = audio;
`endif

wire vsync, hsync, vblank, hblank, red, green, blue;

TopModule Flappy (
	.Clk		(clk),
	.Button		(~m_fire2[0] & KEY[0]),
	.sys_reset	(~(reset | m_fire2[1])),	
	.vga_h_sync	(hsync),
	.vga_v_sync	(vsync),
	.vga_h_blank(hblank),
	.vga_v_blank(vblank),
	.vga_R		(red),
	.vga_G		(green),
	.vga_B		(blue),
	.Speaker	(speaker)
);


mist_video #(.COLOR_DEPTH(6), .SD_HCNT_WIDTH(10), .USE_BLANKS(1)) mist_video
(
	.clk_sys        ( clk              ),
	.SPI_SCK        ( SPI_SCK          ),
	.SPI_SS3        ( SPI_SS3          ),
	.SPI_DI         ( SPI_DI           ),

	.R              ( {6{red}}         ),
	.G              ( {6{green}}       ),
	.B              ( {6{blue}}        ),
	.HBlank         ( hblank           ),
	.VBlank         ( vblank           ),
	.HSync          ( hsync            ),
	.VSync          ( vsync            ),

	.VGA_R          ( VGA_R            ),
	.VGA_G          ( VGA_G            ),
	.VGA_B          ( VGA_B            ),
	.VGA_VS         ( VGA_VS           ),
	.VGA_HS         ( VGA_HS           ),

	// .rotate         ( { orientation[1], rotate } ),
	// .ce_divider     ( 3'd2             ),
	.scandoubler_disable( scandoublerD ),
	.scanlines      ( scanlines        )
	// .blend          ( blend            ),
	// .ypbpr          ( ypbpr            ),
	// .no_csync       ( no_csync         )
);


endmodule

