module rbarrel_1(A,S);
    input [31:0] A;
    output [31:0] S;

    assign S[30:0] = A[31:1];
    assign S[31] = A[31];

endmodule