module FIFO_tb;
    logic [7:0] data_out;
    logic [7:0] data_in;
    logic reset, clk, write_enable, read_enable;

    FIFO FIFO_DUT(.*);

    /* Waveform Dump */
    initial begin 
        $dumpfile("dump.vcd"); $dumpvars;
    end

    initial begin
    $display("We are starting");
        reset = 1;
        clk = 0;
        write_enable = 1'b1;
        data_in = 8'b00110011;
        #10;
        reset = 0;
        clk = 1;
        data_in = 8'b11001100;
        #10;
        clk = 0;
        data_in = 8'b00110011;
        #10;
        clk = 1;
        data_in = 8'b00001111;
        #10;
    end
endmodule