module div(dividend, divisor, clk, result, count, overflow);
    input [31:0] dividend, divisor;
    input [5:0] count;
    input clk;
    output [31:0] result;
    output overflow;

    wire negDividend, negDivisor, w1, w2, w3, w4,w5,w6,w7,w8;

    assign negDividend = dividend[31];
    assign negDivisor = divisor[31];

    wire [31:0] useDivisor, useDividend, finDivisor, finDividend;
    assign finDivisor = negDivisor ? ~divisor : divisor;
    cla d1(finDivisor,32'b0,negDivisor,useDivisor,w1,w2);
    assign finDividend = negDividend ? ~dividend : dividend;
    cla d2(finDividend,32'b0,negDividend,useDividend,w3,w4);

    wire [63:0] start, quotient, currQuo, storedQuo, shift;
    assign start[31:0] = useDividend;
    assign start[63:32] = 32'b0;

    // if count = 0, start with product
    // else, use the current product >>> 1
    assign quotient = (~count[5]&~count[4] & ~count[3] & ~count[2] & ~count[1] & ~count[0]) ? start : currQuo;
 
    // (clk, writeEnable, reset, writeIn, readOut)
    register63 reg63(clk, 1'b1, 1'b0, quotient, storedQuo);

    assign shift = storedQuo <<1;

    wire [31:0] neg = ~useDivisor;

    wire throwaway1, throwaway2;
    wire [31:0] A,sum,B,lastQuotient;

    assign B = storedQuo[63] ? useDivisor : neg;

    assign A = shift[63:32];
    // A,B,Cin,S,prevCout,Cout
    cla addorsub(A,B,~storedQuo[63],sum,throwaway1,throwaway2);
    cla last(sum,useDivisor,1'b0,lastQuotient,w7,w8);

    assign currQuo[63:32] = (sum[31]&~count[5]&count[4]&count[3]&count[2]&count[1]&count[0])? lastQuotient:sum;
    //assign currQuo[63:32] = (sum[31]&count[5]&~count[4]&~count[3]&~count[2]&~count[1]&~count[0])? lastQuotient:sum;

    assign currQuo[31:1] = shift[31:1];

    // if MSB=1 and n=0
    assign currQuo[0] = ~sum[31];

    wire negate;

    wire [31:0] finQuotient, checkoverflow;

    xor (negate, negDividend, negDivisor);
    assign finQuotient = negate ? ~currQuo : currQuo;
    cla d3(finQuotient,32'b0,negate,checkoverflow,w5,w6);

    wire divzero, divisorneg1, maxnegdividend;

    assign divzero = ~divisor[0]&~divisor[1]&~divisor[2]&~divisor[3]&~divisor[4]&~divisor[5]&~divisor[6]&~divisor[7]&~divisor[8]&~divisor[9]&~divisor[10]&~divisor[11]&~divisor[12]&~divisor[13]&~divisor[14]&~divisor[15]&~divisor[16]&~divisor[17]&~divisor[18]&~divisor[19]&~divisor[20]&~divisor[21]&~divisor[22]&~divisor[23]&~divisor[24]&~divisor[25]&~divisor[26]&~divisor[27]&~divisor[28]&~divisor[29]&~divisor[30]&~divisor[31];
    assign divisorneg1 = divisor[0]&divisor[1]&divisor[2]&divisor[3]&divisor[4]&divisor[5]&divisor[6]&divisor[7]&divisor[8]&divisor[9]&divisor[10]&divisor[11]&divisor[12]&divisor[13]&divisor[14]&divisor[15]&divisor[16]&divisor[17]&divisor[18]&divisor[19]&divisor[20]&divisor[21]&divisor[22]&divisor[23]&divisor[24]&divisor[25]&divisor[26]&divisor[27]&divisor[28]&divisor[29]&divisor[30]&divisor[31];
    assign maxnegdividend = ~dividend[0]&~dividend[1]&~dividend[2]&~dividend[3]&~dividend[4]&~dividend[5]&~dividend[6]&~dividend[7]&~dividend[8]&~dividend[9]&~dividend[10]&~dividend[11]&~dividend[12]&~dividend[13]&~dividend[14]&~dividend[15]&~dividend[16]&~dividend[17]&~dividend[18]&~dividend[19]&~dividend[20]&~dividend[21]&~dividend[22]&~dividend[23]&~dividend[24]&~dividend[25]&~dividend[26]&~dividend[27]&~dividend[28]&~dividend[29]&~dividend[30]&dividend[31];

    assign overflow = divzero ? 1'b1 : (divisorneg1&maxnegdividend) ? 1'b1 : 1'b0;
    assign result = overflow ? 32'b0 : checkoverflow;
    //assign result = currQuo;

endmodule