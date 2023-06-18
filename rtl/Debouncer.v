`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    08:47:47 04/27/2014 
// Design Name: 
// Module Name:    Debouncer 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module Debouncer(
  input  clk,
  input  button_i,
  output reg button_debounced_o
  );

parameter MIN_DELAY = 50; // minimum number of cycles to count
parameter W_COUNTER = 17;
reg [W_COUNTER:0] counter; // one bit wider than min_delay

//assign button_debounced_o = counter[W_COUNTER];

always @(posedge clk) begin
  if (!button_i) begin
    // if button sensor is showing 'off' state, reset the counter
    counter <= 0;
  end 
  
  else if (!counter[W_COUNTER]) begin
    counter <= counter + 1'b1;
  end
  
  button_debounced_o <= counter[W_COUNTER];
end

endmodule

/*
module debounce(
  input  clk,
  input  button_i,
  output reg button_debounced_o
  );

parameter MIN_DELAY = 50; // minimum number of cycles to count
parameter W_COUNTER = 17;
reg [W_COUNTER:0] counter; // one bit wider than min_delay

//assign button_debounced_o = counter[W_COUNTER];

always @(posedge clk) begin
  if (!button_i) begin
    // if button sensor is showing 'off' state, reset the counter
    counter <= 0;
  end else if (!counter[W_COUNTER]) begin
    counter <= counter + 1'b1;
  end
  
  if (counter[W_COUNTER] == 1) button_debounced_o <= 1;
  else button_debounced_o <= 0;
end

endmodule
*/