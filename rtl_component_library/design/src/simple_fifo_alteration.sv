/* Created 2021 by Kåre-Benjamin H Rørvik 
 * This is a simple synchronous FIFO, with asynchronous reset.
 * THIS FIFO WILL NOT OVERWRITE WHEN FULL
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

    /* Gates the circuit from writing */
    logic stop_write;
    logic stop_read;
  
  	/* Pointers */
    logic [$clog2(FIFO_DEPTH) - 1:0] write_pointer;
    logic [$clog2(FIFO_DEPTH) - 1:0] read_pointer;
    
    /* Fifo is full if write_pointer has reached the highest address value
     * or if the read pointer is at 0.
     * FIFO is empty if the two pointers has the same address value */
    assign full = ((write_pointer == FIFO_DEPTH - 1) & ((read_pointer == 3'b000)) ? 1'b1 : 1'b0);
    assign empty = ((write_pointer == read_pointer) ? 1'b1 : 1'b0);

    /* Reset to flush/initialize/clean the FIFO */    
    always @(*) begin
        if (rst) 
            begin
                data_out <= 8'b00000000;
                write_pointer <= 3'b000;
                read_pointer  <= 3'b000;
                stop_write    <= 1'b0;
                stop_read    <= 1'b0;
                    for (int i = 0; i < FIFO_DEPTH; i++) begin
                        memory[i] = 8'b0000_0000;
                    end       
            end 
    end
    /* Read/Write stage */
    always @(posedge clk) begin
        /* Write takes priority over write */

        /* 3-step strategy to prevent bad systemstates 
         * This is not ideal for HW implementation and 
         * is strictly for debuggin purposes*/
        
        /* If a stop_write has taken place, start pointer from 0 again
         * also dissable stop_write */
        if (write_enable & !full & stop_write)
            begin
                write_pointer = 0;
                memory[write_pointer] <= data_in;
                write_pointer++;
                stop_write <= 1'b0;
            end
        /* This is the standard write operation */
        else if (write_enable & !full & !stop_write)
            begin
                memory[write_pointer] <= data_in;
                write_pointer++;
            end
        /* When write_pointer reaches 3'b111 it would otherwise overflow
        *  we will leave it at 3'b111 and write the last value 
        *  set stop_write so that no further write happens until 
        *  FIFO is no longer full */ 
        else if (write_enable & full & !stop_write)
            begin
                memory[write_pointer] <= data_in;
                stop_write <= 1'b1;
            end

        /* Read stage */

        /* Same 3-step strategy to prevent bad systemstates 
         * This is not ideal for HW implementation and 
         * is strictly for debuggin purposes*/
        else if (read_enable & !empty & stop_read)
            begin
                read_pointer = 0;
                data_out <= memory[read_pointer];
                read_pointer++;
                stop_read <= 1'b0;
            end
        else if (read_enable & !empty & !stop_read)
            begin
                data_out <= memory[read_pointer];
                read_pointer++;
                stop_read <= 1'b0;
            end
        else if (read_enable & empty & !stop_read)
            begin
                data_out <= memory[read_pointer];
                stop_read <= 1'b1;
            end
    end
endmodule