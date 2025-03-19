module alu(data_operandA, data_operandB, ctrl_ALUopcode, ctrl_shiftamt, data_result, isNotEqual, isLessThan, overflow);
        
    input [31:0] data_operandA, data_operandB;
    input [4:0] ctrl_ALUopcode, ctrl_shiftamt;

    output [31:0] data_result;
    output isNotEqual, isLessThan, overflow;
    
    // add your code here:
    wire [2:0] opcode;
    assign opcode = ctrl_ALUopcode[2:0];

    wire addorsub;
    assign addorsub = ctrl_ALUopcode[0];

    wire [191:0] w;

    wire [31:0] notB;
    bit_not subB(data_operandB,notB);

    wire [1:0] prevCout, Cout;

    cla adder(data_operandA,data_operandB,1'b0,w[31:0],prevCout[0],Cout[0]);
    cla sub(data_operandA,notB,1'b1,w[63:32],prevCout[1],Cout[1]);
    bit_and andAB(data_operandA,data_operandB,w[95:64]);
    bit_or orAB(data_operandA,data_operandB,w[127:96]);

    left_shift sll(data_operandA,w[159:128],ctrl_shiftamt);
    right_shift sra(data_operandA,w[191:160],ctrl_shiftamt);

    // isNotEqual
    or equal(isNotEqual,data_result[0],data_result[1],data_result[2],data_result[3],data_result[4],data_result[5],data_result[6],data_result[7],data_result[8],data_result[9],data_result[10],data_result[11],data_result[12],data_result[13],data_result[14],data_result[15],data_result[16],data_result[17],data_result[18],data_result[19],data_result[20],data_result[21],data_result[22],data_result[23],data_result[24],data_result[25],data_result[26],data_result[27],data_result[28],data_result[29],data_result[30],data_result[31]);

    // overflow
    wire [1:0] checkOverflow;
    xor add_overflow(checkOverflow[0],prevCout[0],Cout[0]);
    xor sub_overflow(checkOverflow[1],prevCout[1],Cout[1]);
    mux_2_1bit check_overflow(overflow,addorsub,checkOverflow[0],checkOverflow[1]);

    // isLessThan CHECK THIS
    wire check;
    assign check = data_result[31];
    xor (isLessThan, check, overflow);

    mux_8 op(data_result,opcode,w[31:0],w[63:32],w[95:64],w[127:96],w[159:128],w[191:160],32'b0,32'b0);

endmodule