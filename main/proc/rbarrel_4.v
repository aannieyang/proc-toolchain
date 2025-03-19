module rbarrel_4(A,S);
    input [31:0] A;
    output [31:0] S;

    assign S[27:0] = A[31:4];
    assign S[31:28] = {4{A[31]}};

endmodule