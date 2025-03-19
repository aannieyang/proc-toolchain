module barrel_1(A,S);
    input [31:0] A;
    output [31:0] S;

    assign S[31:1] = A[30:0];
    assign S[0] = 1'b0;

endmodule