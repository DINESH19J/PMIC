`timescale 1ns/1ps

module adaptive_pmic (
    input wire clk,
    input wire rst,
    input wire [3:0] channel_request,
    input wire [2:0] mode,
    output reg [3:0] channel_enable
);

    localparam ACTIVE    = 3'b000;
    localparam ADAPTIVE  = 3'b001;
    localparam STANDBY   = 3'b010;
    localparam SLEEP     = 3'b011;
    localparam POWER_OFF = 3'b100;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            channel_enable <= 4'b0000;
        end else begin
            case (mode)
                ACTIVE,
                ADAPTIVE,
                STANDBY: channel_enable <= channel_request;

                SLEEP,
                POWER_OFF: channel_enable <= 4'b0000;

                default: channel_enable <= 4'b0000;
            endcase
        end
    end

endmodule
