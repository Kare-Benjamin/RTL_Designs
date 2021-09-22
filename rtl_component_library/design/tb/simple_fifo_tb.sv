module FIFO_tb;
    /* FIFO parameters */
    parameter FIFO_DEPTH = 8;
    parameter FIFO_W = 8;

    /* Simulation parameters */
    parameter PERIOD = 5;

    /* Outputs */
    logic [FIFO_DEPTH - 1:0] data_out;
    logic empty, full;

    /* Inputs */
    logic [FIFO_DEPTH - 1:0] data_in;
    logic rst, clk, write_enable, read_enable;

    /* Instantiations */
    FIFO FIFO_DUT(.*);

    /* Waveform Dump */
    initial begin 
        $dumpfile("dump.vcd"); $dumpvars;
    end

    /* clock setup */
    always #PERIOD clk =! clk;

    initial begin
        $display("FIFO test is starting");

        /* Setup and reset stage */
        clk = 1;
        rst = 1; write_enable = 0; read_enable = 0; 
        data_in = 8'b00110011;
        #10; rst = 0; write_enable = 0; read_enable = 0; 
        data_in = 8'b11001100;
      
      	/* write to FIFO */
      	#10; rst = 0; write_enable = 1; read_enable = 0; 
        data_in = 8'b11001100;
        #10; rst = 0; write_enable = 1; read_enable = 0; 
        data_in = 8'b00110011;
        #10; rst = 0; write_enable = 1; read_enable = 0; 
        data_in = 8'b00001111;

         /* Read from FIFO */
        #10; rst = 0; write_enable = 0; read_enable = 1; 
        data_in = 8'b11111111;
        #10; rst = 0; write_enable = 0; read_enable = 1; 
        data_in = 8'b11111111;
        #10; rst = 0; write_enable = 0; read_enable = 1; 
        data_in = 8'b11111111;

        /* Simulation complete */
        #10;
        $finish;
    end
endmodule