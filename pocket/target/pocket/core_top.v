//
// User core top-level
//
// Instantiated by the real top-level: apf_top
//

`default_nettype none

module core_top (

        //
        // physical connections
        //

        ///////////////////////////////////////////////////
        // clock inputs 74.25mhz. not phase aligned, so treat these domains as asynchronous

        input   wire            clk_74a, // mainclk1
        input   wire            clk_74b, // mainclk1

        ///////////////////////////////////////////////////
        // cartridge interface
        // switches between 3.3v and 5v mechanically
        // output enable for multibit translators controlled by pic32

        // GBA AD[15:8]
        inout   wire    [7:0]   cart_tran_bank2,
        output  wire            cart_tran_bank2_dir,

        // GBA AD[7:0]
        inout   wire    [7:0]   cart_tran_bank3,
        output  wire            cart_tran_bank3_dir,

        // GBA A[23:16]
        inout   wire    [7:0]   cart_tran_bank1,
        output  wire            cart_tran_bank1_dir,

        // GBA [7] PHI#
        // GBA [6] WR#
        // GBA [5] RD#
        // GBA [4] CS1#/CS#
        //     [3:0] unwired
        inout   wire    [7:4]   cart_tran_bank0,
        output  wire            cart_tran_bank0_dir,

        // GBA CS2#/RES#
        inout   wire            cart_tran_pin30,
        output  wire            cart_tran_pin30_dir,
        // when GBC cart is inserted, this signal when low or weak will pull GBC /RES low with a special circuit
        // the goal is that when unconfigured, the FPGA weak pullups won't interfere.
        // thus, if GBC cart is inserted, FPGA must drive this high in order to let the level translators
        // and general IO drive this pin.
        output  wire            cart_pin30_pwroff_reset,

        // GBA IRQ/DRQ
        inout   wire            cart_tran_pin31,
        output  wire            cart_tran_pin31_dir,

        // infrared
        input   wire            port_ir_rx,
        output  wire            port_ir_tx,
        output  wire            port_ir_rx_disable,

        // GBA link port
        inout   wire            port_tran_si,
        output  wire            port_tran_si_dir,
        inout   wire            port_tran_so,
        output  wire            port_tran_so_dir,
        inout   wire            port_tran_sck,
        output  wire            port_tran_sck_dir,
        inout   wire            port_tran_sd,
        output  wire            port_tran_sd_dir,

        ///////////////////////////////////////////////////
        // cellular psram 0 and 1, two chips (64mbit x2 dual die per chip)

        output  wire    [21:16] cram0_a,
        inout   wire    [15:0]  cram0_dq,
        input   wire            cram0_wait,
        output  wire            cram0_clk,
        output  wire            cram0_adv_n,
        output  wire            cram0_cre,
        output  wire            cram0_ce0_n,
        output  wire            cram0_ce1_n,
        output  wire            cram0_oe_n,
        output  wire            cram0_we_n,
        output  wire            cram0_ub_n,
        output  wire            cram0_lb_n,

        output  wire    [21:16] cram1_a,
        inout   wire    [15:0]  cram1_dq,
        input   wire            cram1_wait,
        output  wire            cram1_clk,
        output  wire            cram1_adv_n,
        output  wire            cram1_cre,
        output  wire            cram1_ce0_n,
        output  wire            cram1_ce1_n,
        output  wire            cram1_oe_n,
        output  wire            cram1_we_n,
        output  wire            cram1_ub_n,
        output  wire            cram1_lb_n,

        ///////////////////////////////////////////////////
        // sdram, 512mbit 16bit

        output  wire    [12:0]  dram_a,
        output  wire    [1:0]   dram_ba,
        inout   wire    [15:0]  dram_dq,
        output  wire    [1:0]   dram_dqm,
        output  wire            dram_clk,
        output  wire            dram_cke,
        output  wire            dram_ras_n,
        output  wire            dram_cas_n,
        output  wire            dram_we_n,

        ///////////////////////////////////////////////////
        // sram, 1mbit 16bit

        output  wire    [16:0]  sram_a,
        inout   wire    [15:0]  sram_dq,
        output  wire            sram_oe_n,
        output  wire            sram_we_n,
        output  wire            sram_ub_n,
        output  wire            sram_lb_n,

        ///////////////////////////////////////////////////
        // vblank driven by dock for sync in a certain mode

        input   wire            vblank,

        ///////////////////////////////////////////////////
        // i/o to 6515D breakout usb uart

        output  wire            dbg_tx,
        input   wire            dbg_rx,

        ///////////////////////////////////////////////////
        // i/o pads near jtag connector user can solder to

        output  wire            user1,
        input   wire            user2,

        ///////////////////////////////////////////////////
        // RFU internal i2c bus

        inout   wire            aux_sda,
        output  wire            aux_scl,

        ///////////////////////////////////////////////////
        // RFU, do not use
        output  wire            vpll_feed,

        //
        // logical connections
        //
        ///////////////////////////////////////////////////
        // video, audio output to scaler
        output  wire    [23:0]  video_rgb,
        output  wire            video_rgb_clock,
        output  wire            video_rgb_clock_90,
        output  wire            video_de,
        output  wire            video_skip,
        output  wire            video_vs,
        output  wire            video_hs,

        output  wire            audio_mclk,
        input   wire            audio_adc,
        output  wire            audio_dac,
        output  wire            audio_lrck,

        ///////////////////////////////////////////////////
        // bridge bus connection
        // synchronous to clk_74a
        output  wire            bridge_endian_little,
        input   wire    [31:0]  bridge_addr,
        input   wire            bridge_rd,
        output  reg     [31:0]  bridge_rd_data,
        input   wire            bridge_wr,
        input   wire    [31:0]  bridge_wr_data,

        ///////////////////////////////////////////////////
        // controller data
        //
        // key bitmap:
        //   [0]    dpad_up
        //   [1]    dpad_down
        //   [2]    dpad_left
        //   [3]    dpad_right
        //   [4]    face_a
        //   [5]    face_b
        //   [6]    face_x
        //   [7]    face_y
        //   [8]    trig_l1
        //   [9]    trig_r1
        //   [10]   trig_l2
        //   [11]   trig_r2
        //   [12]   trig_l3
        //   [13]   trig_r3
        //   [14]   face_select
        //   [15]   face_start
        // joy values - unsigned
        //   [ 7: 0] lstick_x
        //   [15: 8] lstick_y
        //   [23:16] rstick_x
        //   [31:24] rstick_y
        // trigger values - unsigned
        //   [ 7: 0] ltrig
        //   [15: 8] rtrig
        //
        input   wire    [15:0]  cont1_key,
        input   wire    [15:0]  cont2_key,
        input   wire    [15:0]  cont3_key,
        input   wire    [15:0]  cont4_key,
        input   wire    [31:0]  cont1_joy,
        input   wire    [31:0]  cont2_joy,
        input   wire    [31:0]  cont3_joy,
        input   wire    [31:0]  cont4_joy,
        input   wire    [15:0]  cont1_trig,
        input   wire    [15:0]  cont2_trig,
        input   wire    [15:0]  cont3_trig,
        input   wire    [15:0]  cont4_trig

    );

    // not using the IR port, so turn off both the LED, and
    // disable the receive circuit to save power
    assign port_ir_tx = 0;
    assign port_ir_rx_disable = 1;

    // bridge endianness
    assign bridge_endian_little = 0;

    // cart is unused, so set all level translators accordingly
    // directions are 0:IN, 1:OUT
    assign cart_tran_bank3 = 8'hzz;
    assign cart_tran_bank3_dir = 1'b0;
    assign cart_tran_bank2 = 8'hzz;
    assign cart_tran_bank2_dir = 1'b0;
    assign cart_tran_bank1 = 8'hzz;
    assign cart_tran_bank1_dir = 1'b0;
    assign cart_tran_bank0 = 4'hf;
    assign cart_tran_bank0_dir = 1'b1;
    assign cart_tran_pin30 = 1'b0;      // reset or cs2, we let the hw control it by itself
    assign cart_tran_pin30_dir = 1'bz;
    assign cart_pin30_pwroff_reset = 1'b0;  // hardware can control this
    assign cart_tran_pin31 = 1'bz;      // input
    assign cart_tran_pin31_dir = 1'b0;  // input

    // link port is input only
    assign port_tran_so = 1'bz;
    assign port_tran_so_dir = 1'b0;     // SO is output only
    assign port_tran_si = 1'bz;
    assign port_tran_si_dir = 1'b0;     // SI is input only
    assign port_tran_sck = 1'bz;
    assign port_tran_sck_dir = 1'b0;    // clock direction can change
    assign port_tran_sd = 1'bz;
    assign port_tran_sd_dir = 1'b0;     // SD is input and not used

    // tie off the rest of the pins we are not using
    assign cram0_a = 'h0;
    assign cram0_dq = {16{1'bZ}};
    assign cram0_clk = 0;
    assign cram0_adv_n = 1;
    assign cram0_cre = 0;
    assign cram0_ce0_n = 1;
    assign cram0_ce1_n = 1;
    assign cram0_oe_n = 1;
    assign cram0_we_n = 1;
    assign cram0_ub_n = 1;
    assign cram0_lb_n = 1;

    assign cram1_a = 'h0;
    assign cram1_dq = {16{1'bZ}};
    assign cram1_clk = 0;
    assign cram1_adv_n = 1;
    assign cram1_cre = 0;
    assign cram1_ce0_n = 1;
    assign cram1_ce1_n = 1;
    assign cram1_oe_n = 1;
    assign cram1_we_n = 1;
    assign cram1_ub_n = 1;
    assign cram1_lb_n = 1;

    assign dram_a = 'h0;
    assign dram_ba = 'h0;
    assign dram_dq = {16{1'bZ}};
    assign dram_dqm = 'h0;
    assign dram_clk = 'h0;
    assign dram_cke = 'h0;
    assign dram_ras_n = 'h1;
    assign dram_cas_n = 'h1;
    assign dram_we_n = 'h1;

    assign sram_a = 'h0;
    assign sram_dq = {16{1'bZ}};
    assign sram_oe_n  = 1;
    assign sram_we_n  = 1;
    assign sram_ub_n  = 1;
    assign sram_lb_n  = 1;

    assign dbg_tx = 1'bZ;
    assign user1 = 1'bZ;
    assign aux_scl = 1'bZ;
    assign vpll_feed = 1'bZ;

    // for bridge write data, we just broadcast it to all bus devices
    // for bridge read data, we have to mux it
    // add your own devices here
    always @(*) begin
        casex(bridge_addr)
            32'hF0000000: begin // Reset
                bridge_rd_data <= bridge_read_buffer;
            end
            32'hF1000000: begin // DIP
                bridge_rd_data <= bridge_read_buffer;
            end
            32'hF2000000: begin // MOD
                bridge_rd_data <= bridge_read_buffer;
            end
            32'hF8xxxxxx: begin
                bridge_rd_data <= cmd_bridge_rd_data;
            end
            default: begin
                bridge_rd_data <= 0;
            end
        endcase
    end


    //
    // host/target command handler
    //
    wire            reset_n;                // driven by host commands, can be used as core-wide reset
    wire    [31:0]  cmd_bridge_rd_data;

    // bridge host commands
    // synchronous to clk_74a
    wire            status_boot_done = pll_core_locked;
    wire            status_setup_done = pll_core_locked; // rising edge triggers a target command
    wire            status_running = reset_n; // we are running as soon as reset_n goes high

    wire            dataslot_requestread;
    wire    [15:0]  dataslot_requestread_id;
    wire            dataslot_requestread_ack = 1;
    wire            dataslot_requestread_ok = 1;

    wire            dataslot_requestwrite;
    wire    [15:0]  dataslot_requestwrite_id;
    wire            dataslot_requestwrite_ack = 1;
    wire            dataslot_requestwrite_ok = 1;

    wire            dataslot_allcomplete;

    wire            savestate_supported;
    wire    [31:0]  savestate_addr;
    wire    [31:0]  savestate_size;
    wire    [31:0]  savestate_maxloadsize;

    wire            savestate_start;
    wire            savestate_start_ack;
    wire            savestate_start_busy;
    wire            savestate_start_ok;
    wire            savestate_start_err;

    wire            savestate_load;
    wire            savestate_load_ack;
    wire            savestate_load_busy;
    wire            savestate_load_ok;
    wire            savestate_load_err;

    wire            osnotify_inmenu;
    // bridge target commands
    // synchronous to clk_74a


    // bridge data slot access

    wire    [9:0]   datatable_addr;
    wire            datatable_wren;
    wire    [31:0]  datatable_data;
    wire    [31:0]  datatable_q;

    core_bridge_cmd
        icb (

            .clk                ( clk_74a ),
            .reset_n            ( reset_n ),

            .bridge_endian_little   ( bridge_endian_little ),
            .bridge_addr            ( bridge_addr ),
            .bridge_rd              ( bridge_rd ),
            .bridge_rd_data         ( cmd_bridge_rd_data ),
            .bridge_wr              ( bridge_wr ),
            .bridge_wr_data         ( bridge_wr_data ),

            .status_boot_done       ( status_boot_done ),
            .status_setup_done      ( status_setup_done ),
            .status_running         ( status_running ),

            .dataslot_requestread       ( dataslot_requestread ),
            .dataslot_requestread_id    ( dataslot_requestread_id ),
            .dataslot_requestread_ack   ( dataslot_requestread_ack ),
            .dataslot_requestread_ok    ( dataslot_requestread_ok ),

            .dataslot_requestwrite      ( dataslot_requestwrite ),
            .dataslot_requestwrite_id   ( dataslot_requestwrite_id ),
            .dataslot_requestwrite_ack  ( dataslot_requestwrite_ack ),
            .dataslot_requestwrite_ok   ( dataslot_requestwrite_ok ),

            .dataslot_allcomplete   ( dataslot_allcomplete ),

            .savestate_supported    ( savestate_supported ),
            .savestate_addr         ( savestate_addr ),
            .savestate_size         ( savestate_size ),
            .savestate_maxloadsize  ( savestate_maxloadsize ),

            .savestate_start        ( savestate_start ),
            .savestate_start_ack    ( savestate_start_ack ),
            .savestate_start_busy   ( savestate_start_busy ),
            .savestate_start_ok     ( savestate_start_ok ),
            .savestate_start_err    ( savestate_start_err ),

            .savestate_load         ( savestate_load ),
            .savestate_load_ack     ( savestate_load_ack ),
            .savestate_load_busy    ( savestate_load_busy ),
            .savestate_load_ok      ( savestate_load_ok ),
            .savestate_load_err     ( savestate_load_err ),

            .osnotify_inmenu        ( osnotify_inmenu ),

            .datatable_addr         ( datatable_addr ),
            .datatable_wren         ( datatable_wren ),
            .datatable_data         ( datatable_data ),
            .datatable_q            ( datatable_q ),

        );

    //! ------------------------------------------------------------------------------------
    //! @IP Core
    //! ------------------------------------------------------------------------------------

    //! ------------------------------------------------------------------------------------
    //! Data I/O
    //! ------------------------------------------------------------------------------------
    wire        ioctl_wr;
    wire [24:0] ioctl_addr;
    wire  [7:0] ioctl_dout;

    data_loader #
        (
            .ADDRESS_SIZE(16)
        )
        data_loader_dut (
            .clk_74a              ( clk_74a              ),
            .clk_memory           ( clk_sys              ),

            .bridge_wr            ( bridge_wr            ),
            .bridge_endian_little ( bridge_endian_little ),
            .bridge_addr          ( bridge_addr          ),
            .bridge_wr_data       ( bridge_wr_data       ),

            .write_en             ( ioctl_wr             ),
            .write_addr           ( ioctl_addr           ),
            .write_data           ( ioctl_dout           )
        );

    //! ------------------------------------------------------------------------------------
    //! Interactions and Dip Switches
    //! ------------------------------------------------------------------------------------
    reg  [31:0] bridge_read_buffer;
    reg  [31:0] reset_timer;
    reg         core_reset = 1;
    reg         core_reset_reg = 1;
    wire        core_reset_s;
    reg         temp_reset;

    reg  [31:0] def_dsw = 0;
    reg  [31:0] def_mod = 0;
    wire [31:0] def_dsw_s, def_mod_s;

    always @(posedge clk_74a) begin
        temp_reset <= 0;     //! Always default this to zero
        // Reset CMD
        if(bridge_wr && bridge_addr == 32'hF0000000)  begin
            temp_reset <= 1; //! Give the timer a tickle
        end
        // DIP Switch
        if(bridge_wr && bridge_addr == 32'hF1000000)  begin
            def_dsw <= bridge_wr_data;
            temp_reset <= 1; //! Give the timer a tickle
        end
        // Core Mode Selection
        if(bridge_wr && bridge_addr == 32'hF2000000)  begin
            def_mod <= bridge_wr_data;
        end
        if(bridge_rd) begin
            casex(bridge_addr)
                32'hF0000000: begin
                    bridge_read_buffer <= core_reset_reg;
                end
                32'hF1000000: begin
                    bridge_read_buffer <= def_dsw;
                end
                32'hF2000000: begin
                    bridge_read_buffer <= def_mod;
                end
            endcase
        end
    end

    always @(posedge clk_74a) begin
        if(temp_reset) begin
            reset_timer <= 32'd8000;
            core_reset <= 0;
        end
        else begin
            if (reset_timer == 32'h0) begin
                core_reset <= 1;
            end
            else begin
                reset_timer <= reset_timer - 1;
                core_reset <= 0;
            end
        end
    end

    synch_3               crst(core_reset, core_reset_s, clk_sys);
    synch_3 #(.WIDTH(32)) sdsw(def_dsw, def_dsw_s, clk_sys);
    synch_3 #(.WIDTH(32)) smod(def_mod, def_mod_s, clk_sys);

    wire [7:0] DSW0  = def_dsw_s[7:0];
    wire [7:0] DSW1  = def_dsw_s[15:8];
    wire [7:0] DSW2  = def_dsw_s[23:16];
    wire [3:0] MODE  = def_mod_s[3:0];
    wire       RESET = ~(reset_n && core_reset_s);
    //! ------------------------------------------------------------------------------------
    //! Gamepad
    //! ------------------------------------------------------------------------------------
    wire osnotify_inmenu_s;
    synch_3 s2(osnotify_inmenu, osnotify_inmenu_s, clk_sys);
    //! Player 1 ---------------------------------------------------------------------------
    wire p1_coin,  p1_start;
    wire p1_up,    p1_down,  p1_left,  p1_right;
    wire p1_btn_a, p1_btn_b, p1_btn_x, p1_btn_y, p1_btn_r1;

    wire p1_fire = p1_btn_a | p1_btn_b| p1_btn_x | p1_btn_y;

    pocket_gamepad
        player1 (
            .iCLK   ( clk_sys   ),
            .iJOY   ( cont1_key ),

            .PAD_U  ( p1_up    ),
            .PAD_D  ( p1_down  ),
            .PAD_L  ( p1_left  ),
            .PAD_R  ( p1_right ),

            .BTN_A  ( p1_btn_a ),
            .BTN_B  ( p1_btn_b ),
            .BTN_X  ( p1_btn_x ),
            .BTN_Y  ( p1_btn_y ),

            .BTN_R1 ( p1_btn_r1 ),
            .BTN_SE ( p1_coin   ),
            .BTN_ST ( p1_start  ),
        );
    //! Player 2 ---------------------------------------------------------------------------
    wire p2_coin, p2_start;
    wire p2_up, p2_down, p2_left, p2_right;
    wire p2_btn_a, p2_btn_b, p2_btn_x, p2_btn_y;

    wire p2_fire = p2_btn_a | p2_btn_b| p2_btn_x | p2_btn_y;

    pocket_gamepad
        player2 (
            .iCLK   ( clk_sys   ),
            .iJOY   ( cont2_key ),

            .PAD_U  ( p2_up    ),
            .PAD_D  ( p2_down  ),
            .PAD_L  ( p2_left  ),
            .PAD_R  ( p2_right ),

            .BTN_A  ( p2_btn_a ),
            .BTN_B  ( p2_btn_b ),
            .BTN_X  ( p2_btn_x ),
            .BTN_Y  ( p2_btn_y ),

            .BTN_SE ( p2_coin  ),
            .BTN_ST ( p2_start ),
        );

    wire m_up        = p1_up     | p2_up;
    wire m_down      = p1_down   | p2_down;
    wire m_left      = p1_left   | p2_left;
    wire m_right     = p1_right  | p2_right;
    wire m_fire      = p1_fire   | p2_fire;
    wire m_coin      = p1_coin   | p2_coin;
    wire m_p2_start  = p1_btn_r1 | p2_start;

    //! ------------------------------------------------------------------------------------
    //! A/V Signals
    //! ------------------------------------------------------------------------------------
    wire [10:0] flappy_snd;            //! Audio
    wire        flappy_speaker;

    wire        flappy_hs, flappy_vs;  //! Sync Horizontal/Vertical
    wire        flappy_hb, flappy_vb;  //! Blank Horizontal/Vertical
    wire        flappy_red, flappy_green, flappy_blue;    // RGB 111
    
    wire [23:0] flappy_rgb24 = {{8{flappy_red}}, {8{flappy_green}}, {8{flappy_blue}}};
    wire        flappy_de = ~(flappy_hb | flappy_vb); //! Data Enable
    //! ------------------------------------------------------------------------------------
    //! Core
    //! ------------------------------------------------------------------------------------
    
    TopModule Flappy (
        .Clk		(clk_sys),

        .Button		(~m_fire),
        .sys_reset	(~(RESET | p1_start)),	

        .vga_h_sync	(flappy_hs),
        .vga_v_sync	(flappy_vs),
        .vga_h_blank(flappy_hb),
        .vga_v_blank(flappy_vb),
        .vga_R		(flappy_red),
        .vga_G		(flappy_green),
        .vga_B		(flappy_blue),
        .Speaker	(flappy_speaker)
    );


    //! ------------------------------------------------------------------------------------
    //! Video
    //! ------------------------------------------------------------------------------------
    pocket_video
        pocket_video_dut (
            .iPCLK     ( clk_vid       ),
            .iPCLK_90D ( clk_vid_90deg ),

            .iRGB      ( flappy_rgb24 ),
            .iVS       ( flappy_vs    ),
            .iHS       ( flappy_hs    ),
            .iDE       ( flappy_de    ),

            .oRGB      ( video_rgb ),
            .oVS       ( video_vs  ),
            .oHS       ( video_hs  ),
            .oDE       ( video_de  ),
            .oPCLK     ( video_rgb_clock    ),
            .oPCLK_90D ( video_rgb_clock_90 )
        );

    //! ------------------------------------------------------------------------------------
    //! Audio
    //! ------------------------------------------------------------------------------------
    assign flappy_snd = {1'b0, flappy_speaker, 9'd0};

    sound_i2s #(.CHANNEL_WIDTH(11))
              sound_i2s (
                  .clk_74a    ( clk_74a    ),
                  .clk_audio  ( clk_sys    ),
                  .audio_l    ( flappy_snd ),
                  .audio_r    ( flappy_snd ),

                  .audio_mclk ( audio_mclk ),
                  .audio_dac  ( audio_dac  ),
                  .audio_lrck ( audio_lrck )
              );

    //! ------------------------------------------------------------------------------------
    //! Clocks
    //! ------------------------------------------------------------------------------------
    wire clk_sys;       //! Game Board  @ 12Mhz
    wire clk_vid;       //! Video: 256x224 @ 6Mhz
    wire clk_vid_90deg; //! Video: 90º Phase Shift
    wire pll_core_locked;

    mf_pllbase
        mp1 (
            .refclk   ( clk_74a ),
            .rst      ( 0 ),

            .outclk_0 ( clk_sys       ),
            .outclk_1 ( clk_vid       ),
            .outclk_2 ( clk_vid_90deg ),

            .locked   ( pll_core_locked )
        );
    //! @end

endmodule
