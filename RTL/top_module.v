
`timescale 1ns / 1ps

module top_module #(
    parameter integer CLK_FREQ = 100_000_000
)(
    input wire clk,
    input wire reset,

    // Emergency request switches
    input wire emergency_north,
    input wire emergency_south,
    input wire emergency_east,
    input wire emergency_west,

    // North traffic lights
    output wire north_red,
    output wire north_yellow,
    output wire north_green,

    // South traffic lights
    output wire south_red,
    output wire south_yellow,
    output wire south_green,

    // East traffic lights
    output wire east_red,
    output wire east_yellow,
    output wire east_green,

    // West traffic lights
    output wire west_red,
    output wire west_yellow,
    output wire west_green
);

    // Main traffic controller
    traffic_controller #(
        .CLK_FREQ(CLK_FREQ),
        .GREEN_TIME(10),
        .YELLOW_TIME(3),
        .ALL_RED_TIME(1),
        .EMERGENCY_TIME(10)
    ) controller_inst (
        .clk(clk),
        .reset(reset),

        .emergency_north(emergency_north),
        .emergency_south(emergency_south),
        .emergency_east(emergency_east),
        .emergency_west(emergency_west),

        .north_red(north_red),
        .north_yellow(north_yellow),
        .north_green(north_green),

        .south_red(south_red),
        .south_yellow(south_yellow),
        .south_green(south_green),

        .east_red(east_red),
        .east_yellow(east_yellow),
        .east_green(east_green),

        .west_red(west_red),
        .west_yellow(west_yellow),
        .west_green(west_green)
    );

endmodule
