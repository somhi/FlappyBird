set_global_assignment -name QIP_FILE ../../rtl/files.qip
set_global_assignment -name SYSTEMVERILOG_FILE ../../mist/FlappyBird_MiST.sv
set_global_assignment -name QIP_FILE ../../mist/mist-modules/mist.qip
set_global_assignment -name QIP_FILE ../DeMiSTify/controller/controller.qip
set_global_assignment -name VHDL_FILE ../demistify_config_pkg.vhd
set_global_assignment -name VHDL_FILE ../firmware/controller_rom1_byte.vhd
set_global_assignment -name VHDL_FILE ../firmware/controller_rom2_byte.vhd
set_global_assignment -name PRE_FLOW_SCRIPT_FILE quartus_sh:../../rtl/build_id.tcl
