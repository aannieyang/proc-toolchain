module full_adder(S,A,B,Cin);
    input A,B,Cin;
    output S;
    wire w1,w2,w3;
    xor SUM(S,A,B,Cin);
    and AND1(w1,A,B);
    and AND2(w2,A,Cin);
    and AND3(w3,B,Cin);
endmodule