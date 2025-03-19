module rbarrel_2(A,S);
    input [31:0] A;
    output [31:0] S;

    assign S[29:0] = A[31:2];
    assign S[31:30] = {2{A[31]}};

endmodule