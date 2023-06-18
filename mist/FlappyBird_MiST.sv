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


assign LED  = 0;

assign {SDRAM_DQ, SDRAM_A, SDRAM_BA, SDRAM_CKE, SDRAM_CLK, SDRAM_DQML, SDRAM_DQMH, SDRAM_nWE, SDRAM_nCAS, SDRAM_nRAS, SDRAM_nCS} = 'Z;

`include "build_id.v"
parameter CONF_STR = {
	"FLAPPY;;",
	"O8,Aspect Ratio,4:3,16:9;",
	"R0,Reset;",
	"V,v",`BUILD_DATE
};

wire reset = status[0] | buttons[1];

wire [31:0] status;

wire [1:0] buttons;
wire [15:0] joyA;

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

	// .scandoubler_disable (scandoublerD),

	.joystick_0     (joyA           )

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
	.Clk(clk),
	.Button(~joyA[4]),
	.sys_reset(~(reset | joyA[5])),
	.vga_h_sync(hsync),
	.vga_v_sync(vsync),
	.vga_h_blank(hblank),
	.vga_v_blank(vblank),
	.vga_R(red),
	.vga_G(green),
	.vga_B(blue),
	.Speaker(speaker)
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
	.VGA_HS         ( VGA_HS           )

	// .rotate         ( { orientation[1], rotate } ),
	// .ce_divider     ( 3'd2             ),
	// .scandoubler_disable( scandoublerD ),
	// .scanlines      ( scanlines        ),
	// .blend          ( blend            ),
	// .ypbpr          ( ypbpr            ),
	// .no_csync       ( no_csync         )
);


endmodule

