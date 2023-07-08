`timescale 1ns / 1ps


module FlappyBird_tangnano20k
	(
		input SYS_CLK,        

        // HDMI
	    // output       tmds_clk_n,
	    // output       tmds_clk_p,
	    // output [2:0] tmds_d_n,
	    // output [2:0] tmds_d_p,

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

	

endmodule
