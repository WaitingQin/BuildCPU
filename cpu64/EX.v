`include "lib/defines.vh"
module EX(
    input wire clk,
    input wire rst,
    // input wire flush,
    input wire [`StallBus-1:0] stall,

    input wire [`ID_TO_EX_WD-1:0] id_to_ex_bus,
    input wire [71:0] hilo_id_to_ex_bus,

    output wire [`EX_TO_MEM_WD-1:0] ex_to_mem_bus,
    output wire [65:0] hilo_ex_to_mem_bus,

    output wire data_sram_en,
    output wire [3:0] data_sram_wen,
    output wire [31:0] data_sram_addr,
    output wire [31:0] data_sram_wdata,
    
    
    output wire ex_wreg,
    output wire [4:0] ex_waddr,
    output wire [31:0] ex_wdata,
    output wire ex_opl,
    output wire ex_hi_we,
    output wire ex_lo_we,
    output wire [31:0] ex_hi_wdata,
    output wire [31:0] ex_lo_wdata,
    output wire stallreq_for_ex
);

    reg [`ID_TO_EX_WD-1:0] id_to_ex_bus_r;
    reg [71:0] hilo_id_to_ex_bus_r;

    always @ (posedge clk) begin
        if (rst) begin
            id_to_ex_bus_r <= `ID_TO_EX_WD'b0;
            hilo_id_to_ex_bus_r <= 72'b0;
        end
        // else if (flush) begin
        //     id_to_ex_bus_r <= `ID_TO_EX_WD'b0;
        // end
        else if (stall[2]==`Stop && stall[3]==`NoStop) begin
            id_to_ex_bus_r <= `ID_TO_EX_WD'b0;
            hilo_id_to_ex_bus_r <= 72'b0;
        end
        else if (stall[2]==`NoStop) begin
            id_to_ex_bus_r <= id_to_ex_bus;
            hilo_id_to_ex_bus_r <= hilo_id_to_ex_bus;
        end
    end

    wire [31:0] ex_pc, inst;
    wire [11:0] alu_op;
    wire [2:0] sel_alu_src1;
    wire [3:0] sel_alu_src2;
    wire data_ram_en;
    wire [3:0] data_ram_wen;
    wire rf_we;
    wire [4:0] rf_waddr;
    wire sel_rf_res;
    wire [31:0] rf_rdata1, rf_rdata2;
    reg is_in_delayslot;
    
    wire [3:0] hilo_inst;
    wire [31:0] hi_rdata,lo_rdata;
    wire hi_e;
    wire lo_e;
    wire hi_rf_we;
    wire lo_rf_we;
    wire [31:0] hi_rf_wdata;
    wire [31:0] lo_rf_wdata;

    assign {
        ex_pc,          // 148:117
        inst,           // 116:85
        alu_op,         // 84:83
        sel_alu_src1,   // 82:80
        sel_alu_src2,   // 79:76
        data_ram_en,    // 75
        data_ram_wen,   // 74:71
        rf_we,          // 70
        rf_waddr,       // 69:65
        sel_rf_res,     // 64
        rf_rdata1,         // 63:32
        rf_rdata2          // 31:0
    } = id_to_ex_bus_r;
    
    assign {
        hilo_inst,           // 71:68
        hi_rdata,            // 67:36
        lo_rdata,            // 35:4
        hi_rf_we,               // 3 
        lo_rf_we,               // 2
        hi_e,                // 1
        lo_e                 // 0
    } = hilo_id_to_ex_bus_r;

    wire [31:0] imm_sign_extend, imm_zero_extend, sa_zero_extend;
    assign imm_sign_extend = {{16{inst[15]}},inst[15:0]};
    assign imm_zero_extend = {16'b0, inst[15:0]};
    assign sa_zero_extend = {27'b0,inst[10:6]};

    wire [31:0] alu_src1, alu_src2;
    wire [31:0] alu_result, ex_result;
    
    wire inst_sw,inst_sb,inst_sh,
         inst_mflo,inst_mfhi,inst_mthi, inst_mtlo, inst_mult, inst_multu, inst_div, inst_divu;
    assign alu_src1 = sel_alu_src1[1] ? ex_pc :
                      sel_alu_src1[2] ? sa_zero_extend : rf_rdata1;

    assign alu_src2 = sel_alu_src2[1] ? imm_sign_extend :
                      sel_alu_src2[2] ? 32'd8 :
                      sel_alu_src2[3] ? imm_zero_extend : rf_rdata2;
                      
    assign inst_sw = data_ram_wen == 4'b1111 ? 1 : 0;
    assign inst_sb = data_ram_wen == 4'b0001 ? 1 : 0;
    assign inst_sh = data_ram_wen == 4'b0011 ? 1 : 0;
    assign inst_mflo = hilo_inst == 4'b0001 ? 1 : 0;
    assign inst_mfhi = hilo_inst == 4'b0010 ? 1 : 0;
    assign inst_mtlo = hilo_inst == 4'b0011 ? 1 : 0;
    assign inst_mthi = hilo_inst == 4'b0100 ? 1 : 0;
    assign inst_mult = hilo_inst == 4'b0101 ? 1 : 0;
    assign inst_multu = hilo_inst == 4'b0110 ? 1 : 0;
    assign inst_div = hilo_inst == 4'b0111 ? 1 : 0;
    assign inst_divu = hilo_inst == 4'b1000 ? 1 : 0;
    
    alu u_alu(
    	.alu_control (alu_op ),
        .alu_src1    (alu_src1    ),
        .alu_src2    (alu_src2    ),
        .alu_result  (alu_result  )
    );

    assign ex_result = inst_mfhi ? hi_rdata : 
                       inst_mflo ? lo_rdata :
                       alu_result ;
    
    assign ex_opl = (inst[31:26]==6'b10_0011 | inst[31:26]==6'b10_0000 | inst[31:26]==6'b10_0100 
                    |inst[31:26]==6'b10_0001 | inst[31:26]==6'b10_0101) ? 1 : 0;

    assign data_sram_en = data_ram_en;    
    
    assign data_sram_wen = (inst_sb & ex_result[1:0] == 2'b00) ? 4'b0001 :
                           (inst_sb & ex_result[1:0] == 2'b01) ? 4'b0010 :
                           (inst_sb & ex_result[1:0] == 2'b10) ? 4'b0100 :
                           (inst_sb & ex_result[1:0] == 2'b11) ? 4'b1000 :
                           (inst_sh & ex_result[1:0] == 2'b00) ? 4'b0011 :
                           (inst_sh & ex_result[1:0] == 2'b10) ? 4'b1100 : 
                           inst_sw ? 4'b1111 : 4'b0; //mem wen


    assign data_sram_addr = alu_result ; //
    assign data_sram_wdata = data_sram_wen == 4'b1000 ? {rf_rdata2[7:0], rf_rdata2[7:0], rf_rdata2[7:0], rf_rdata2[7:0]} :
                             data_sram_wen == 4'b0100 ? {rf_rdata2[7:0], rf_rdata2[7:0], rf_rdata2[7:0], rf_rdata2[7:0]} : 
                             data_sram_wen == 4'b0010 ? {rf_rdata2[7:0], rf_rdata2[7:0], rf_rdata2[7:0], rf_rdata2[7:0]} :
                             data_sram_wen == 4'b0001 ? {rf_rdata2[7:0], rf_rdata2[7:0], rf_rdata2[7:0], rf_rdata2[7:0]} :
                             data_sram_wen == 4'b1100 ? {rf_rdata2[15:0], rf_rdata2[15:0]} :
                             data_sram_wen == 4'b0011 ? {rf_rdata2[15:0], rf_rdata2[15:0]} : rf_rdata2; //store data  

    
    assign ex_to_mem_bus = {
        ex_pc,          // 75:44
        data_ram_en,    // 43
        data_ram_wen,   // 42:39
        sel_rf_res,     // 38
        rf_we,          // 37
        rf_waddr,       // 36:32
        ex_result       // 31:0
    };

    // MUL part
    wire [63:0] mul_result;
    wire mul_signed; // 有符号乘法标记
    
    
    mul u_mul(
    	.clk        (clk            ),
        .resetn     (~rst           ),
        .mul_signed (inst_mult     ),
        .ina        (rf_rdata1      ), // 乘法源操作数1
        .inb        (rf_rdata2      ), // 乘法源操作数2
        .result     (mul_result     ) // 乘法结果 64bit
    );

    // DIV part
    wire [63:0] div_result;
    wire div_ready_i;
    reg stallreq_for_div;
    
    assign stallreq_for_ex = stallreq_for_div;

    reg [31:0] div_opdata1_o;
    reg [31:0] div_opdata2_o;
    reg div_start_o;
    reg signed_div_o;

    div u_div(
    	.rst          (rst          ),
        .clk          (clk          ),
        .signed_div_i (signed_div_o ),
        .opdata1_i    (div_opdata1_o    ),
        .opdata2_i    (div_opdata2_o    ),
        .start_i      (div_start_o      ),
        .annul_i      (1'b0      ),
        .result_o     (div_result     ), // 除法结果 64bit
        .ready_o      (div_ready_i      )
    );

    always @ (*) begin
        if (rst) begin
            stallreq_for_div = `NoStop;
            div_opdata1_o = `ZeroWord;
            div_opdata2_o = `ZeroWord;
            div_start_o = `DivStop;
            signed_div_o = 1'b0;
        end
        else begin
            stallreq_for_div = `NoStop;
            div_opdata1_o = `ZeroWord;
            div_opdata2_o = `ZeroWord;
            div_start_o = `DivStop;
            signed_div_o = 1'b0;
            case ({inst_div,inst_divu})
                2'b10:begin
                    if (div_ready_i == `DivResultNotReady) begin
                        div_opdata1_o = rf_rdata1;
                        div_opdata2_o = rf_rdata2;
                        div_start_o = `DivStart;
                        signed_div_o = 1'b1;
                        stallreq_for_div = `Stop;
                    end
                    else if (div_ready_i == `DivResultReady) begin
                        div_opdata1_o = rf_rdata1;
                        div_opdata2_o = rf_rdata2;
                        div_start_o = `DivStop;
                        signed_div_o = 1'b1;
                        stallreq_for_div = `NoStop;
                    end
                    else begin
                        div_opdata1_o = `ZeroWord;
                        div_opdata2_o = `ZeroWord;
                        div_start_o = `DivStop;
                        signed_div_o = 1'b0;
                        stallreq_for_div = `NoStop;
                    end
                end
                2'b01:begin
                    if (div_ready_i == `DivResultNotReady) begin
                        div_opdata1_o = rf_rdata1;
                        div_opdata2_o = rf_rdata2;
                        div_start_o = `DivStart;
                        signed_div_o = 1'b0;
                        stallreq_for_div = `Stop;
                    end
                    else if (div_ready_i == `DivResultReady) begin
                        div_opdata1_o = rf_rdata1;
                        div_opdata2_o = rf_rdata2;
                        div_start_o = `DivStop;
                        signed_div_o = 1'b0;
                        stallreq_for_div = `NoStop;
                    end
                    else begin
                        div_opdata1_o = `ZeroWord;
                        div_opdata2_o = `ZeroWord;
                        div_start_o = `DivStop;
                        signed_div_o = 1'b0;
                        stallreq_for_div = `NoStop;
                    end
                end
                default:begin
                end
            endcase
        end
    end
    
    assign hi_rf_wdata = inst_mthi ? rf_rdata1 :
                         inst_div | inst_divu ? div_result[63:32] :
                         inst_mult | inst_multu ? mul_result[63:32] : 32'b0;
    assign lo_rf_wdata = inst_mtlo ? rf_rdata1 : 
                         inst_div | inst_divu ? div_result[31:0] : 
                         inst_mult | inst_multu ? mul_result[31:0] : 32'b0;
                         
    assign hilo_ex_to_mem_bus ={
        hi_rf_wdata,            // 65:34
        lo_rf_wdata,           // 33:2
        hi_rf_we,              
        lo_rf_we
        
    };
    // mul_result 和 div_result 可以直接使用
    assign ex_wreg=rf_we;
    assign ex_waddr=rf_waddr;
    assign ex_wdata=ex_result;
    assign ex_hi_we=hi_rf_we;
    assign ex_lo_we=lo_rf_we;
    assign ex_hi_wdata=hi_rf_wdata;
    assign ex_lo_wdata=lo_rf_wdata;


    

    
endmodule