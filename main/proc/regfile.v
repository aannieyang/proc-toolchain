module regfile (
	clock,
	ctrl_writeEnable, ctrl_reset, ctrl_writeReg,
	ctrl_readRegA, ctrl_readRegB, data_writeReg,
	data_readRegA, data_readRegB
);

	input clock, ctrl_writeEnable, ctrl_reset;
	input [4:0] ctrl_writeReg, ctrl_readRegA, ctrl_readRegB;
	input [31:0] data_writeReg;

	output [31:0] data_readRegA, data_readRegB;

	wire [31:0] out_regA, out_regB, writeEna;

	// get register numbers to read
	// out,select,enable
	decoder dec1(out_regA, ctrl_readRegA, 1'b1);
	decoder dec2(out_regB, ctrl_readRegB, 1'b1);

	// get register number to write
	decoder dec3(writeEna, ctrl_writeReg, ctrl_writeEnable);
	
	wire [31:0] w0,w1,w2,w3,w4,w5,w6,w7,w8,w9,w10,w11,w12,w13,w14,w15,w16,w17,w18,w19,w20,w21,w22,w23,w24,w25,w26,w27,w28,w29,w30,w31;
	
	//clk, writeEnable, reset, writeIn, readOut
	register reg0(clock, 1'b0, ctrl_reset, data_writeReg, w0);
	tri_buff tristate01(32'b0,out_regA[0],data_readRegA);
	tri_buff tristate02(32'b0,out_regB[0],data_readRegB);
	register reg1(clock, writeEna[1], ctrl_reset, data_writeReg, w1);
	tri_buff tristate11(w1,out_regA[1],data_readRegA);
	tri_buff tristate12(w1,out_regB[1],data_readRegB);
	register reg2(clock, writeEna[2], ctrl_reset, data_writeReg, w2);
	tri_buff tristate21(w2,out_regA[2],data_readRegA);
	tri_buff tristate22(w2,out_regB[2],data_readRegB);
	register reg3(clock, writeEna[3], ctrl_reset, data_writeReg, w3);
	tri_buff tristate31(w3,out_regA[3],data_readRegA);
	tri_buff tristate32(w3,out_regB[3],data_readRegB);
	register reg4(clock, writeEna[4], ctrl_reset, data_writeReg, w4);
	tri_buff tristate41(w4,out_regA[4],data_readRegA);
	tri_buff tristate42(w4,out_regB[4],data_readRegB);
	register reg5(clock, writeEna[5], ctrl_reset, data_writeReg, w5);
	tri_buff tristate51(w5,out_regA[5],data_readRegA);
	tri_buff tristate52(w5,out_regB[5],data_readRegB);
	register reg6(clock, writeEna[6], ctrl_reset, data_writeReg, w6);
	tri_buff tristate61(w6,out_regA[6],data_readRegA);
	tri_buff tristate62(w6,out_regB[6],data_readRegB);
	register reg7(clock, writeEna[7], ctrl_reset, data_writeReg, w7);
	tri_buff tristate71(w7,out_regA[7],data_readRegA);
	tri_buff tristate72(w7,out_regB[7],data_readRegB);
	register reg8(clock, writeEna[8], ctrl_reset, data_writeReg, w8);
	tri_buff tristate81(w8,out_regA[8],data_readRegA);
	tri_buff tristate82(w8,out_regB[8],data_readRegB);
	register reg9(clock, writeEna[9], ctrl_reset, data_writeReg, w9);
	tri_buff tristate91(w9,out_regA[9],data_readRegA);
	tri_buff tristate92(w9,out_regB[9],data_readRegB);
	register reg10(clock, writeEna[10], ctrl_reset, data_writeReg, w10);
	tri_buff tristate101(w10,out_regA[10],data_readRegA);
	tri_buff tristate102(w10,out_regB[10],data_readRegB);
	register reg11(clock, writeEna[11], ctrl_reset, data_writeReg, w11);
	tri_buff tristate111(w11,out_regA[11],data_readRegA);
	tri_buff tristate112(w11,out_regB[11],data_readRegB);
	register reg12(clock, writeEna[12], ctrl_reset, data_writeReg, w12);
	tri_buff tristate121(w12,out_regA[12],data_readRegA);
	tri_buff tristate122(w12,out_regB[12],data_readRegB);
	register reg13(clock, writeEna[13], ctrl_reset, data_writeReg, w13);
	tri_buff tristate131(w13,out_regA[13],data_readRegA);
	tri_buff tristate132(w13,out_regB[13],data_readRegB);
	register reg14(clock, writeEna[14], ctrl_reset, data_writeReg, w14);
	tri_buff tristate141(w14,out_regA[14],data_readRegA);
	tri_buff tristate142(w14,out_regB[14],data_readRegB);
	register reg15(clock, writeEna[15], ctrl_reset, data_writeReg, w15);
	tri_buff tristate151(w15,out_regA[15],data_readRegA);
	tri_buff tristate152(w15,out_regB[15],data_readRegB);
	register reg16(clock, writeEna[16], ctrl_reset, data_writeReg, w16);
	tri_buff tristate161(w16,out_regA[16],data_readRegA);
	tri_buff tristate162(w16,out_regB[16],data_readRegB);
	register reg17(clock, writeEna[17], ctrl_reset, data_writeReg, w17);
	tri_buff tristate171(w17,out_regA[17],data_readRegA);
	tri_buff tristate172(w17,out_regB[17],data_readRegB);
	register reg18(clock, writeEna[18], ctrl_reset, data_writeReg, w18);
	tri_buff tristate181(w18,out_regA[18],data_readRegA);
	tri_buff tristate182(w18,out_regB[18],data_readRegB);
	register reg19(clock, writeEna[19], ctrl_reset, data_writeReg, w19);
	tri_buff tristate191(w19,out_regA[19],data_readRegA);
	tri_buff tristate192(w19,out_regB[19],data_readRegB);
	register reg20(clock, writeEna[20], ctrl_reset, data_writeReg, w20);
	tri_buff tristate201(w20,out_regA[20],data_readRegA);
	tri_buff tristate202(w20,out_regB[20],data_readRegB);
	register reg21(clock, writeEna[21], ctrl_reset, data_writeReg, w21);
	tri_buff tristate211(w21,out_regA[21],data_readRegA);
	tri_buff tristate212(w21,out_regB[21],data_readRegB);
	register reg22(clock, writeEna[22], ctrl_reset, data_writeReg, w22);
	tri_buff tristate221(w22,out_regA[22],data_readRegA);
	tri_buff tristate222(w22,out_regB[22],data_readRegB);
	register reg23(clock, writeEna[23], ctrl_reset, data_writeReg, w23);
	tri_buff tristate231(w23,out_regA[23],data_readRegA);
	tri_buff tristate232(w23,out_regB[23],data_readRegB);
	register reg24(clock, writeEna[24], ctrl_reset, data_writeReg, w24);
	tri_buff tristate241(w24,out_regA[24],data_readRegA);
	tri_buff tristate242(w24,out_regB[24],data_readRegB);
	register reg25(clock, writeEna[25], ctrl_reset, data_writeReg, w25);
	tri_buff tristate251(w25,out_regA[25],data_readRegA);
	tri_buff tristate252(w25,out_regB[25],data_readRegB);
	register reg26(clock, writeEna[26], ctrl_reset, data_writeReg, w26);
	tri_buff tristate261(w26,out_regA[26],data_readRegA);
	tri_buff tristate262(w26,out_regB[26],data_readRegB);
	register reg27(clock, writeEna[27], ctrl_reset, data_writeReg, w27);
	tri_buff tristate271(w27,out_regA[27],data_readRegA);
	tri_buff tristate272(w27,out_regB[27],data_readRegB);
	register reg28(clock, writeEna[28], ctrl_reset, data_writeReg, w28);
	tri_buff tristate281(w28,out_regA[28],data_readRegA);
	tri_buff tristate282(w28,out_regB[28],data_readRegB);
	register reg29(clock, writeEna[29], ctrl_reset, data_writeReg, w29);
	tri_buff tristate291(w29,out_regA[29],data_readRegA);
	tri_buff tristate292(w29,out_regB[29],data_readRegB);
	register reg30(clock, writeEna[30], ctrl_reset, data_writeReg, w30);
	tri_buff tristate301(w30,out_regA[30],data_readRegA);
	tri_buff tristate302(w30,out_regB[30],data_readRegB);
	register reg31(clock, writeEna[31], ctrl_reset, data_writeReg, w31);
	tri_buff tristate311(w31,out_regA[31],data_readRegA);
	tri_buff tristate312(w31,out_regB[31],data_readRegB);

endmodule
