module mult(multiplicand, multiplier, clk, result, count, overflow);
    input [31:0] multiplicand, multiplier;
    input [5:0] count;
    input clk;
    output [31:0] result;
    output overflow;

    wire signed [64:0] start, product, currProd, storedProd, check;
    assign start[0] = 1'b0;
    assign start[32:1] = multiplier;
    assign start[64:33] = 32'b0;

    // if count = 0, start with product
    // else, use the current product >>> 1
    assign check[63:0] = currProd[64:1];
    assign check[64] = check[63];
    assign product = (~count[5]&~count[4] & ~count[3] & ~count[2] & ~count[1] & ~count[0]) ? start : check;
 
    // (clk, writeEnable, reset, writeIn, readOut)
    register64 reg64(clk, 1'b1, 1'b0, product, storedProd);
    
    wire [31:0] neg = ~multiplicand;
    wire [31:0] nothing = 32'b0;

    wire [1:0] control;
    assign control = storedProd[1:0];

    wire [31:0] op,in,sum;

    // mux_4(out, select, in0, in1, in2, in3);
    mux_4 muxop(op, control, nothing, multiplicand, neg, nothing);

    wire throwaway1, throwaway2, sub;

    assign sub = (control[1]&~control[0]) ? 1'b1 : 1'b0;

    assign in = storedProd[64:33];
    // A,B,Cin,S,prevCout,Cout
    cla addorsub(in,op,sub,sum,throwaway1,throwaway2);
    assign currProd[64:33] = sum;

    assign currProd[32:0] = storedProd[32:0];

    assign result = storedProd[32:1];
    // assign result = storedProd>>>1;

    wire allzero, resultov;

    assign allzero = ((~multiplicand[0]&~multiplicand[1]&~multiplicand[2]&~multiplicand[3]&~multiplicand[4]&~multiplicand[5]&~multiplicand[6]&~multiplicand[7]&~multiplicand[8]&~multiplicand[9]&~multiplicand[10]&~multiplicand[11]&~multiplicand[12]&~multiplicand[13]&~multiplicand[14]&~multiplicand[15]&~multiplicand[16]&~multiplicand[17]&~multiplicand[18]&~multiplicand[19]&~multiplicand[20]&~multiplicand[21]&~multiplicand[22]&~multiplicand[23]&~multiplicand[24]&~multiplicand[25]&~multiplicand[26]&~multiplicand[27]&~multiplicand[28]&~multiplicand[29]&~multiplicand[30]&~multiplicand[31])|(~multiplier[0]&~multiplier[1]&~multiplier[2]&~multiplier[3]&~multiplier[4]&~multiplier[5]&~multiplier[6]&~multiplier[7]&~multiplier[8]&~multiplier[9]&~multiplier[10]&~multiplier[11]&~multiplier[12]&~multiplier[13]&~multiplier[14]&~multiplier[15]&~multiplier[16]&~multiplier[17]&~multiplier[18]&~multiplier[19]&~multiplier[20]&~multiplier[21]&~multiplier[22]&~multiplier[23]&~multiplier[24]&~multiplier[25]&~multiplier[26]&~multiplier[27]&~multiplier[28]&~multiplier[29]&~multiplier[30]&~multiplier[31]))?1'b1:1'b0;

    assign resultov = ((~storedProd[32]&~storedProd[33]&~storedProd[34]&~storedProd[35]&~storedProd[36]&~storedProd[37]&~storedProd[38]&~storedProd[39]&~storedProd[40]&~storedProd[41]&~storedProd[42]&~storedProd[43]&~storedProd[44]&~storedProd[45]&~storedProd[46]&~storedProd[47]&~storedProd[48]&~storedProd[49]&~storedProd[50]&~storedProd[51]&~storedProd[52]&~storedProd[53]&~storedProd[54]&~storedProd[55]&~storedProd[56]&~storedProd[57]&~storedProd[58]&~storedProd[59]&~storedProd[60]&~storedProd[61]&~storedProd[62]&~storedProd[63]&~storedProd[64])|(storedProd[32]&storedProd[33]&storedProd[34]&storedProd[35]&storedProd[36]&storedProd[37]&storedProd[38]&storedProd[39]&storedProd[40]&storedProd[41]&storedProd[42]&storedProd[43]&storedProd[44]&storedProd[45]&storedProd[46]&storedProd[47]&storedProd[48]&storedProd[49]&storedProd[50]&storedProd[51]&storedProd[52]&storedProd[53]&storedProd[54]&storedProd[55]&storedProd[56]&storedProd[57]&storedProd[58]&storedProd[59]&storedProd[60]&storedProd[61]&storedProd[62]&storedProd[63]&storedProd[64]))?1'b1:1'b0;

    assign overflow = ((multiplicand[31]^multiplier[31])&~result[31]&~allzero)?1'b1:
    (~(multiplicand[31]^multiplier[31])&result[31])?1'b1:~resultov;
    // if multiplicand xor multiplier is negative but ans is positive UNLESS one is 0
    // if multiplicand and multipler are both positive/negative but ans is negative
    // if result is too big (takes more than 32 bits)

endmodule