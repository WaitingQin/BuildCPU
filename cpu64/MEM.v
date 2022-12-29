`include "lib/defines.vh"
module MEM(
    input wire clk,
    input wire rst,
    // input wire flush,
    input wire [`StallBus-1:0] stall,

    input wire [`EX_TO_MEM_WD-1:0] ex_to_mem_bus,
    input wire [65:0] hilo_ex_to_mem_bus,
    input wire [31:0] data_sram_rdata,

    output wire [`MEM_TO_WB_WD-1:0] mem_to_wb_bus,
    output wire [65:0] hilo_mem_to_wb_bus,
    output wire mem_wreg,
    output wire [4:0] mem_waddr,
    output wire [31:0] mem_wdata,
    //output wire mem_opl,
    output wire mem_hi_we,
    output wire mem_lo_we,
    output wire [31:0] mem_hi_wdata,
    output wire [31:0] mem_lo_wdata
);

    reg [`EX_TO_MEM_WD-1:0] ex_to_mem_bus_r;
    reg [65:0] hilo_ex_to_mem_bus_r;

    always @ (posedge clk) begin
        if (rst) begin
            ex_to_mem_bus_r <= `EX_TO_MEM_WD'b0;
            hilo_ex_to_mem_bus_r <= 66'b0;
        end
        // else if (flush) begin
        //     ex_to_mem_bus_r <= `EX_TO_MEM_WD'b0;
        // end
        else if (stall[3]==`Stop && stall[4]==`NoStop) begin
            ex_to_mem_bus_r <= `EX_TO_MEM_WD'b0;
            hilo_ex_to_mem_bus_r <= 66'b0;
        end
        else if (stall[3]==`NoStop) begin
            ex_to_mem_bus_r <= ex_to_mem_bus;
            hilo_ex_to_mem_bus_r <= hilo_ex_to_mem_bus;
        end
    end
    wire [31:0] mem_pc;
    wire data_ram_en;
    wire [3:0] data_ram_wen;
    wire [3:0] data_sram_wen2;
    wire sel_rf_res;
    wire rf_we;
    wire [4:0] rf_waddr;
    wire [31:0] rf_wdata;
    wire [31:0] ex_result;
    wire [31:0] mem_result;

    assign {
        mem_pc,         // 75:44
        data_ram_en,    // 43
        data_ram_wen,   // 42:39
        sel_rf_res,     // 38
        rf_we,          // 37
        rf_waddr,       // 36:32
        ex_result       // 31:0
    } =  ex_to_mem_bus_r;
    
    assign hilo_mem_to_wb_bus = hilo_ex_to_mem_bus_r;
    
    wire inst_lw,inst_lb,inst_lbu,inst_lh,inst_lhu;
    assign inst_lw  = data_ram_wen == 4'b0000 ? 1 : 0;
    assign inst_lb  = data_ram_wen == 4'b1110 ? 1 : 0;
    assign inst_lh  = data_ram_wen == 4'b1100 ? 1 : 0;
    assign inst_lbu  = data_ram_wen == 4'b1101 ? 1 : 0;
    assign inst_lhu  = data_ram_wen == 4'b0110 ? 1 : 0;

    assign data_sram_wen2 = ((inst_lb | inst_lbu) & ex_result[1:0] == 2'b00) ? 4'b0001 :
                            ((inst_lb | inst_lbu) & ex_result[1:0] == 2'b01) ? 4'b0010 :
                            ((inst_lb | inst_lbu) & ex_result[1:0] == 2'b10) ? 4'b0100 :
                            ((inst_lb | inst_lbu) & ex_result[1:0] == 2'b11) ? 4'b1000 :
                            ((inst_lh | inst_lhu) & ex_result[1:0] == 2'b00) ? 4'b0011 :
                            ((inst_lh | inst_lhu) & ex_result[1:0] == 2'b10) ? 4'b1100 : 0;

    assign mem_result =inst_lw ? data_sram_rdata:
                       data_sram_wen2 == 4'b1000 ? {(inst_lbu ? 24'b0 : {24{data_sram_rdata[31]}}), data_sram_rdata[31:24]} :
                       data_sram_wen2 == 4'b0100 ? {(inst_lbu ? 24'b0 : {24{data_sram_rdata[23]}}), data_sram_rdata[23:16]} : 
                       data_sram_wen2 == 4'b0010 ? {(inst_lbu ? 24'b0 : {24{data_sram_rdata[15]}}), data_sram_rdata[15:8 ]} :
                       data_sram_wen2 == 4'b0001 ? {(inst_lbu ? 24'b0 : {24{data_sram_rdata[7 ]}}), data_sram_rdata[7 :0 ]} :
                       data_sram_wen2 == 4'b1100 ? {(inst_lhu ? 16'b0 : {16{data_sram_rdata[31]}}), data_sram_rdata[31:16]} :
                       data_sram_wen2 == 4'b0011 ? {(inst_lhu ? 16'b0 : {16{data_sram_rdata[15]}}), data_sram_rdata[15:0 ]} : 32'b0;
    assign rf_wdata = sel_rf_res ? mem_result : ex_result;
                      
    assign mem_to_wb_bus = {
        mem_pc,     // 69:38
        rf_we,      // 37
        rf_waddr,   // 36:32
        rf_wdata    // 31:0
    };
    
    
    assign mem_wreg = rf_we;
    assign mem_waddr = rf_waddr;
    assign mem_wdata = rf_wdata;

    assign {
        mem_hi_wdata,
        mem_lo_wdata,
        mem_hi_we,
        mem_lo_we
    } = hilo_ex_to_mem_bus_r;


endmodule