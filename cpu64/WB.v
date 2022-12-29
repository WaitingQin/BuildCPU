`include "lib/defines.vh"
module WB(
    input wire clk,
    input wire rst,
    // input wire flush,
    input wire [`StallBus-1:0] stall,

    input wire [`MEM_TO_WB_WD-1:0] mem_to_wb_bus,

    input wire [65:0] hilo_mem_to_wb_bus,

    output wire [`WB_TO_RF_WD-1:0] wb_to_rf_bus,
    output wire [65:0] hilo_wb_to_rf_bus,

    output wire [31:0] debug_wb_pc,
    output wire [3:0] debug_wb_rf_wen,
    output wire [4:0] debug_wb_rf_wnum,
    output wire [31:0] debug_wb_rf_wdata,
    output wire wb_wreg,
    output wire [4:0] wb_waddr,
    output wire [31:0] wb_wdata,
    output wire wb_hi_we,
    output wire wb_lo_we,
    output wire [31:0] wb_hi_wdata,
    output wire [31:0] wb_lo_wdata
);

    reg [`MEM_TO_WB_WD-1:0] mem_to_wb_bus_r;
    reg [65:0] hilo_mem_to_wb_bus_r;

    always @ (posedge clk) begin
        if (rst) begin
            mem_to_wb_bus_r <= `MEM_TO_WB_WD'b0;
            hilo_mem_to_wb_bus_r <= 66'b0;
        end
        // else if (flush) begin
        //     mem_to_wb_bus_r <= `MEM_TO_WB_WD'b0;
        // end
        else if (stall[4]==`Stop && stall[5]==`NoStop) begin
            mem_to_wb_bus_r <= `MEM_TO_WB_WD'b0;
            hilo_mem_to_wb_bus_r <= 66'b0;
        end
        else if (stall[4]==`NoStop) begin
            mem_to_wb_bus_r <= mem_to_wb_bus;
            hilo_mem_to_wb_bus_r <= hilo_mem_to_wb_bus;
        end
    end

    wire [31:0] wb_pc;
    wire rf_we;
    wire [4:0] rf_waddr;
    wire [31:0] rf_wdata;

    assign {
        wb_pc,
        rf_we,
        rf_waddr,
        rf_wdata
    } = mem_to_wb_bus_r;

    // assign wb_to_rf_bus = mem_to_wb_bus_r[`WB_TO_RF_WD-1:0];
    assign wb_to_rf_bus = {
        rf_we,
        rf_waddr,
        rf_wdata
    };

    assign hilo_wb_to_rf_bus = hilo_mem_to_wb_bus_r;

    assign debug_wb_pc = wb_pc;
    assign debug_wb_rf_wen = {4{rf_we}};
    assign debug_wb_rf_wnum = rf_waddr;
    assign debug_wb_rf_wdata = rf_wdata;

    assign wb_wreg = rf_we;
    assign wb_waddr = rf_waddr;
    assign wb_wdata = rf_wdata;

    assign {
        wb_hi_wdata,
        wb_lo_wdata,
        wb_hi_we,
        wb_lo_we
    } = hilo_mem_to_wb_bus_r;
    
endmodule