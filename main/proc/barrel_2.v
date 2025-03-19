module barrel_2(A,S);
    input [31:0] A;
    output [31:0] S;

    assign S[31:2] = A[29:0];
    assign S[1:0] = 2'b0;

endmodule