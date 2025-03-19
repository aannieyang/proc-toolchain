module md_latch(clk, en, reset, ir_in, ir_out, a_in, a_out, b_in, b_out, stall, ready, mult_in, mult_out, div_in, div_out);
    input [31:0] ir_in, a_in, b_in;
    input en, clk, reset, ready, run, mult_in, div_in;
    output [31:0] ir_out, a_out, b_out;
    output stall, mult_out, div_out;
    
    genvar i;
    generate
        for (i = 0; i<32; i=i+1) begin
            //q, d, clk, en, clr
            dffe_ref ir(ir_out[i],ir_in[i],clk,en,reset);
            dffe_ref a(a_out[i],a_in[i],clk,en,reset);
            dffe_ref b(b_out[i],b_in[i],clk,en,reset);
        end
    endgenerate
    dffe_ref b(stall,1'b1,clk,en,ready);
    dffe_ref m(mult_out,mult_in,clk,en,reset);
    dffe_ref d(div_out,div_in,clk,en,reset);
endmodule