`timescale 1ns / 1ps
 
module IIR_tb();
parameter word_size_in = 8;
reg clk;
reg [word_size_in-1:0] din;
reg rst_n;                                             
wire [7:0]  dout;
wire dac_clk;              
IIR i1 (
	.data_8bit_in(din),
	.clk(clk),
	.rst_n(rst_n),
	.data_out_8bit(dout),
	.dac_clk(dac_clk)
);

parameter clk_period=20000; 
parameter clk_half_period=clk_period/2;
parameter data_num=2000;  
parameter time_sim=data_num*clk_period/2; 

initial
begin
	clk=1;
	rst_n=0;
	#100 rst_n=1;
	#time_sim $stop;
	din=24'd10;
end
 
always                                                 
	#clk_half_period clk=~clk;

integer Pattern;
reg [word_size_in-1:0] stimulus[1:data_num];
initial
begin
	$readmemb("C:/Users/dingboyuan/Documents/MATLAB/IIR/Bin_s.txt",stimulus);
	Pattern=0;
	repeat(data_num)
		begin
			Pattern=Pattern+1;
			din=stimulus[Pattern];
			#clk_period;
		end
end

// 新增部分，将输出波形数据存储到txt文件
integer file; 
initial begin
   file = $fopen("dout_waveform.txt","w");
end

always @(posedge clk) begin
    $fwrite(file, "%b\n", dout);
end

initial begin
    #time_sim;
    $fclose(file);
end

endmodule
