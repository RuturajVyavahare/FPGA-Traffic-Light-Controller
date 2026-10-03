module timer #(
    parameter integer CLK_FREQ = 100_000_000
)(
    input  wire clk,
    input  wire reset,

    input  wire enable,

    output reg tick
);

    integer counter;

    always @(posedge clk or posedge reset) begin

        if (reset) begin
            counter <= 0;
            tick    <= 1'b0;
        end

        else if (!enable) begin
            counter <= 0;
            tick    <= 1'b0;
        end

        else begin

            if (counter == CLK_FREQ - 1) begin
                counter <= 0;
                tick    <= 1'b1;
            end

            else begin
                counter <= counter + 1;
                tick    <= 1'b0;
            end

        end

    end

endmodule