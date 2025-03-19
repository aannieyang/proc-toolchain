module barrel_8(A,S);
    input [31:0] A;
    output [31:0] S;

    assign S[31:8] = A[23:0];
    assign S[7:0] = 8'b0;

endmodule