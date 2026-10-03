module priority_encoder (
    input  wire emergency_north,
    input  wire emergency_south,
    input  wire emergency_east,
    input  wire emergency_west,

    output reg [2:0] priority
);

    localparam NONE  = 3'b000;
    localparam NORTH = 3'b001;
    localparam SOUTH = 3'b010;
    localparam EAST  = 3'b011;
    localparam WEST  = 3'b100;

    always @(*) begin

        if (emergency_north)
            priority = NORTH;

        else if (emergency_south)
            priority = SOUTH;

        else if (emergency_east)
            priority = EAST;

        else if (emergency_west)
            priority = WEST;

        else
            priority = NONE;

    end

endmodule