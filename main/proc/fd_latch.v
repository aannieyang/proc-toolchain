module fd_latch(clk, en, reset, pc_in, pc_out, ir_in, ir_out);
    input [31:0] pc_in, ir_in;
    input en, clk, reset;
    output [31:0] pc_out, ir_out;

    genvar i;
    generate
        for (i = 0; i<32; i=i+1) begin
            //q, d, clk, en, clr)
            dffe_ref pc(pc_out[i], pc_in[i],clk,en,reset);
            dffe_ref ir(ir_out[i],ir_in[i],clk,en,reset);
        end
    endgenerate
endmodule