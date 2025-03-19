module xm_latch(clk, en, reset, ir_in, ir_out, o_in, o_out, b_in, b_out);
    input [31:0] ir_in, o_in, b_in;
    input en, clk, reset;
    output [31:0] ir_out, o_out, b_out;

    genvar i;
    generate
        for (i = 0; i<32; i=i+1) begin
            //q, d, clk, en, clr)
            dffe_ref ir(ir_out[i],ir_in[i],clk,en,reset);
            dffe_ref o(o_out[i],o_in[i],clk,en,reset);
            dffe_ref b(b_out[i],b_in[i],clk,en,reset);
        end
    endgenerate
endmodule