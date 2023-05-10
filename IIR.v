`timescale 1ns / 1ps    

module IIR(data_8bit_in,clk,rst_n,data_out_8bit);
parameter ORDER = 16;
parameter word_size_in = 16;
parameter word_size_out = 32;
/**IIR滤波器系数**/
parameter b0 = 15'd0, b1 = 15'd0, b2 = 15'd0, b3 = 15'd0, b4 = 15'd0, b5 = 15'd1, b6 = 15'd1, b7 = 15'd2, b8 = 15'd2, b9 = 15'd2, b10 = 15'd1, b11 = 15'd1, b12 = 15'd0, b13 = 15'd0, b14 = 15'd0, b15 = 15'd0, b16 = 15'd0;
parameter a0 = 15'd2048, a1 = -15'd1363, a2 = 15'd3839, a3 = -15'd7263, a4 = 15'd10162, a5 = -15'd11031, a6 = 15'd9537, a7 = -15'd6664, a8 = 15'd3786, a9 = -15'd1749, a10 = 15'd653, a11 = 15'd194, a12 = 15'd45, a13 = -15'd8, a14 = 15'd1, a15 = 15'd0, a16 = 15'd0;

input clk,rst_n;
input  [7:0] data_8bit_in;
output [7:0] data_out_8bit;

wire [word_size_in-1:0]     data_16bit;
wire [word_size_out:0]      data_out_32bit;
wire [word_size_out-1:0]    data_feedforward;
wire [word_size_out-1:0]    data_feedback;
reg  [word_size_in-1:0]     sample_in[1:ORDER];
reg  [word_size_in-1:0]     sample_out[1:ORDER];

integer k;

assign data_16bit = {~data_8bit_in[7],data_8bit_in[6:0],8'd0};
assign data_out_8bit = data_out_32bit[7:0];

/**************SIXTEEN ORDER**************/
assign data_feedforward = b0 * data_16bit +
                          b1 * sample_in[1] + b2 * sample_in[2] +
                          b3 * sample_in[3] + b4 * sample_in[4] +
                          b5 * sample_in[5] + b6 * sample_in[6] +
                          b7 * sample_in[7] + b8 * sample_in[8] +
                          b9 * sample_in[9] + b10 * sample_in[10] +
                          b11 * sample_in[11] + b12 * sample_in[12] +
                          b13 * sample_in[13] + b14 * sample_in[14] +
                          b15 * sample_in[15] + b16 * sample_in[16];

assign data_feedback = a1 * sample_out[1] + a2 * sample_out[2] +
                       a3 * sample_out[3] + a4 * sample_out[4] +
                       a5 * sample_out[5] + a6 * sample_out[6] +
                       a7 * sample_out[7] + a8 * sample_out[8] +
                       a9 * sample_out[9] + a10 * sample_out[10] +
                       a11 * sample_out[11] + a12 * sample_out[12] +
                       a13 * sample_out[13] + a14 * sample_out[14] +
                       a15 * sample_out[15] + a16 * sample_out[16];

/**IIR滤波器输出（未截位）**/
assign data_out_32bit = (data_feedforward - data_feedback) / a0;

/**IIR滤波器逻辑**/
always @(posedge clk or negedge rst_n) begin
    if(!rst_n)
    for(k = 1;k<=ORDER;k = k+1)begin
        sample_in[k] <= 0;
        sample_out[k]<= 0;
    end
    else begin
        sample_in[1] <= data_16bit;
        sample_out[1] <= data_out_32bit[word_size_out-1:word_size_out-8];
    for(k=2;k<=ORDER;k=k+1)begin
        sample_in[k] <= sample_in[k-1];
        sample_out[k]<= sample_out[k-1];
    end
    end
end


endmodule
