module register(clk, writeEnable, reset, writeIn, readOut);
    input clk, reset, writeEnable;
    input [31:0] writeIn;
    output [31:0] readOut;

    genvar i;
    generate
        for (i = 0; i<32; i=i+1) begin
            //q, d, clk, en, clr)
            dffe_ref a_dff(readOut[i],writeIn[i],clk,writeEnable,reset);
        end
    endgenerate


endmodule