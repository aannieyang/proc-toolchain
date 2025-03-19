module cla_block(Pin,Gin,Cin,A,B,S,Pout,Gout,Cout);
    input [7:0] A, B;
    input Pin,Gin,Cin;
    output Pout,Gout,Cout;
    output [7:0] S;

    wire [7:0] c;

    // calculating Pi
    wire [7:0] p;
    or (p[0],A[0],B[0]);
    or (p[1],A[1],B[1]);
    or (p[2],A[2],B[2]);
    or (p[3],A[3],B[3]);
    or (p[4],A[4],B[4]);
    or (p[5],A[5],B[5]);
    or (p[6],A[6],B[6]);
    or (p[7],A[7],B[7]);
    and (Pout,p[0],p[1],p[2],p[3],p[4],p[5],p[6],p[7]);

    // calculating Gi
    wire [7:0] g;
    and (g[0],A[0],B[0]);
    and (g[1],A[1],B[1]);
    and (g[2],A[2],B[2]);
    and (g[3],A[3],B[3]);
    and (g[4],A[4],B[4]);
    and (g[5],A[5],B[5]);
    and (g[6],A[6],B[6]);
    and (g[7],A[7],B[7]);

    wire [6:0] w;
    and (w[0],g[0],p[7],p[6],p[5],p[4],p[3],p[2],p[1]);
    and (w[1],g[1],p[7],p[6],p[5],p[4],p[3],p[2]);
    and (w[2],g[2],p[7],p[6],p[5],p[4],p[3]);
    and (w[3],g[3],p[7],p[6],p[5],p[4]);
    and (w[4],g[4],p[7],p[6],p[5]);
    and (w[5],g[5],p[7],p[6]);
    and (w[6],g[6],p[7]);
    or (Gout,w[0],w[1],w[2],w[3],w[4],w[5],w[6],g[7]);


    assign c[0] = Cin;

    wire w1;
    and (w1,p[0],c[0]);
    or (c[1],g[0],w1);

    wire [1:0] w2;
    and (w2[0],p[1],g[0]);
    and (w2[1],p[1],p[0],c[0]);
    or (c[2],g[1],w2[0],w2[1]);

    wire [2:0] w3;
    and (w3[0],p[2],g[1]);
    and (w3[1],p[2],p[1],g[0]);
    and (w3[2],p[2],p[1],p[0],c[0]);
    or (c[3],g[2],w3[0],w3[1],w3[2]);

    wire [3:0] w4;
    and (w4[0],p[3],g[2]);
    and (w4[1],p[3],p[2],g[1]);
    and (w4[2],p[3],p[2],p[1],g[0]);
    and (w4[3],p[3],p[2],p[1],p[0],c[0]);
    or (c[4],g[3],w4[0],w4[1],w4[2],w4[3]);

    wire [4:0] w5;
    and (w5[0],p[4],g[3]);
    and (w5[1],p[4],p[3],g[2]);
    and (w5[2],p[4],p[3],p[2],g[1]);
    and (w5[3],p[4],p[3],p[2],p[1],g[0]);
    and (w5[4],p[4],p[3],p[2],p[1],p[0],c[0]);
    or (c[5],g[4],w5[0],w5[1],w5[2],w5[3],w5[4]);

    wire [5:0] w6;
    and (w6[0],p[5],g[4]);
    and (w6[1],p[5],p[4],g[3]);
    and (w6[2],p[5],p[4],p[3],g[2]);
    and (w6[3],p[5],p[4],p[3],p[2],g[1]);
    and (w6[4],p[5],p[4],p[3],p[2],p[1],g[0]);
    and (w6[5],p[5],p[4],p[3],p[2],p[1],p[0],c[0]);
    or (c[6],g[5],w6[0],w6[1],w6[2],w6[3],w6[4],w6[5]);

    wire [6:0] w7;
    and (w7[0],p[6],g[5]);
    and (w7[1],p[6],p[5],g[4]);
    and (w7[2],p[6],p[5],p[4],g[3]);
    and (w7[3],p[6],p[5],p[4],p[3],g[2]);
    and (w7[4],p[6],p[5],p[4],p[3],p[2],g[1]);
    and (w7[5],p[6],p[5],p[4],p[3],p[2],p[1],g[0]);
    and (w7[6],p[6],p[5],p[4],p[3],p[2],p[1],p[0],c[0]);
    or (c[7],g[6],w7[0],w7[1],w7[2],w7[3],w7[4],w7[5],w7[6]);


    full_adder FA1(S[0],A[0],B[0],c[0]);
    full_adder FA2(S[1],A[1],B[1],c[1]);
    full_adder FA3(S[2],A[2],B[2],c[2]);
    full_adder FA4(S[3],A[3],B[3],c[3]);
    full_adder FA5(S[4],A[4],B[4],c[4]);
    full_adder FA6(S[5],A[5],B[5],c[5]);
    full_adder FA7(S[6],A[6],B[6],c[6]);
    full_adder FA8(S[7],A[7],B[7],c[7]);
    // use c[7] to check overflow
    assign Cout = c[7];

endmodule