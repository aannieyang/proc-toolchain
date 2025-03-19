module rbarrel_8(A,S);
    input [31:0] A;
    output [31:0] S;

    assign S[23:0] = A[31:8];
    assign S[31:24] = {8{A[31]}};

endmodule