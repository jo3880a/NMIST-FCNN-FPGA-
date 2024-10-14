`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/10/2023 05:00:24 PM
// Design Name: 
// Module Name: input_rx
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module input_rx (
input               clk     , // Top level system clock input.
input               sw_0    , // Slide switches.
input               rst,
//input               sw_1    , // Slide switches.
input   wire        uart_rxd, // UART Recieve pin.
   output reg input_valid,
//output  wire        uart_txd, // UART transmit pin.
//output wire [127:0] led2,
output reg [120:0] network_input
);

// Clock frequency in hertz.
parameter image_size = 11*11;
parameter CLK_HZ = 100000000;
parameter BIT_RATE =   9600;
parameter PAYLOAD_BITS = 8;
integer count = 0;

wire [PAYLOAD_BITS-1:0]  uart_rx_data;
wire        uart_rx_valid;
wire        uart_rx_break;

//wire        uart_tx_busy;
//wire [PAYLOAD_BITS-1:0]  uart_tx_data;
//wire        uart_tx_en;
reg [120:0] temp;  
reg  [PAYLOAD_BITS-1:0]  led_reg;
assign      led = led_reg;
//reg [31:0] network_input;
// ------------------------------------------------------------------------- 

//assign uart_tx_data = uart_rx_data;
//assign uart_tx_en   = uart_rx_valid;
//assign input_valid = (count ==122);
always @(posedge clk or posedge rst ) begin
    if(rst)
    begin
        count <= 0;
        temp <= 121'b0;
        network_input <= 121'b0;
        input_valid <= 0;
    end
    else if(!sw_0) begin
        count <= 0;
        temp <= 121'b0;
        network_input <= 121'b0;
        input_valid <= 0;
    end
    else if(uart_rx_valid) 
    begin
        if (count < 121)
        begin
            case(uart_rx_data)
            8'h30: temp[count] <= 1'b0;
            8'h31: temp[count] <= 1'b1;
            default: temp[count] <= 1'b0;
            endcase
            count <= count + 1;
        end
        
        else if(count == 121)
        begin
            network_input <= temp;
            count <= 0;
            input_valid <= 1;
        end
    end
end


// ------------------------------------------------------------------------- 

//
// UART RX
uart_rx #(
.BIT_RATE(BIT_RATE),
.PAYLOAD_BITS(PAYLOAD_BITS),
.CLK_HZ  (CLK_HZ  )
) i_uart_rx(
.clk          (clk          ), // Top level system clock input.
.resetn       (sw_0         ), // Asynchronous active low reset.
.uart_rxd     (uart_rxd     ), // UART Recieve pin.
.uart_rx_en   (1'b1         ), // Recieve enable
.uart_rx_break(uart_rx_break), // Did we get a BREAK message?
.uart_rx_valid(uart_rx_valid), // Valid data recieved and available.
.uart_rx_data (uart_rx_data )  // The recieved data.
);


/*seven_seg U1(
.SW(network_input),
.a_to_g(a_to_g),
.clk(clk),
.rst(rst),
.an(AN),
.dp(DP)
);
*/

endmodule
