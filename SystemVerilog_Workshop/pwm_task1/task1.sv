module pwm_generator (
    input  logic clk,
    input  logic reset,      
    output logic pwm_out
);

    logic [7:0] count;       // 0..255

    // Up-counter with wrap-around (period = 256)
    always_ff @(posedge clk) begin
        if (reset)
            count <= 8'd0;
        else
            count <= count + 1'b1;   // automatically wraps from 255 to 0
    end

    // PWM: 50% duty cycle (high for first half of period)
    assign pwm_out = (count < 128);

endmodule