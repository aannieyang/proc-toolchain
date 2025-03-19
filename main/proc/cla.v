module cla(A,B,Cin,S,prevCout,Cout);
    input [31:0] A, B;
    input Cin;
    output [31:0] S;
    output prevCout,Cout;

    wire [3:0] P,G;
    wire [4:0] c;
    wire [3:0] Couts;

    assign c[0] = Cin;

    //Pin,Gin,Cin,A,B,S,Pout,Gout):
    cla_block cla1(1'b0,1'b0,c[0],A[7:0],B[7:0],S[7:0],P[0],G[0],Couts[0]);
    cla_block cla2(P[0],G[0],c[1],A[15:8],B[15:8],S[15:8],P[1],G[1],Couts[1]);
    cla_block cla3(P[1],G[1],c[2],A[23:16],B[23:16],S[23:16],P[2],G[2],Couts[2]);
    cla_block cla4(P[2],G[2],c[3],A[31:24],B[31:24],S[31:24],P[3],G[3],Couts[3]);
    
    assign prevCout = Couts[3];

    // calculating carry using P and G
    wire w0;
    and (w0,P[0],c[0]);
    or (c[1],G[0],w0);

    wire [1:0] w1;
    and (w1[0],P[1],G[0]);
    and (w1[1],P[1],P[0],c[0]);
    or (c[2],G[1],w1[0],w1[1]);

    wire [2:0] w2;
    and (w2[0],P[2],G[1]);
    and (w2[1],P[2],P[1],G[0]);
    and (w2[2],P[2],P[1],P[0],c[0]);
    or (c[3],G[2],w2[0],w2[1],w2[2]);

    // final carryout
    wire [3:0] w3;
    and (w3[0],P[3],G[2]);
    and (w3[1],P[3],P[2],G[1]);
    and (w3[2],P[3],P[2],P[1],G[0]);
    and (w3[3],P[3],P[2],P[1],P[0],c[0]);
    or (c[4],G[3],w3[0],w3[1],w3[2],w3[3]);
    
    assign Cout = c[4];

endmodule