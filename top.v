`timescale 1ns / 1ps    

module top(data_8bit_in,sys_clk,rst_n,data_out_8bit,dac_clk,adc_clk);

input sys_clk,rst_n;
input  [7:0] data_8bit_in;
output [7:0] data_out_8bit;
output dac_clk;
output adc_clk;
reg [1:0]dac_clk_reg;
wire clk_50kHz;
/**将50KHz的adc时钟延迟两个系统时钟，得到dac时钟**/
always @(posedge sys_clk or negedge rst_n) begin
    if(!rst_n) begin
        dac_clk_reg <= 0;
    end
    else begin
        dac_clk_reg[0] <= clk_50kHz;
        dac_clk_reg[1] <= dac_clk_reg[0];
    end
end

assign adc_clk = clk_50kHz;
assign dac_clk = dac_clk_reg[1];

/**例化IIR滤波器**/
IIR IIR_inst0(
    .data_8bit_in(data_8bit_in),
    .clk(clk_50kHz),
    .rst_n(rst_n),
    .data_out_8bit(data_out_8bit)
);

/**例化分频器**/
clock_divider clock_divider_1(
    .clk_50MHz(sys_clk),
	 .rst_n(rst_n),
    .clk_50kHz(clk_50kHz)
);

endmodule