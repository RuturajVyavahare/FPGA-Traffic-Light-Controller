`timescale 1ns / 1ps

module traffic_controller_tb;

    //============================================================
    // TESTBENCH PARAMETERS
    // Small values are used for fast simulation.
    //============================================================

    parameter CLK_FREQ       = 10;
    parameter GREEN_TIME     = 5;
    parameter YELLOW_TIME    = 2;
    parameter ALL_RED_TIME   = 1;
    parameter EMERGENCY_TIME = 4;

    //============================================================
    // CLOCK AND RESET
    //============================================================

    reg clk;
    reg reset;

    //============================================================
    // EMERGENCY INPUTS
    //============================================================

    reg emergency_north;
    reg emergency_south;
    reg emergency_east;
    reg emergency_west;

    //============================================================
    // TRAFFIC LIGHT OUTPUTS
    //============================================================

    wire north_red;
    wire north_yellow;
    wire north_green;

    wire south_red;
    wire south_yellow;
    wire south_green;

    wire east_red;
    wire east_yellow;
    wire east_green;

    wire west_red;
    wire west_yellow;
    wire west_green;

    //============================================================
    // DUT INSTANTIATION
    //============================================================

    traffic_controller #(
        .CLK_FREQ(CLK_FREQ),
        .GREEN_TIME(GREEN_TIME),
        .YELLOW_TIME(YELLOW_TIME),
        .ALL_RED_TIME(ALL_RED_TIME),
        .EMERGENCY_TIME(EMERGENCY_TIME)
    ) dut (

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

    //============================================================
    // CLOCK GENERATION
    //============================================================

    initial begin
        clk = 1'b0;

        forever #5 clk = ~clk;
    end

    //============================================================
    // VCD WAVEFORM
    //============================================================

    initial begin

        $dumpfile("Simulation/final_traffic_controller.vcd");

        $dumpvars(0, traffic_controller_tb);

    end

    //============================================================
    // MONITOR
    //============================================================

    always @(posedge clk) begin

        if (dut.one_second_tick) begin

            $display(
                "TIME=%0t | STATE=%0d | N=%b%b%b | S=%b%b%b | E=%b%b%b | W=%b%b%b",
                $time,
                dut.current_state,

                north_red,
                north_yellow,
                north_green,

                south_red,
                south_yellow,
                south_green,

                east_red,
                east_yellow,
                east_green,

                west_red,
                west_yellow,
                west_green
            );

        end

    end

    //============================================================
    // TEST SEQUENCE
    //============================================================

    initial begin

        //========================================================
        // INITIAL VALUES
        //========================================================

        reset = 1'b1;

        emergency_north = 1'b0;
        emergency_south = 1'b0;
        emergency_east  = 1'b0;
        emergency_west  = 1'b0;

        //========================================================
        // RESET
        //========================================================

        #20;

        reset = 1'b0;

        //========================================================
        // TEST 1: NORMAL TRAFFIC
        //========================================================

        $display("");
        $display("==============================================");
        $display("TEST 1: NORMAL TRAFFIC");
        $display("==============================================");

        // Allow normal traffic sequence to run.
        #700;

        //========================================================
        // TEST 2: NORTH EMERGENCY
        //========================================================

        $display("");
        $display("==============================================");
        $display("TEST 2: NORTH EMERGENCY");
        $display("==============================================");

        emergency_north = 1'b1;

        // Wait until North emergency state is reached.
        wait (dut.current_state == 4'd6);

        $display("NORTH EMERGENCY ACTIVE");

        // Keep emergency active for its full duration.
        #220;

        emergency_north = 1'b0;

        // Wait for emergency all-red state.
        wait (dut.current_state == 4'd10);

        $display("NORTH EMERGENCY COMPLETED");

        //========================================================
        // TEST 3: SOUTH EMERGENCY
        //========================================================

        $display("");
        $display("==============================================");
        $display("TEST 3: SOUTH EMERGENCY");
        $display("==============================================");

        emergency_south = 1'b1;

        wait (dut.current_state == 4'd7);

        $display("SOUTH EMERGENCY ACTIVE");

        #220;

        emergency_south = 1'b0;

        wait (dut.current_state == 4'd10);

        $display("SOUTH EMERGENCY COMPLETED");

        //========================================================
        // TEST 4: EAST EMERGENCY
        //========================================================

        $display("");
        $display("==============================================");
        $display("TEST 4: EAST EMERGENCY");
        $display("==============================================");

        emergency_east = 1'b1;

        wait (dut.current_state == 4'd8);

        $display("EAST EMERGENCY ACTIVE");

        #220;

        emergency_east = 1'b0;

        wait (dut.current_state == 4'd10);

        $display("EAST EMERGENCY COMPLETED");

        //========================================================
        // TEST 5: WEST EMERGENCY
        //========================================================

        $display("");
        $display("==============================================");
        $display("TEST 5: WEST EMERGENCY");
        $display("==============================================");

        emergency_west = 1'b1;

        wait (dut.current_state == 4'd9);

        $display("WEST EMERGENCY ACTIVE");

        #220;

        emergency_west = 1'b0;

        wait (dut.current_state == 4'd10);

        $display("WEST EMERGENCY COMPLETED");

        //========================================================
        // TEST 6: PRIORITY TEST
        // NORTH + EAST
        // NORTH SHOULD WIN
        //========================================================

        $display("");
        $display("==============================================");
        $display("TEST 6: PRIORITY TEST");
        $display("NORTH + EAST REQUESTED");
        $display("NORTH SHOULD WIN");
        $display("==============================================");

        emergency_north = 1'b1;
        emergency_east  = 1'b1;

        wait (dut.current_state == 4'd6);

        if (dut.current_state == 4'd6)
            $display("PASS: NORTH HAS PRIORITY OVER EAST");
        else
            $display("FAIL: PRIORITY TEST");

        #150;

        emergency_north = 1'b0;
        emergency_east  = 1'b0;

        wait (dut.current_state == 4'd10);

        //========================================================
        // TEST 7: MULTIPLE EMERGENCY PRIORITY
        // SOUTH + EAST + WEST
        // SOUTH SHOULD WIN
        //========================================================

        $display("");
        $display("==============================================");
        $display("TEST 7: MULTIPLE EMERGENCY");
        $display("SOUTH + EAST + WEST");
        $display("SOUTH SHOULD WIN");
        $display("==============================================");

        emergency_south = 1'b1;
        emergency_east  = 1'b1;
        emergency_west  = 1'b1;

        wait (dut.current_state == 4'd7);

        if (dut.current_state == 4'd7)
            $display("PASS: SOUTH HAS PRIORITY OVER EAST AND WEST");
        else
            $display("FAIL: MULTIPLE EMERGENCY PRIORITY TEST");

        #150;

        emergency_south = 1'b0;
        emergency_east  = 1'b0;
        emergency_west  = 1'b0;

        wait (dut.current_state == 4'd10);

        //========================================================
        // TEST COMPLETE
        //========================================================

        $display("");
        $display("==============================================");
        $display("ALL TEST SCENARIOS COMPLETED");
        $display("==============================================");

        #50;

        $finish;

    end

endmodule