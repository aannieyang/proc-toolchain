module left_shift(A,S,amt);
    input [31:0] A;
    input [4:0] amt;
    output [31:0] S;

    wire [31:0] shift0, res0;
    barrel_16 lshift16(A,shift0);
    assign res0 = amt[4] ? shift0 : A;
    
    wire [31:0] shift1, res1;
    barrel_8 lshift8(res0,shift1);
    assign res1 = amt[3] ? shift1 : res0;

    wire [31:0] shift2, res2;
    barrel_4 lshift4(res1,shift2);
    assign res2 = amt[2] ? shift2 : res1;

    wire [31:0] shift3, res3;
    barrel_2 lshift2(res2,shift3);
    assign res3 = amt[1] ? shift3 : res2;

    wire [31:0] shift4;
    barrel_1 lshift1(res3,shift4);
    assign S = amt[0] ? shift4 : res3;
endmodule