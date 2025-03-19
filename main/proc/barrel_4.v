module barrel_4(A,S);
    input [31:0] A;
    output [31:0] S;

    assign S[31:4] = A[27:0];
    assign S[3:0] = 4'b0;

endmodule