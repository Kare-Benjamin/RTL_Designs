/* Created 2021 by Kåre-Benjamin H Rørvik 
 * This is a simple synchronous FIFO, with asynchronous reset.
 * THIS FIFO WILL OVERWRITE WHEN FULL
 * In the current mode of operation you may only read or write at the same time.
 * (write_enable takes priority of read_enable).
 * The FIFO uses two dedicated pointers one for read and one for write.
 * To store the inputs a [x][y] memory is used.
 * The parameters FIFO_DEPTH and FIFO_W is used to adjust the fifo properties.
 * Where the width defines how wide the input may be, and the depth is the n
 * inputs that may be stored (the depth of the FIFO).
 */

module FIFO (data_out, full, empty, data_in, rst, clk, write_enable, read_enable);

    parameter FIFO_DEPTH = 8;
    parameter FIFO_W = 8;

    output logic [7:0] data_out;
    output logic full;
    output logic empty;
    input logic [7:0] data_in;
    input logic rst;
    input logic clk;
    input logic write_enable;
    input logic read_enable;
       
    /* Memory for temporary storage of FIFO data */
    logic [FIFO_DEPTH - 1:0] memory [FIFO_W - 1:0];
  
  	/* Pointers */
  	logic [$clog2(FIFO_DEPTH) - 1:0] write_pointer;
 	logic [$clog2(FIFO_DEPTH) - 1:0] read_pointer;
    
    /* Fifo is full if write_pointer has reached the highest address value
     * or if the read pointer is at 0.
     * FIFO is empty if the two pointers has the same address value */
    assign full = ((write_pointer == FIFO_DEPTH) & (read_pointer == 3'b000) ? 1'b1 : 1'b0);
    assign empty = ((write_pointer == read_pointer) ? 1'b1 : 1'b0);

    /* Reset to flush/initialize/clean the FIFO */  
    always @(*) begin
        if (rst) 
            begin
                data_out <= 8'b00000000;
                write_pointer <= 3'b000;
                read_pointer  <= 3'b000;
                    for (int i = 0; i < FIFO_DEPTH; i++) begin
                        memory[i] = 8'b0000_0000;
                    end       
            end 
    end

    /* Read/Write stage */  
    always @(posedge clk) begin
        /* Write takes priority over write */
        if (write_enable & !full)
            begin
                memory[write_pointer] <= data_in;
                write_pointer++;
            end
        /* Read stage */    
        else if (read_enable & !empty)
            begin
                data_out <= memory[read_pointer];
                read_pointer++;
            end
    end
endmodule