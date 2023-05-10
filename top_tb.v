`timescale 1ns / 1ps
module top_tb();
reg sys_clk;//50MHz
reg rst_n;//低电平复位
reg [7:0] data_8bit_in;
wire [7:0] data_out_8bit;
wire dac_clk;
wire adc_clk;
top top_inst0(
    .data_8bit_in(data_8bit_in),
    .sys_clk(sys_clk),
    .rst_n(rst_n),
    .data_out_8bit(data_out_8bit),
    .dac_clk(dac_clk),
		.adc_clk(adc_clk)
);
parameter word_size_in=8;
parameter clk_period=20;//50MHz
parameter signal_period=20000;
parameter clk_half_period=clk_period/2;
parameter data_num=2000;  
parameter time_sim=data_num*signal_period/2; 
 
initial
begin
	sys_clk=1;
	rst_n=0;
	#100 rst_n=1;
	//#time_sim $stop;
	data_8bit_in=0;
end
 
always                                                 
	#clk_half_period sys_clk=~sys_clk;
 
integer Pattern;
reg [word_size_in-1:0] stimulus[1:data_num];
initial
begin
	$readmemb("C:/Users/dingboyuan/Documents/MATLAB/IIR/Bin_s.txt",stimulus);
	Pattern=0;
	repeat(data_num)
		begin
			Pattern=Pattern+1;
			data_8bit_in=stimulus[Pattern];
			#signal_period;
		end
end

// 新增部分，将输出波形数据存储到txt文件
integer file; 
integer i=0;
initial begin
   file = $fopen("C:/Users/dingboyuan/Documents/MATLAB/IIR/dout_waveform.txt","w");
end

always @(dac_clk) begin
if(i<2000) begin
    $fwrite(file, "%d\n", data_out_8bit);
		i=i+1;
end
else begin
	  $fclose(file);

end
end

initial begin
    #time_sim;
		$stop;
end

endmodule