`timescale 1ns/1ns

module Neuron_NN1_layer1 (reset2,clk3,input_features,input_weights,bias,out);

  parameter image_size = 11*11, weight_bit=4, output_bit=4, input_bit=1;

  input [2:0] bias;
  input [(image_size*input_bit) - 1:0]input_features; //define the input features (121 dimensions by 1 bits) 
  input [(weight_bit*image_size) - 1:0]input_weights; //define the input weights (121 dimensions by 3 bits) 
  input clk3,reset2; 
  

  output reg [output_bit-1:0] out;


  integer i;
  reg signed [(weight_bit) - 1:0] selected_weight; 
  reg signed [(2*input_bit)-1:0] selected_input;

  reg signed [8-1:0] add_result; // log2(~1000)=10
  reg signed [6-1:0] mult_result[image_size-1:0]; //6bits
  reg signed [8-1:0] final_add; //10 bits

  
  always @ (posedge clk3)
  begin 
  if (reset2)begin
  out=0;add_result=0;end
  else 
  begin

     for (i=0;i<image_size;i=i+1)
     begin
     selected_weight= input_weights[4*i +:4];  
     selected_input= {1'b0,input_features[i]};
     mult_result[i]= selected_input*selected_weight;
     add_result= add_result + mult_result[i];
     end 
 //Add Bias
     final_add=add_result+bias;
 //ReLu
     if (final_add<=0)
     out=4'b0000;
     else 
     out=final_add[6:3];
     end 

  end


  
endmodule 

