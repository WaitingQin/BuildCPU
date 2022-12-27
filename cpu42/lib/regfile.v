`include "defines.vh"
module regfile(
    input wire clk,
    input wire [4:0] raddr1,
    output wire [31:0] rdata1,
    input wire [4:0] raddr2,
    output wire [31:0] rdata2,
    
    input wire we,
    input wire [4:0] waddr,
    input wire [31:0] wdata,
    
    input wire ex_wreg,
    input wire [4:0] ex_waddr,
    input wire [31:0] ex_wdata,
    
    input wire mem_wreg,
    input wire [4:0] mem_waddr,
    input wire [31:0] mem_wdata,
    
    input wire wb_wreg,
    input wire [4:0] wb_waddr,
    input wire [31:0] wb_wdata
);
    reg [31:0] reg_array [31:0];
    // write
    always @ (posedge clk) begin
        if (we && waddr!=5'b0) begin
            reg_array[waddr] <= wdata;
        end
    end

    // read out 1
    assign rdata1 = (raddr1 == 5'b0) ? 32'b0 : 
                    (ex_wreg == 1'b1 && ex_waddr==raddr1) ? ex_wdata :
                    (mem_wreg == 1'b1 && mem_waddr==raddr1) ? mem_wdata : 
                    (we == 1'b1 && waddr==raddr1) ? wdata : reg_array[raddr1];

     //read out2
    assign rdata2 = (raddr2 == 5'b0) ? 32'b0 :
                    (ex_wreg == 1'b1 && ex_waddr==raddr2) ? ex_wdata :
                    (mem_wreg == 1'b1 && mem_waddr==raddr2) ? mem_wdata :
                    (we == 1'b1 && waddr==raddr2) ? wdata: reg_array[raddr2];
                    
endmodule