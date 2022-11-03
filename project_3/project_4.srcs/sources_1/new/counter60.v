`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/02/2022 11:23:37 AM
// Design Name: 
// Module Name: counter60
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////



module counter60(clk, rst_n, en, dout, co);
 
input clk, rst_n, en;
output[7:0] dout;
output co;
wire co10_1, co10, co6;
wire[3:0] dout10, dout6;
 
counter10 u1(.clk(clk), .rst_n(rst_n), .en(en), .dout(dout10), .co(co10_1)); 
and u3(co10,en,co10_1); 
counter6 u2(.clk(clk), .rst_n(rst_n), .en(co10), .dout(dout6), .co(co6)); 
and u4(co, co10, co6); 
 
assign dout = {dout6,dout10}; 
endmodule
 

module counter6(clk, rst_n, en, dout, co);
 
input clk, rst_n, en;
output[3:0] dout;
reg [3:0] dout;
output co;
 
always@(posedge clk or negedge rst_n)
begin
	if(!rst_n)
		dout <= 4'b0000;       

	else if(en)
		if(dout == 4'b0101)     
			dout <= 4'b0000;
		else
			dout <= dout + 1'b1; 
	else
		dout <= dout;
 
end
 
assign co = dout[0]&dout[2];  
 
endmodule
 
 

module counter10(clk, rst_n, en, dout, co);
 
input clk, rst_n, en;
output[3:0] dout;
reg [3:0] dout;
output co;
 
always@(posedge clk or negedge rst_n)
begin
	if(!rst_n)
		dout <= 4'b0000;        

	else if(en)
		if(dout == 4'b1001)     
			dout <= 4'b0000;
		else
			dout <= dout + 1'b1; 
	else
		dout <= dout;
 
end
 
assign co = dout[0]&dout[3];  
 
endmodule
 
 
