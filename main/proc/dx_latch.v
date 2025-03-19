module dx_latch(clk, en, reset, pc_in, pc_out, ir_in, ir_out, a_in, a_out, b_in, b_out);
    input [31:0] pc_in, ir_in, a_in, b_in;
    input en, clk, reset;
    output [31:0] pc_out, ir_out, a_out, b_out;

    genvar i;
    generate
        for (i = 0; i<32; i=i+1) begin
            //q, d, clk, en, clr)
            dffe_ref pc(pc_out[i], pc_in[i],clk,en,reset);
            dffe_ref ir(ir_out[i],ir_in[i],clk,en,reset);
            dffe_ref a(a_out[i],a_in[i],clk,en,reset);
            dffe_ref b(b_out[i],b_in[i],clk,en,reset);
        end
    endgenerate
endmodule