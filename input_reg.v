`timescale 1ns/1ps

module input_reg (reset, clk,input_features_in,input_features_out);
  
  parameter image_size = 11*11;
  input reset;
  input clk; 
  input [(image_size) - 1:0]input_features_in; //define the input features (121 dimensions by 1 bits) 
  output reg [(image_size) - 1:0] input_features_out; // to distinguish among 10 different digits

always @ (posedge clk)
begin 

if (reset)
input_features_out=0;
else
input_features_out=input_features_in;

end

  
endmodule
