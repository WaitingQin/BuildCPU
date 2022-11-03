`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/02/2022 11:27:33 AM
// Design Name: 
// Module Name: count60
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



`timescale 1ns/1ps
module counter60_tb;
 
reg clk, rst_n, en;
wire[7:0] dout;
wire co;
 

always
begin
	#1 clk = ~clk;
end
 

initial
begin
	clk = 1'b0;
	rst_n = 1'b1;
	en = 1'b0;
	#2 rst_n = 1'b0;
	#2 rst_n = 1'b1; en = 1'b1;    

 
end
 
counter60 u5(.clk(clk), .rst_n(rst_n), .en(en), .dout(dout), .co(co));
 
endmodule
 
 
 
