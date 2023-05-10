module clock_divider (
    input wire clk_50MHz,
	 input wire		rst_n,
    output reg clk_50kHz
);

// 分频因子为1000，因此需要10位计数器
reg [9:0] counter;

always @(posedge clk_50MHz or negedge rst_n) begin
if(!rst_n)begin
counter<=0;
clk_50kHz<=0;
end
else begin
    counter <= counter + 1'b1;
    if (counter == 500 - 1) begin
        counter <= 0;
        clk_50kHz <= ~clk_50kHz;
    end
end
end
endmodule
