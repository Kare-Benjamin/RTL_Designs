// Code your design here

module FIFO (data_out, data_in, reset, clk, write_enable, read_enable);
    output logic [7:0] data_out;
    input logic [7:0] data_in;
    input logic reset;
    input logic clk;
    input logic write_enable;
    input logic read_enable;
    
    
    /* Memory for temporary storage of FIFO data */
    logic [7:0] memory [7:0];
  
  	/* Pointers */
  	logic [7:0] write_pointer;
 	logic [7:0] read_pointer;
    
    /*
    generate genvar i;
        for (i = 0; i < 8; i++) begin
            // Do nothing
        end
    endgenerate
    */
    
    always @(posedge clk) begin
        if (reset) 
            begin
                data_out <= 8'b00000000;
                write_pointer <= 8'b0000_0000;
                read_pointer <= 8'b0000_0000;
                    for (int i = 0; i < 8; i++) begin
                        memory[i] = 8'b0000_0000;
                    end       
            end 
        else if (write_enable)
            begin
                memory[write_pointer] <= data_in;
                write_pointer++;
            end
        else if (read_enable)
            begin
                data_out[read_pointer] <= memory[read_pointer];
                read_pointer++;
            end
    end
endmodule