`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 13.07.2020 14:58:48
// Design Name: 
// Module Name: trigger_test
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


module trigger_test(
    );
    
    localparam CHANNEL = 12;
    
    typedef bit [9:0] trig_time [0:11];
    typedef logic [12:0] trig_ampl0[0:11];
    
    logic clk;
    bit [2:0] state_counter;
    bit [11:0] CH_valid_time, CH_valid_amp;
    trig_time trig_time_ch;
    trig_ampl0 trig_amp_ch;
    bit [1:0] trig_time_out;
    bit [1:0] trig_amp_out;
    int fd;
    int num[CHANNEL-1:0], amp[CHANNEL-1:0], tim[CHANNEL-1:0];
    bit [CHANNEL-1:0]CH_time, CH_amp;
    int i;
    integer code;
    string str;
        
    initial begin
        fd = $fopen("sample.csv", "r");
        foreach(num[i]) begin
            code = $fgets(str,fd);
            $sscanf(str,"%d,%b,%b,%d,%d",num[i],CH_amp[i],CH_time[i],amp[i],tim[i]);
            $display("%d", str);
        end  
        clk = 0;
        state_counter = 0;
        forever begin
        #5 clk = ~clk;
        state_counter++;
        end
        # 50;
        
        $finish;
    end
    
    trigger my_trigger(
    .clk320(clk),
    .mt_cou(state_counter),
    .CH_trigt(CH_time), 
    .CH_triga(CH_amp), 
//    .CH_TIME_T(trig_time_ch),
//    .CH_ampl0(trig_amp_ch),
    .tt(trig_time_out),
    .ta(trig_amp_out)
    );
endmodule
