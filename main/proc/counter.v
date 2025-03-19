module counter(en,clk,w,reset);
    input clk,en, reset;
    output [5:0] w;

    //t, clk, q
    tff tff0(en,clk,w[0],reset);
    tff tff1(w[0]&en,clk,w[1],reset);
    tff tff2(w[1]&w[0]&en,clk,w[2],reset);
    tff tff3(w[2]&w[1]&w[0]&en,clk,w[3],reset);
    tff tff4(w[3]&w[2]&w[1]&w[0]&en,clk,w[4],reset);
    tff tff5(w[4]&w[3]&w[2]&w[1]&w[0]&en,clk,w[5],reset);
endmodule