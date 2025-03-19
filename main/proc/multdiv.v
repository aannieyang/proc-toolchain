module multdiv(
	data_operandA, data_operandB, 
	ctrl_MULT, ctrl_DIV, 
	clock, 
	data_result, data_exception, data_resultRDY);

    input [31:0] data_operandA, data_operandB;
    input ctrl_MULT, ctrl_DIV, clock;

    output [31:0] data_result;
    output data_exception, data_resultRDY;

    wire multiply, divide;
    // (q, d, clk, en, clr)
    dffe_ref reg1(multiply, ctrl_MULT, clock, ctrl_MULT|ctrl_DIV, 1'b0);
    dffe_ref reg2(divide, ctrl_DIV, clock, ctrl_MULT|ctrl_DIV, 1'b0);

    wire [5:0] mcount, dcount;
    // en,clk,w,reset
    counter mult(multiply, clock, mcount, ctrl_MULT);
    counter div(divide, clock, dcount, ctrl_DIV);

    wire exceptionmult, exceptiondiv, multRDY, divRDY;

    wire [31:0] multres, divres;

    //(multiplicand, multiplier, clk, result)
    mult multa(data_operandB, data_operandA, clock, multres, mcount, exceptionmult);
    div diva(data_operandA, data_operandB, clock, divres, dcount, exceptiondiv);

    assign data_exception = multiply ? exceptionmult : exceptiondiv;
    assign data_result = multiply ? multres : divres;

    //assign data_resultRDY = 1'b1;
    assign multRDY = (mcount[5]&~mcount[4]&~mcount[3]&~mcount[2]&~mcount[1]&mcount[0]) ? 1'b1 : 1'b0;
    //assign divRDY = (~dcount[5]&dcount[4]&dcount[3]&dcount[2]&dcount[1]&dcount[0]) ? 1'b1 : 1'b0;
    assign divRDY = (dcount[5]&~dcount[4]&~dcount[3]&~dcount[2]&~dcount[1]&~dcount[0]) ? 1'b1 : 1'b0;

    assign data_resultRDY = multiply ? multRDY : divRDY;
endmodule