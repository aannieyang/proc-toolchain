module tff(t, clk, q,clr);
    input t,clk,clr;
    output q;

    //q, d, clk, en, clr
    dffe_ref dffe1(q,(~t&q)|(t&~q),clk,1'b1,clr);
endmodule