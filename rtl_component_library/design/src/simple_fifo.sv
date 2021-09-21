// Code your design here

module FIFO (data_out, data_in, reset, clk, write_enable, write_pointer, read_enable, read_pointer);
    output logic [7:0] data_out;
    input logic [7:0] data_in;
    input logic reset;
    input logic clk;
    input logic write_enable;
    input logic write_pointer;
    input logic read_enable;
    input logic read_pointer;
    
    /* Memory for temporary storage of FIFO data */
    logic [7:0] memory [7:0];
    
    always @(posedge clk) begin
      if (reset) 
        begin
            data_out <= 8'b00000000;
        end 
      else if (write_enable)
        begin
          memory[write_pointer] <= data_in;
          write_pointer++;
        end
      else if (read_enable)
    end
  endmodule