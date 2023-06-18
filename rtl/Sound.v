module Sound (
    input clk,
    input [15:0] PipesPosition1,
    input [15:0] PipesPosition2,
    output reg speaker
);

wire sound_on = (PipesPosition1 < 10 || PipesPosition2 < 10);
reg [14:0] counter;

always @(posedge clk) begin
    if (counter == 0) begin
        speaker <= sound_on ? ~speaker : 1'b0;
        counter <= 28489;
    end else begin
        counter <= counter - 15'd1;
    end
end

endmodule
