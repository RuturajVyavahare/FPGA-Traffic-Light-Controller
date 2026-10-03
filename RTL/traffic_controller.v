`timescale 1ns / 1ps

module traffic_controller #(
    parameter integer CLK_FREQ       = 100_000_000,
    parameter integer GREEN_TIME     = 10,
    parameter integer YELLOW_TIME    = 3,
    parameter integer ALL_RED_TIME   = 1,
    parameter integer EMERGENCY_TIME = 10
)(
    input  wire clk,
    input  wire reset,

    // Emergency inputs
    input  wire emergency_north,
    input  wire emergency_south,
    input  wire emergency_east,
    input  wire emergency_west,

    // North traffic lights
    output reg north_red,
    output reg north_yellow,
    output reg north_green,

    // South traffic lights
    output reg south_red,
    output reg south_yellow,
    output reg south_green,

    // East traffic lights
    output reg east_red,
    output reg east_yellow,
    output reg east_green,

    // West traffic lights
    output reg west_red,
    output reg west_yellow,
    output reg west_green
);

    //============================================================
    // STATE DEFINITIONS
    //============================================================

    localparam NS_GREEN     = 4'd0;
    localparam NS_YELLOW    = 4'd1;
    localparam ALL_RED_1    = 4'd2;

    localparam EW_GREEN     = 4'd3;
    localparam EW_YELLOW    = 4'd4;
    localparam ALL_RED_2    = 4'd5;

    localparam EMG_NORTH    = 4'd6;
    localparam EMG_SOUTH    = 4'd7;
    localparam EMG_EAST     = 4'd8;
    localparam EMG_WEST     = 4'd9;

    localparam EMG_ALL_RED  = 4'd10;

    //============================================================
    // PRIORITY DEFINITIONS
    // Priority: North > South > East > West
    //============================================================

    localparam NO_EMERGENCY = 3'd0;
    localparam NORTH        = 3'd1;
    localparam SOUTH        = 3'd2;
    localparam EAST         = 3'd3;
    localparam WEST         = 3'd4;

    reg [2:0] emergency_priority;

    //============================================================
    // CLOCK / 1-SECOND TIMER
    //============================================================

    integer clock_counter;
    reg one_second_tick;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            clock_counter  <= 0;
            one_second_tick <= 1'b0;
        end
        else begin
            if (clock_counter >= CLK_FREQ - 1) begin
                clock_counter   <= 0;
                one_second_tick <= 1'b1;
            end
            else begin
                clock_counter   <= clock_counter + 1;
                one_second_tick <= 1'b0;
            end
        end
    end

    //============================================================
    // PRIORITY ENCODER
    //============================================================

    always @(*) begin

        if (emergency_north)
            emergency_priority = NORTH;

        else if (emergency_south)
            emergency_priority = SOUTH;

        else if (emergency_east)
            emergency_priority = EAST;

        else if (emergency_west)
            emergency_priority = WEST;

        else
            emergency_priority = NO_EMERGENCY;

    end

    //============================================================
    // STATE REGISTER AND STATE TIMER
    //============================================================

    reg [3:0] current_state;
    reg [3:0] next_state;

    integer state_timer;

    always @(posedge clk or posedge reset) begin

        if (reset) begin
            current_state <= NS_GREEN;
            state_timer   <= 0;
        end

        else if (one_second_tick) begin

            current_state <= next_state;

            if (next_state != current_state)
                state_timer <= 0;

            else
                state_timer <= state_timer + 1;

        end

    end

    //============================================================
    // NEXT STATE LOGIC
    //============================================================

    always @(*) begin

        // Default: remain in current state
        next_state = current_state;

        case (current_state)

            //====================================================
            // NORTH-SOUTH GREEN
            //====================================================

            NS_GREEN: begin

                if (state_timer >= GREEN_TIME - 1)
                    next_state = NS_YELLOW;

            end


            //====================================================
            // NORTH-SOUTH YELLOW
            //====================================================

            NS_YELLOW: begin

                if (state_timer >= YELLOW_TIME - 1)
                    next_state = ALL_RED_1;

            end


            //====================================================
            // ALL RED 1
            //====================================================

            ALL_RED_1: begin

                if (state_timer >= ALL_RED_TIME - 1) begin

                    case (emergency_priority)

                        NORTH:
                            next_state = EMG_NORTH;

                        SOUTH:
                            next_state = EMG_SOUTH;

                        EAST:
                            next_state = EMG_EAST;

                        WEST:
                            next_state = EMG_WEST;

                        default:
                            next_state = EW_GREEN;

                    endcase

                end

            end


            //====================================================
            // EAST-WEST GREEN
            //====================================================

            EW_GREEN: begin

                if (state_timer >= GREEN_TIME - 1)
                    next_state = EW_YELLOW;

            end


            //====================================================
            // EAST-WEST YELLOW
            //====================================================

            EW_YELLOW: begin

                if (state_timer >= YELLOW_TIME - 1)
                    next_state = ALL_RED_2;

            end


            //====================================================
            // ALL RED 2
            //====================================================

            ALL_RED_2: begin

                if (state_timer >= ALL_RED_TIME - 1) begin

                    case (emergency_priority)

                        NORTH:
                            next_state = EMG_NORTH;

                        SOUTH:
                            next_state = EMG_SOUTH;

                        EAST:
                            next_state = EMG_EAST;

                        WEST:
                            next_state = EMG_WEST;

                        default:
                            next_state = NS_GREEN;

                    endcase

                end

            end


            //====================================================
            // NORTH EMERGENCY
            //====================================================

            EMG_NORTH: begin

                if (!emergency_north)
                    next_state = EMG_ALL_RED;

                else if (state_timer >= EMERGENCY_TIME - 1)
                    next_state = EMG_ALL_RED;

            end


            //====================================================
            // SOUTH EMERGENCY
            //====================================================

            EMG_SOUTH: begin

                if (!emergency_south)
                    next_state = EMG_ALL_RED;

                else if (state_timer >= EMERGENCY_TIME - 1)
                    next_state = EMG_ALL_RED;

            end


            //====================================================
            // EAST EMERGENCY
            //====================================================

            EMG_EAST: begin

                if (!emergency_east)
                    next_state = EMG_ALL_RED;

                else if (state_timer >= EMERGENCY_TIME - 1)
                    next_state = EMG_ALL_RED;

            end


            //====================================================
            // WEST EMERGENCY
            //====================================================

            EMG_WEST: begin

                if (!emergency_west)
                    next_state = EMG_ALL_RED;

                else if (state_timer >= EMERGENCY_TIME - 1)
                    next_state = EMG_ALL_RED;

            end


            //====================================================
            // EMERGENCY ALL RED
            //====================================================

            EMG_ALL_RED: begin

                if (state_timer >= ALL_RED_TIME - 1) begin

                    case (emergency_priority)

                        NORTH:
                            next_state = EMG_NORTH;

                        SOUTH:
                            next_state = EMG_SOUTH;

                        EAST:
                            next_state = EMG_EAST;

                        WEST:
                            next_state = EMG_WEST;

                        default:
                            next_state = NS_GREEN;

                    endcase

                end

            end


            //====================================================
            // DEFAULT
            //====================================================

            default:
                next_state = NS_GREEN;

        endcase

    end

    //============================================================
    // OUTPUT LOGIC
    //============================================================

    always @(*) begin

        //========================================================
        // SAFE DEFAULT: ALL RED
        //========================================================

        north_red    = 1'b1;
        north_yellow = 1'b0;
        north_green  = 1'b0;

        south_red    = 1'b1;
        south_yellow = 1'b0;
        south_green  = 1'b0;

        east_red     = 1'b1;
        east_yellow  = 1'b0;
        east_green   = 1'b0;

        west_red     = 1'b1;
        west_yellow  = 1'b0;
        west_green   = 1'b0;


        case (current_state)

            //====================================================
            // NORMAL NORTH-SOUTH GREEN
            //====================================================

            NS_GREEN: begin

                north_red   = 1'b0;
                north_green = 1'b1;

                south_red   = 1'b0;
                south_green = 1'b1;

            end


            //====================================================
            // NORMAL NORTH-SOUTH YELLOW
            //====================================================

            NS_YELLOW: begin

                north_red    = 1'b0;
                north_yellow = 1'b1;

                south_red    = 1'b0;
                south_yellow = 1'b1;

            end


            //====================================================
            // NORMAL EAST-WEST GREEN
            //====================================================

            EW_GREEN: begin

                east_red   = 1'b0;
                east_green = 1'b1;

                west_red   = 1'b0;
                west_green = 1'b1;

            end


            //====================================================
            // NORMAL EAST-WEST YELLOW
            //====================================================

            EW_YELLOW: begin

                east_red    = 1'b0;
                east_yellow = 1'b1;

                west_red    = 1'b0;
                west_yellow = 1'b1;

            end


            //====================================================
            // NORTH EMERGENCY
            //====================================================

            EMG_NORTH: begin

                north_red   = 1'b0;
                north_green = 1'b1;

            end


            //====================================================
            // SOUTH EMERGENCY
            //====================================================

            EMG_SOUTH: begin

                south_red   = 1'b0;
                south_green = 1'b1;

            end


            //====================================================
            // EAST EMERGENCY
            //====================================================

            EMG_EAST: begin

                east_red   = 1'b0;
                east_green = 1'b1;

            end


            //====================================================
            // WEST EMERGENCY
            //====================================================

            EMG_WEST: begin

                west_red   = 1'b0;
                west_green = 1'b1;

            end


            //====================================================
            // ALL RED STATES
            //====================================================

            ALL_RED_1,
            ALL_RED_2,
            EMG_ALL_RED: begin

                // All traffic lights remain RED

            end


            //====================================================
            // DEFAULT
            //====================================================

            default: begin

                // Safe default: all RED

            end

        endcase

    end

endmodule