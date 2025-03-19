module barrel_16(A,S);
    input [31:0] A;
    output [31:0] S;

    assign S[31:16] = A[15:0];
    assign S[15:0] = 16'b0;

endmodule