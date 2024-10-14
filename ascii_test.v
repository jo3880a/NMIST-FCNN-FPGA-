`timescale 1ns / 1ps
module ascii_test(
    input clk,
    input video_on,
    input [9:0] x, y,
    output reg [11:0] rgb,
    input reset2,
    input BTNR,
    input BTND,
    input [31:0] SW,// 7-Seg
    input rst,// 7-Seg
    output wire [6:0] a_to_g,// 7-Seg
    output wire [7:0] an,// 7-Seg
    output wire dp// 7-Seg
    );
    
    // signal declarations
    wire [10:0] rom_addr;           // 11-bit text ROM address
    wire [6:0] ascii_char;          // 7-bit ASCII character code
    wire [3:0] char_row;            // 4-bit row of ASCII character
    wire [2:0] bit_addr;            // column number of ROM data
    wire [7:0] rom_data;            // 8-bit row data from text ROM
    wire ascii_bit, ascii_bit_on;     // ROM bit and status signal
    
    // instantiate ASCII ROM
    ascii_rom rom(.clk(clk), .addr(rom_addr), .data(rom_data), .reset2(reset2), .SW(SW), .a_to_g(a_to_g), .rst(rst), .an(an), .dp(dp), .BTNR(BTNR));
    // ASCII ROM interface
    assign rom_addr = {ascii_char, char_row};   // ROM address is ascii code + row
    assign ascii_bit = rom_data[~bit_addr];     // reverse bit order

    assign ascii_char = {y[5:4], x[7:3]};   // 7-bit ascii code
    assign char_row = y[3:0];               // row number of ascii character rom
    assign bit_addr = x[2:0];               // column number of ascii character rom
    // "on" region in center of screen
    assign ascii_bit_on = ((x >= 192 && x < 448) && (y >= 208 && y < 272)) ? ascii_bit : 1'b0;
    
    always @*
        if(~video_on)
            rgb = 12'h000;      // blank
        else
            if(ascii_bit_on)
                rgb = 12'h00F;  // blue letters
            else
                rgb = 12'hFFF;               
endmodule