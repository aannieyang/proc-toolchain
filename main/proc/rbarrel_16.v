module rbarrel_16(A,S);
    input [31:0] A;
    output [31:0] S;

    assign S[15:0] = A[31:16];
    assign S[31:16] = {16{A[31]}};

endmodule