/**
 * READ THIS DESCRIPTION!
 *
 * This is your processor module that will contain the bulk of your code submission. You are to implement
 * a 5-stage pipelined processor in this module, accounting for hazards and implementing bypasses as
 * necessary.
 *
 * Ultimately, your processor will be tested by a master skeleton, so the
 * testbench can see which controls signal you active when. Therefore, there needs to be a way to
 * "inject" imem, dmem, and regfile interfaces from some external controller module. The skeleton
 * file, Wrapper.v, acts as a small wrapper around your processor for this purpose. Refer to Wrapper.v
 * for more details.
 *
 * As a result, this module will NOT contain the RegFile nor the memory modules. Study the inputs 
 * very carefully - the RegFile-related I/Os are merely signals to be sent to the RegFile instantiated
 * in your Wrapper module. This is the same for your memory elements. 
 *
 *
 */
module temp(
    // Control signals
    clock,                          // I: The master clock
    reset,                          // I: A reset signal

    // Imem
    address_imem,                   // O: The address of the data to get from imem
    q_imem,                         // I: The data from imem

    // Dmem
    address_dmem,                   // O: The address of the data to get or put from/to dmem
    data,                           // O: The data to write to dmem
    wren,                           // O: Write enable for dmem
    q_dmem,                         // I: The data from dmem

    // Regfile
    ctrl_writeEnable,               // O: Write enable for RegFile
    ctrl_writeReg,                  // O: Register to write to in RegFile
    ctrl_readRegA,                  // O: Register to read from port A of RegFile
    ctrl_readRegB,                  // O: Register to read from port B of RegFile
    data_writeReg,                  // O: Data to write to for RegFile
    data_readRegA,                  // I: Data from port A of RegFile
    data_readRegB                   // I: Data from port B of RegFile
	 
	);

	// Control signals
	input clock, reset;
	
	// Imem
    output [31:0] address_imem;
	input [31:0] q_imem;

	// Dmem
	output [31:0] address_dmem, data;
	output wren;
	input [31:0] q_dmem;

	// Regfile
	output ctrl_writeEnable;
	output [4:0] ctrl_writeReg, ctrl_readRegA, ctrl_readRegB;
	output [31:0] data_writeReg;
	input [31:0] data_readRegA, data_readRegB;

	/* YOUR CODE STARTS HERE */

    wire [31:0] curr_pc, next_pc, n, t, branchedbne, branchedblt, blt, bne, dx_bne, dx_blt, dx_bex, tempaddress, dxpc_out;
    wire w4,w5,w6,w7,w8,w9,w10,w11, stall, taken, jump, branch, isNotEqual, isLessThan, new_stall;

    //assign new_stall = 

    assign bne = isNotEqual ? n : 32'b0;
    assign blt = (~isLessThan&isNotEqual) ? n : 32'b0;

    cla branch_add(dxpc_out, bne, 1'b0, branchedbne, w8,w9);
    cla branch_add2(dxpc_out, blt, 1'b0, branchedblt, w10,w11);

    assign tempaddress = jump ? t : (dx_bne ? branchedbne : (dx_blt ? branchedblt : (dx_bex ? t : next_pc)));

    assign address_imem = curr_pc;
    assign taken = (dx_bne&isNotEqual) | (dx_blt&~isLessThan&isNotEqual) | jump | dx_bex;
    //assign taken = 1'b0;
    register pc(.clk(~clock), .writeEnable(~stall), .reset(reset), .writeIn(tempaddress), .readOut(curr_pc));

    cla pc_add(curr_pc, 32'b1, 1'b0, next_pc, w4,w5);

    // ================== FETCH ==================
    // read instruction from imem
    wire [31:0] fdinsn_out, fdpc_out;
    fd_latch fd(~clock, ~stall, reset, next_pc, fdpc_out, taken ? 32'b0 : q_imem, fdinsn_out);

    // ================== DECODE ==================
    // Use $rstatus (r30)
    wire fd_bex, fd_sw, fd_jr, fd_branch, fd_bne, fd_blt;
    wire [4:0] fd_opcode;
    assign fd_opcode = fdinsn_out[31:27];
    assign fd_bex = (fd_opcode==5'b10110);
    assign fd_sw = (fd_opcode==5'b00111);
    assign fd_jr = (fd_opcode==5'b00100);
    assign fd_bne = (fd_opcode==5'b00010);
    assign fd_blt = (fd_opcode==5'b00110);
    assign fd_branch =  fd_bne | fd_blt;

    // Decode RS, RT registers
    assign ctrl_readRegA = fdinsn_out[21:17];
    assign ctrl_readRegB = fd_bex ? 5'd30 : ((fd_sw | fd_jr | fd_branch) ? fdinsn_out[26:22] : fdinsn_out[16:12]);

    // regA = $rs
    // Latch data from RS    
    // regB = $rt
    // Latch data from RT
    wire [31:0] dxa_out, dxb_out, dxinsn_out, dxinsn_in;
    assign dxinsn_in = stall ? 32'b0 : fdinsn_out;

    // do i have to flush here???
    dx_latch dx(~clock, ~stall, reset, fdpc_out, dxpc_out, taken ? 32'b0 : dxinsn_in, dxinsn_out, data_readRegA, dxa_out, data_readRegB, dxb_out);

    // ================== EXECUTE ==================

    wire [31:0] alu_out, new_pc, tempt, operandB, xmb_in, xmo_in; 
    wire [4:0] alu_op, opcode, alu_opcode, shamt;
    
    assign alu_op = dxinsn_out[6:2];
    assign alu_opcode = (opcode==5'b00101)?5'b00000:alu_op;
    assign opcode = dxinsn_out[31:27];
    assign shamt = dxinsn_out[11:7];
    assign tempt[26:0] = dxinsn_out[26:0];
    assign tempt[31:27] = 5'b0;

    assign dx_bne = (opcode==5'b00010);
    assign dx_blt = (opcode==5'b00110);

    // Sign extending immediate (N)
    wire signed [31:0] temp;
    assign temp[31:15] = dxinsn_out[16:0];
    assign n = temp >>> 15;

    // bex and setx
    wire dx_setx, dx_jr, dx_add, dx_addi, dx_sub, dx_multdiv, dx_lw;
    assign dx_bex = (opcode==5'b10110) & dxb_out!=31'b0;
    assign dx_setx = (opcode==5'b10101);
    assign dx_add = (opcode==5'b00000) & (alu_op==5'b00000);
    assign dx_addi = (opcode==5'b00101);
    assign dx_sub = (opcode==5'b00000) & (alu_op==5'b00001);
    assign dx_lw = opcode==5'b01000;

    assign jump = (opcode==5'b00011) | (opcode==5'b00001) | (opcode==5'b00100);
    assign branch = (opcode==5'b00010) | (opcode==5'b00110);
    assign dx_jr = (opcode==5'b00100);
    assign t = dx_jr ? dxb_out : tempt;

    wire alu_overflow;
    wire [31:0] alu_res, dxa_out_bypass, dxb_out_bypass, xmo_out;
    wire [1:0] alu_bypass_select, aluinb_bypass_select;

    // if rd in xm == rs [21:17] in dx: mx bypass (01)
    // if rd in mw == rs [21:17] in dx: wx bypass (10)
    // else dxa (00)

    assign alu_bypass_select[0] = xminsn_out[26:22] == dxinsn_out[21:17] & ~branch;
    assign alu_bypass_select[1] = ctrl_writeReg == dxinsn_out[21:17] & ~branch;
    mux_4 alu_mux(dxa_out_bypass, alu_bypass_select, dxa_out, xmo_out, data_writeReg, 32'b0);

    // if rd in xm == rt [16:12] in dx: mx bypass (01)
    // if rd in mw == rt [16:12] in dx: wx bypass (10)
    // else dxb (00)

    assign aluinb_bypass_select[0] = xminsn_out[26:22] == dxinsn_out[16:12] & ~branch;
    assign aluinb_bypass_select[1] = ctrl_writeReg == dxinsn_out[16:12] & ~branch;

    mux_4 aluinb_mux(dxb_out_bypass, aluinb_bypass_select, dxb_out, xmo_out, data_writeReg, 32'b0);

    // Immediate or regB
    wire ALUinB;
    //IF ADDI, CHANGE THIS FOR THE FUTURE
    assign ALUinB = (opcode==5'b00101)||(opcode==5'b00111)||(opcode==5'b01000);
    assign operandB = ALUinB ? n : dxb_out_bypass;

    // Use ALU to compute result

    alu ALU(.data_operandA(dxa_out_bypass), .data_operandB(operandB), .ctrl_ALUopcode(alu_opcode), .ctrl_shiftamt(shamt), .data_result(alu_res), .isNotEqual(isNotEqual), .isLessThan(isLessThan), .overflow(alu_overflow)); 

    assign alu_out = (alu_overflow & dx_add) ? 32'd1 :
                    (alu_overflow & dx_addi) ? 32'd2 :
                    (alu_overflow & dx_sub) ? 32'd3 :
                    alu_res;

    // Multdiv
    wire dx_mult, dx_div, multdiv_exception, multdiv_resultRDY, mult_running, div_running, running, ctrl_MULT, ctrl_DIV;
    wire [31:0] multdiv_result, multdivinsn_out, multdiv_a, multdiv_b, multdiv_res;
    assign dx_mult = (opcode==5'b0) & (alu_opcode==5'b00110);
    assign dx_div = (opcode==5'b0) & (alu_opcode==5'b00111);

    //(q, d, clk, en, clr);
    dffe_ref mult(.clk(~clock), .clr(reset), .en(1'b1), .d(dx_mult & ~multdiv_resultRDY), .q(mult_running));
    dffe_ref div(.clk(~clock), .clr(reset), .en(1'b1), .d(dx_div & ~multdiv_resultRDY), .q(div_running));
    assign running = mult_running | div_running;

    assign ctrl_MULT = dx_mult & ~mult_running;
    assign ctrl_DIV = dx_div & ~div_running;
    
    multdiv multdivop(.data_operandA(dxa_out_bypass), .data_operandB(operandB), .ctrl_MULT(ctrl_MULT), .ctrl_DIV(ctrl_DIV), .clock(clock), .data_result(multdiv_res), .data_exception(multdiv_exception), .data_resultRDY(multdiv_resultRDY));
    
    wire rstatus;

    assign rstatus = (alu_overflow&(opcode==5'b0|opcode==5'b00101)) | (multdiv_exception&multdiv_resultRDY);
    assign multdiv_result = rstatus&dx_mult ? 32'd4 : (rstatus&dx_div ? 32'd5 : multdiv_res);

    
    // if setx, use immediate (T), otherwise normal regB
    assign xmb_in = dx_setx ? t : dxb_out;

    // jal => $31 = PC+1
    assign xmo_in = (opcode==5'b00011) ? dxpc_out :
                    dx_setx ? t :
                    multdiv_resultRDY ? multdiv_result : 
                    alu_out;

    wire [31:0] xmb_out, xminsn_out, xminsn_in;

    assign xminsn_in[31:27] = dxinsn_out[31:27];
    assign xminsn_in[21:0] = dxinsn_out[21:0];
    assign xminsn_in[26:22] = rstatus ? 5'd30 : dxinsn_out[26:22];

    xm_latch xm(~clock, ~stall, reset, xminsn_in, xminsn_out, xmo_in, xmo_out, xmb_in, xmb_out);

    // ================== MEMORY ==================

    // Save word
    wire [4:0] xm_opcode = xminsn_out[31:27];
    wire xm_sw, data_bypass;
    assign xm_sw = (xm_opcode==5'b00111);

    assign address_dmem = xmo_out;
    assign wren = xm_sw;

    // wm bypassing
    // sw rd = lw rd
    assign data_bypass = ctrl_writeReg == xminsn_out[26:22] & xm_sw & mw_lw;
    assign data = data_bypass ? data_writeReg : xmb_out;

    // Latch instruction
    wire [31:0] mwinsn_out, mwo_out, mwd_out;
    mw_latch mw(~clock, ~stall, reset, xminsn_out, mwinsn_out, xmo_out, mwo_out, q_dmem, mwd_out);

    // ================== WRITEBACK ==================

    wire [4:0] mw_opcode, rd;
    assign mw_opcode = mwinsn_out[31:27];
    wire mw_sw, mw_lw, mw_insnWE, mw_addi, mw_setx, mw_jal;
    assign mw_sw = (mw_opcode==5'b00111);
    assign mw_lw = (mw_opcode==5'b01000);
    assign mw_insnWE = (mw_opcode==5'b00000);
    assign mw_addi = (mw_opcode==5'b00101);
    assign mw_setx = (mw_opcode==5'b10101);
    assign mw_jal = (mw_opcode==5'b00011);
    assign rd = mwinsn_out[26:22];
    
    // Set destination register and data to write
    assign ctrl_writeReg = mw_jal ? 5'd31 :
                            mw_setx ? 5'd30 :
                            rd;

    assign data_writeReg = mw_lw ? q_dmem : mwo_out;

    // Set write enable
    assign ctrl_writeEnable = mw_insnWE | mw_lw | mw_setx | mw_addi | mw_jal;

    // temporarily until i do branching

    assign stall = (~multdiv_resultRDY & (dx_mult | dx_div)) | dx_lw & ((fdinsn_out[21:17]==dxinsn_out[26:22]) | ((fdinsn_out[16:12]==dxinsn_out[26:22]) & ~fd_sw));
    
	/* END CODE */

endmodule

