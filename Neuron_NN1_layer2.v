`timescale 1ns/1ns

module Neuron_NN1_layer2 (reset1,clk3,input_features,input_weights,bias,out);

  // parameter hidden_layer = 30, weight_bit=4, output_bit=8, input_bit=4;
  // parameter hidden_layer = 200, weight_bit=4, output_bit=8, input_bit=4;
  parameter hidden_layer = 100, weight_bit=4, output_bit=8, input_bit=4;

  input [2:0] bias;
  input [(input_bit*hidden_layer) - 1:0]input_features; //define the input features (30 dimensions by 3 bits) 
  input [(weight_bit*hidden_layer) - 1:0]input_weights; //define the input weights  (30 dimensions by 3 bits) 
  input clk3,reset1;
  

  output reg [output_bit-1:0] out;
  

  integer i;
  reg signed [(weight_bit) - 1:0] selected_weight; 
  reg signed [output_bit-1:0] add_result1; // make it 11-bis
  reg signed [output_bit-1:0] mult_result[hidden_layer-1:0]; //4-bit*5-bit=9+1=10-bit
  reg signed [input_bit:0]selected_input;
  reg signed [output_bit-1:0] final_add;
  
  always @ (posedge clk3) 
  begin 
  if (reset1)begin
  out=0;add_result1=0;
  end
  else 
  begin

     for (i=0;i<hidden_layer;i=i+1)
     begin
     selected_weight= input_weights[4*i +:4];
     selected_input= {1'b0,input_features[4*i +:4]};
     mult_result[i]= selected_input*selected_weight;
     add_result1= add_result1 + mult_result[i];
     end 
 //Add Bias
     final_add=add_result1+bias;  
 //ReLu
     if (final_add<=0)
     out=8'b00000000;
     else 
     out=final_add;
     end 
  end
 

endmodule 

