`include "lib/defines.vh"
module mycpu_core(
    input wire clk,
    input wire rst,
    input wire [5:0] int,

    output wire inst_sram_en,
    output wire [3:0] inst_sram_wen,
    output wire [31:0] inst_sram_addr,
    output wire [31:0] inst_sram_wdata,
    input wire [31:0] inst_sram_rdata,

    output wire data_sram_en,
    output wire [3:0] data_sram_wen,
    output wire [31:0] data_sram_addr,
    output wire [31:0] data_sram_wdata,
    input wire [31:0] data_sram_rdata,

    output wire [31:0] debug_wb_pc,
    output wire [3:0] debug_wb_rf_wen,
    output wire [4:0] debug_wb_rf_wnum,
    output wire [31:0] debug_wb_rf_wdata
);
    wire [`IF_TO_ID_WD-1:0] if_to_id_bus;
    wire [`ID_TO_EX_WD-1:0] id_to_ex_bus;
    wire [`EX_TO_MEM_WD-1:0] ex_to_mem_bus;
    wire [`MEM_TO_WB_WD-1:0] mem_to_wb_bus;
    wire [`BR_WD-1:0] br_bus; 
    wire [`DATA_SRAM_WD-1:0] ex_dt_sram_bus;
    wire [`WB_TO_RF_WD-1:0] wb_to_rf_bus;
    wire [`StallBus-1:0] stall;
    wire [71:0] hilo_id_to_ex_bus;
    wire [65:0] hilo_ex_to_mem_bus;
    wire [65:0] hilo_mem_to_wb_bus;
    wire [65:0] hilo_wb_to_rf_bus;
    wire ex_to_id_reg;
    wire [4:0] ex_to_id_addr;
    wire [31:0] ex_to_id_data;
    wire ex_opl;
    wire ex_hi_we;
    wire ex_lo_we;
    wire [31:0] ex_hi_wdata;
    wire [31:0] ex_lo_wdata;
    wire mem_to_id_reg;
    wire [4:0] mem_to_id_addr;
    wire [31:0] mem_to_id_data;
    wire mem_hi_we;
    wire mem_lo_we;
    wire [31:0] mem_hi_wdata;
    wire [31:0] mem_lo_wdata;
    wire wb_to_id_reg;
    wire [4:0] wb_to_id_addr;
    wire [31:0] wb_to_id_data;
    wire wb_hi_we;
    wire wb_lo_we;
    wire [31:0] wb_hi_wdata;
    wire [31:0] wb_lo_wdata;
    IF u_IF(
    	.clk             (clk             ),
        .rst             (rst             ),
        .stall           (stall           ),
        .br_bus          (br_bus          ),
        .if_to_id_bus    (if_to_id_bus    ),
        .inst_sram_en    (inst_sram_en    ),
        .inst_sram_wen   (inst_sram_wen   ),
        .inst_sram_addr  (inst_sram_addr  ),
        .inst_sram_wdata (inst_sram_wdata )
    );
    

    ID u_ID(
    	.clk             (clk             ),
        .rst             (rst             ),
        .stall           (stall           ),
        .stallreq        (stallreq        ),
        .if_to_id_bus    (if_to_id_bus    ),
        .inst_sram_rdata (inst_sram_rdata ),
        .wb_to_rf_bus    (wb_to_rf_bus    ),
        .hilo_wb_to_rf_bus (hilo_wb_to_rf_bus),
        .id_to_ex_bus    (id_to_ex_bus    ),
        .hilo_id_to_ex_bus (hilo_id_to_ex_bus),
        .br_bus          (br_bus          ),
        .ex_wreg         (ex_to_id_reg    ),
        .ex_waddr        (ex_to_id_addr   ),
        .ex_wdata        (ex_to_id_data   ),
        .ex_opl          (ex_opl          ),
        .ex_hi_we        (ex_hi_we        ),
        .ex_lo_we        (ex_lo_we        ),
        .ex_hi_wdata     (ex_hi_wdata     ),
        .ex_lo_wdata     (ex_lo_wdata     ),
        .mem_wreg        (mem_to_id_reg   ),
        .mem_waddr       (mem_to_id_addr  ),
        .mem_wdata       (mem_to_id_data  ),
        .mem_hi_we       (mem_hi_we       ),
        .mem_lo_we       (mem_lo_we       ),
        .mem_hi_wdata    (mem_hi_wdata    ),
        .mem_lo_wdata    (mem_lo_wdata    ),
        .wb_wreg         (wb_to_id_reg    ),
        .wb_waddr        (wb_to_id_addr   ),
        .wb_wdata        (wb_to_id_data   ),
        .wb_hi_we        (wb_hi_we        ),
        .wb_lo_we        (wb_lo_we        ),
        .wb_hi_wdata     (wb_hi_wdata     ),
        .wb_lo_wdata     (wb_lo_wdata     )
    );

    EX u_EX(
    	.clk             (clk             ),
        .rst             (rst             ),
        .stall           (stall           ),
        .stallreq_for_ex (stallreq_for_ex ),
        .id_to_ex_bus    (id_to_ex_bus    ),
        .ex_to_mem_bus   (ex_to_mem_bus   ),
        .hilo_id_to_ex_bus (hilo_id_to_ex_bus),
        .hilo_ex_to_mem_bus (hilo_ex_to_mem_bus),
        .data_sram_en    (data_sram_en    ),
        .data_sram_wen   (data_sram_wen   ),
        .data_sram_addr  (data_sram_addr  ),
        .data_sram_wdata (data_sram_wdata ),
        .ex_wreg         (ex_to_id_reg    ),
        .ex_waddr        (ex_to_id_addr    ),
        .ex_wdata        (ex_to_id_data   ),
        .ex_opl          (ex_opl          ),
        .ex_hi_we        (ex_hi_we        ),
        .ex_lo_we        (ex_lo_we        ),
        .ex_hi_wdata     (ex_hi_wdata     ),
        .ex_lo_wdata     (ex_lo_wdata     )
    );

    MEM u_MEM(
    	.clk             (clk             ),
        .rst             (rst             ),
        .stall           (stall           ),
        .ex_to_mem_bus   (ex_to_mem_bus   ),
        .hilo_ex_to_mem_bus (hilo_ex_to_mem_bus),
        .data_sram_rdata (data_sram_rdata ),
        .mem_to_wb_bus   (mem_to_wb_bus   ),
        .hilo_mem_to_wb_bus (hilo_mem_to_wb_bus),
        .mem_wreg        (mem_to_id_reg   ),
        .mem_waddr       (mem_to_id_addr  ),
        .mem_wdata       (mem_to_id_data  ),
        .mem_hi_we       (mem_hi_we       ),
        .mem_lo_we       (mem_lo_we       ),
        .mem_hi_wdata    (mem_hi_wdata    ),
        .mem_lo_wdata    (mem_lo_wdata    )
    );
    
    WB u_WB(
    	.clk               (clk               ),
        .rst               (rst               ),
        .stall             (stall             ),
        .mem_to_wb_bus     (mem_to_wb_bus     ),
        .hilo_mem_to_wb_bus (hilo_mem_to_wb_bus),
        .wb_to_rf_bus      (wb_to_rf_bus      ),
        .hilo_wb_to_rf_bus (hilo_wb_to_rf_bus ),
        .debug_wb_pc       (debug_wb_pc       ),
        .debug_wb_rf_wen   (debug_wb_rf_wen   ),
        .debug_wb_rf_wnum  (debug_wb_rf_wnum  ),
        .debug_wb_rf_wdata (debug_wb_rf_wdata ),
        .wb_wreg           (wb_to_id_reg      ),
        .wb_waddr          (wb_to_id_addr     ),
        .wb_wdata          (wb_to_id_data     ),
        .wb_hi_we        (wb_hi_we        ),
        .wb_lo_we        (wb_lo_we        ),
        .wb_hi_wdata     (wb_hi_wdata     ),
        .wb_lo_wdata     (wb_lo_wdata     )
    );

    CTRL u_CTRL(
    	.rst   (rst   ),
        .stall (stall ),
        .stallreq_for_load (stallreq),
        .stallreq_for_ex (stallreq_for_ex)
    );
    
endmodule