`timescale 1ns / 1ps


module FlappyBird_tangnano20k
	(
		input SYS_CLK,        

        // HDMI
	    output       tmds_clk_n,
	    output       tmds_clk_p,
	    output [2:0] tmds_d_n,
	    output [2:0] tmds_d_p,

		// VGA
		output [2:0] vga_r,
		output [2:0] vga_g,
		output [2:0] vga_b,
		output 		 vga_hs,
		output 		 vga_vs,

        // AUDIO
		output 	pwm_audio_out_l,
		output 	pwm_audio_out_r,

        // PS2
		inout 	ps2_clk,
		inout 	ps2_dat,

		// Dualshock game controller
		output  joystick_clk2,
		output  joystick_mosi2,
		input   joystick_miso2,
		output  joystick_cs2,

        // Buttons
		input 	SW1,
		input 	SW2		
	);

	
	// HDMI domain clocks
	wire clk_p;     // pixel clock: 25.2 Mhz
	wire clk_p5;    // 5x pixel clock: 126.00 Mhz
	wire pll_lock;
  
	Gowin_rPLL pll_hdmi (
	  .clkin(SYS_CLK),
	  .clkout(clk_p5),
	  .lock(pll_lock)
	);
  
	Gowin_CLKDIV clk_div (
	  .clkout(clk_p),
	  .hclkin(clk_p5),
	  .resetn(pll_lock)
	);

	// Flappy topmodule instantiation
	wire vsync, hsync, vblank, hblank, red, green, blue;
	wire speaker;

	TopModule Flappy (
		.Clk		(clk_p),
		.Button		(~(nes_btn[0] | SW1)),
		.sys_reset	(~(nes_btn[1] | SW2)),
		.vga_h_sync	(hsync),
		.vga_v_sync	(vsync),
		.vga_h_blank(hblank),
		.vga_v_blank(vblank),
		.vga_R		(red),
		.vga_G		(green),
		.vga_B		(blue),
		.Speaker	(speaker)
	);


	// audio
	// wire [15:0] audio = {1'b0, speaker, 14'd0};
	assign pwm_audio_out_l = speaker;
	assign pwm_audio_out_r = speaker;

	// Dualshock controller
	 /*
	joy_rx[0:1] dualshock buttons: 0:(L D R U St R3 L3 Se)  1:(□ X O △ R1 L1 R2 L2)
	nes_btn[0:1] NES buttons:      (R L D U START SELECT B A)
	O is A, X is B
	*/
	wire [7:0] joy_rx[0:1];     // 6 RX bytes for all button/axis state
	wire [7:0] nes_btn = {~joy_rx[0][5], ~joy_rx[0][7], ~joy_rx[0][6], ~joy_rx[0][4], 
							~joy_rx[0][3], ~joy_rx[0][0], ~joy_rx[1][6], ~joy_rx[1][5]};

	reg sclk;                   // controller main clock at 250Khz
	localparam SCLK_DELAY = 25_200_000 / 250_000 / 2;
	reg [$clog2(SCLK_DELAY)-1:0] sclk_cnt;         // 25200000 / 250K / 2 = 75

	// Generate sclk
	always @(posedge clk_p) begin
		sclk_cnt <= sclk_cnt + 1;
		if (sclk_cnt == SCLK_DELAY-1) begin
			sclk = ~sclk;
			sclk_cnt <= 0;
		end
	end

	dualshock_controller controller (
		.I_CLK250K(sclk), .I_RSTn(1'b1),
		.O_psCLK(joystick_clk2), .O_psSEL(joystick_cs2), .O_psTXD(joystick_mosi2),
		.I_psRXD(joystick_miso2),
		.O_RXD_1(joy_rx[0]), .O_RXD_2(joy_rx[1]), .O_RXD_3(),
		.O_RXD_4(), .O_RXD_5(), .O_RXD_6(),
		// config=1, mode=1(analog), mode_en=1
		.I_CONF_SW(1'b0), .I_MODE_SW(1'b1), .I_MODE_EN(1'b0),
		.I_VIB_SW(2'b00), .I_VIB_DAT(8'hff)     // no vibration
	);
	

	// VGA video
	assign vga_r  = {3{red}};
	assign vga_g  = {3{green}};
	assign vga_b  = {3{blue}};
	assign vga_hs = hsync;
	assign vga_vs = vsync;


	// DVI video
	svo_hdmi_out u_hdmi (
	   .resetn		(~SW2),
	   //video clocks
	   .clk_pixel	(clk_p),
	   .clk_5x_pixel(clk_p5),
	   .locked		(pll_lock),
		//input VGA
	   .rout		({6{red}}),
	   .gout		({6{green}}),
	   .bout		({6{blue}}),
	   .hsync_n		(~hsync),
	   .vsync_n		(~vsync),
	   .hblnk_n		(~hblank),
	   //output signals
	   .tmds_clk_n	(tmds_clk_n),
	   .tmds_clk_p	(tmds_clk_p),
	   .tmds_d_n	(tmds_d_n),
	   .tmds_d_p	(tmds_d_p),
	   .tmds_ts		()
	);


//    wire [5:0] VGA_R6, VGA_G6, VGA_B6;
//    wire vdma_tvalid;
//    wire vdma_tready;
//    wire [24-1:0] vdma_tdata;	// SVO_BITS_PER_PIXEL = 24
//    wire [0:0] vdma_tuser;
//    wire [3:0] enc_tuser;
//    wire hsync_ns,vsync_ns;
//    wire hblnk;

//    wire pll_lock;
//    wire breset = SW1;
//    wire resetn = 1'b1;
//    wire clk_pixel = clk_p;
//    wire clk_p;
//    wire clk_p5;

//    // Adjust Hsync & Vsync Position
//    assign hsync_n = hsync_ns;
//    //assign vsync_n = vsync_ns;
//    reg vsync_n; 

//    reg hblnk_n;


// 	wire hblnk_ns;
// 	reg hblnk_nsd, hsync_nsd;
// 	reg [5:0] hblnk_dct;
// 	reg [15:0] hblnk_sft;

// 	always @ (posedge clk_pixel) begin
// 		//hblnk_sft <= { hblnk_sft[14:0], hblnk_ns};
// 		//hblnk_n <= hblnk_sft[15];
// 		hblnk_nsd <= hblnk_ns;
// 		if(hblnk_ns!=hblnk_nsd) hblnk_dct <= 18;
// 		else begin
// 			if(hblnk_dct==1) begin
// 				hblnk_n <= hblnk_ns;
// 			end
// 			hblnk_dct <= hblnk_dct - 1;
// 		end
// 		//
// 		hsync_nsd <= hsync_ns;
// 		if(hsync_ns && ~hsync_nsd) vsync_n <= vsync_ns;
// 	end

// 	reg [7:0] pixel_div;
// 	always @ (posedge clk_pixel) pixel_div <= pixel_div + 1;


endmodule
