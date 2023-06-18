# Clock constraints

# Automatically constrain PLL and other generated clocks
derive_pll_clocks -create_base_clocks

# Automatically calculate clock uncertainty to jitter and other effects.
derive_clock_uncertainty

# tsu/th constraints

# tco constraints

# tpd constraints

#**************************************************************
# Time Information
#**************************************************************

set_time_format -unit ns -decimal_places 3



#**************************************************************
# Create Clock
#**************************************************************

create_clock -name {SPI_SCK}  -period 41.666 -waveform { 20.8 41.666 } [get_ports {SPI_SCK}]

set mem_clk   "pll|altpll_component|auto_generated|pll1|clk[0]"
set vid_clk   "pll|altpll_component|auto_generated|pll1|clk[0]"
set game_clk  "pll|altpll_component|auto_generated|pll1|clk[0]"

#**************************************************************
# Create Generated Clock
#**************************************************************


#**************************************************************
# Set Clock Latency
#**************************************************************



#**************************************************************
# Set Clock Uncertainty
#**************************************************************

#**************************************************************
# Set Input Delay
#**************************************************************

set_input_delay -add_delay  -clock_fall -clock [get_clocks {CLOCK_27}]  1.000 [get_ports {CLOCK_27}]
set_input_delay -add_delay  -clock_fall -clock [get_clocks {SPI_SCK}]  1.000 [get_ports {CONF_DATA0}]
set_input_delay -add_delay  -clock_fall -clock [get_clocks {SPI_SCK}]  1.000 [get_ports {SPI_DI}]
set_input_delay -add_delay  -clock_fall -clock [get_clocks {SPI_SCK}]  1.000 [get_ports {SPI_SCK}]
set_input_delay -add_delay  -clock_fall -clock [get_clocks {SPI_SCK}]  1.000 [get_ports {SPI_SS2}]
set_input_delay -add_delay  -clock_fall -clock [get_clocks {SPI_SCK}]  1.000 [get_ports {SPI_SS3}]

#**************************************************************
# Set Output Delay
#**************************************************************

set_output_delay -add_delay   -clock [get_clocks {SPI_SCK}] 1.000 [get_ports {SPI_DO}]
set_output_delay -add_delay   -clock [get_clocks $game_clk]  1.000 [get_ports {AUDIO_L}]
set_output_delay -add_delay   -clock [get_clocks $game_clk]  1.000 [get_ports {AUDIO_R}]
set_output_delay -add_delay   -clock [get_clocks $game_clk] 1.000 [get_ports {LED}]
set_output_delay -add_delay   -clock [get_clocks $vid_clk]  1.000 [get_ports {VGA_*}]

#**************************************************************
# Set Clock Groups
#**************************************************************

set_clock_groups -asynchronous -group [get_clocks {SPI_SCK}] -group [get_clocks {pll|altpll_component|auto_generated|pll1|clk[*]}]

#**************************************************************
# Set False Path
#**************************************************************



#**************************************************************
# Set Multicycle Path
#**************************************************************

set_multicycle_path -to {VGA_*[*]} -setup 3
set_multicycle_path -to {VGA_*[*]} -hold 2


#**************************************************************
# Set Maximum Delay
#**************************************************************



#**************************************************************
# Set Minimum Delay
#**************************************************************



#**************************************************************
# Set Input Transition
#**************************************************************

