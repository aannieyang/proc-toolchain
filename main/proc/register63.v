module register63(clk, writeEnable, reset, writeIn, readOut);
    input clk, reset, writeEnable;
    input [63:0] writeIn;
    output [63:0] readOut;

    genvar i;
    generate
        for (i = 0; i<64; i=i+1) begin
            //q, d, clk, en, clr)
            dffe_ref a_dff(readOut[i],writeIn[i],clk,writeEnable,reset);
        end
    endgenerate


endmodule