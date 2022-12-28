`include "defines.vh"
module regfile(
    input wire clk,
    input wire [4:0] raddr1,
    output wire [31:0] rdata1,
    input wire [4:0] raddr2,
    output wire [31:0] rdata2,
    output wire [31:0] hi_rdata,
    output wire [31:0] lo_rdata,
    
    input wire we,
    input wire hi_we,
    input wire lo_we,
    input wire [4:0] waddr,
    input wire [31:0] wdata, 
    input wire [31:0] hi_wdata,
    input wire [31:0] lo_wdata,
    
    input wire ex_wreg,
    input wire [4:0] ex_waddr,
    input wire [31:0] ex_wdata,
    input wire ex_hi_we,
    input wire ex_lo_we,
    input wire [31:0] ex_hi_wdata,
    input wire [31:0] ex_lo_wdata,
    
    input wire mem_wreg,
    input wire [4:0] mem_waddr,
    input wire [31:0] mem_wdata,
    input wire mem_hi_we,
    input wire mem_lo_we,
    input wire [31:0] mem_hi_wdata,
    input wire [31:0] mem_lo_wdata,
    
    input wire wb_wreg,
    input wire [4:0] wb_waddr,
    input wire [31:0] wb_wdata,
    input wire wb_hi_we,
    input wire wb_lo_we,
    input wire [31:0] wb_hi_wdata,
    input wire [31:0] wb_lo_wdata
);
    reg [31:0] reg_array [31:0];
    reg [31:0] hi_reg;
    reg [31:0] lo_reg;

    // write reg hi lo 
    always @ (posedge clk) begin
        if (we && waddr!=5'b0) begin
            reg_array[waddr] <= wdata;
        end
        if (hi_we) begin
            hi_reg <= hi_wdata;
        end
        if (lo_we) begin
            lo_reg <= lo_wdata;
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
        
    // read hi
    assign hi_rdata = (ex_hi_we == 1'b1) ? ex_hi_wdata :
                    (mem_hi_we == 1'b1) ? mem_hi_wdata : 
                    (wb_hi_we == 1'b1) ? wb_hi_wdata : hi_reg;
    // read lo
    assign lo_rdata = (ex_lo_we == 1'b1) ? ex_lo_wdata :
                    (mem_lo_we == 1'b1) ? mem_lo_wdata : 
                    (wb_lo_we == 1'b1) ? wb_lo_wdata : lo_reg;
                    
endmodule