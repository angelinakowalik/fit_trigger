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
    
    typedef logic [0:11][9:0] trig_time ;
    typedef logic [0:11][12:0] trig_ampl0;
    logic [(12*10-1):0] v_trig_time_ch;
    logic [(12*13-1):0] v_trig_amp_ch;
    trig_time trig_time_ch;
    trig_ampl0 trig_amp_ch;
    
    logic clk;
    logic [2:0] state_counter;
    logic [1:0] trig_time_out;
    logic [1:0] trig_amp_out;
    logic [CHANNEL-1:0]CH_time, CH_amp, CH_b;
    
    logic [1:0] tim_out[11:0];
    logic [1:0] amp_out[11:0];
    int count;

    logic [1:0] tim_res[11:0];
    logic [1:0] amp_res[11:0];
    
    logic tcm_req;

    assign v_trig_time_ch = trig_time_ch;
    assign v_trig_amp_ch = trig_amp_ch;
    
    initial begin
        clk = 0;
        state_counter = -1;
        count = 0;
        read_sample(CH_amp,CH_time,trig_amp_ch,trig_time_ch,CH_b,tcm_req);
        # 120; 
        read_results(tim_res,amp_res);
        write_to_file(tim_res,amp_res);
        
        foreach(tim_res[i]) begin
            if(tim_res[i] == tim_out[i] && amp_res[i] == amp_out[i])
                $display("Test PASSED");
            else
                $display("Test FAILED");
        end
        $finish;
    end
   //sparametryzowac pmy 
    //generate clk
    always #5 clk = ~clk;
    
    //generate mt_counter
    always @(posedge clk) state_counter++;
    
    //capture outputs
    always @(posedge clk) begin
        tim_out[count] = trig_time_out;
        amp_out[count] = trig_amp_out;
        count++;
        if(count == 12)
            count = 0;
    end
        
    trigger_wrapper my_trigger(
    .clk320(clk),
    .mt_cou(state_counter),
    .CH_trigt(CH_time), 
    .CH_triga(CH_amp), 
    .CH_trigb(CH_b), 
    .CH_TIME_T(trig_time_ch),
    .CH_ampl0(trig_amp_ch),
    .tcm_req(tcm_req),
    .tt(trig_time_out),
    .ta(trig_amp_out)
    );
    
    
    task read_sample(output logic [CHANNEL-1:0]CH_amp, output logic [CHANNEL-1:0]CH_time, output [CHANNEL-1:0][12:0]amp, output [CHANNEL-1:0][9:0]tim,
                        output logic [CHANNEL-1:0]CH_b, output logic tcm_req);
        string line;
        integer code;
        int num[CHANNEL-1:0];
        int fd;

        fd = $fopen("sample.csv", "r");
        
        // Check if the file has been opened
        if (fd == 0) begin
          $display ("ERROR: sample.csv not opened");
          $finish;
        end
        
        foreach(num[i]) begin
            code = $fgets(line,fd);
            $sscanf(line,"%d,%b,%b,%h,%h,%h",num[i],CH_amp[i],CH_time[i],amp[i],tim[i],CH_b[i]);
            $display("%d", line);
        end 
        tcm_req = 1;
        
        
//        $fclose("sample.csv");  
    endtask :read_sample
    
    task read_results(output logic [1:0] tim_res[11:0], output logic [1:0] amp_res[11:0]);
    int fd;
    int i;
    integer code;
    int num[CHANNEL-1:0];
    string line;
    
    fd = $fopen("results.csv", "r");
    
    // Check if the file has been opened
    if (fd == 0) begin
      $display ("ERROR: sample.csv not opened");
      $finish;
    end
    
    foreach(num[i]) begin
        code = $fgets(line,fd);
        $sscanf(line,"%d,%d",tim_res[i], amp_res[i]);
        $display("%d", line);
    end 
   
    endtask :read_results
    
    task write_to_file(input logic [1:0] tim_res[11:0], input logic [1:0] amp_res[11:0]);
        int num[CHANNEL-1:0];
        int file;
        file = $fopen ("outputs.txt", "w");
        foreach(num[i]) begin
            $fdisplay(file,"%d,%d",tim_res[i], amp_res[i]);
        end 
        $fclose(file);
    endtask
    
endmodule
