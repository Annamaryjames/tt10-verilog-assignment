/*
 * Copyright (c) 2024 Your Name
 * SPDX-License-Identifier: Apache-2.0
 */
`default_nettype none

module tt_um_ksaarray (
    input  wire [7:0] ui_in,    // Dedicated inputs (A[2:0], B[2:0], Enable, Unused)
    output wire [7:0] uo_out,   // Dedicated outputs (6-bit result + 2 unused bits)
    input  wire [7:0] uio_in,   // IOs: Input path (not used)
    output wire [7:0] uio_out,  // IOs: Output path (not used)
    output wire [7:0] uio_oe,   // IOs: Enable path (not used)
    input  wire       ena,      // always 1 when the design is powered, can be ignored
    input  wire       clk,      // clock (not used)
    input  wire       rst_n     // reset_n - low to reset (not used)
);
    wire [2:0] A = ui_in[2:0];   // Extract 3-bit input A
    wire [2:0] B = ui_in[5:3];   // Extract 3-bit input B
    wire Enable = ui_in[6];      // Enable signal
    
    wire [5:0] Output_Result;    // Final output result

    main_module main_inst (
        .A(A),
        .B(B),
        .Enable(Enable),
        .Output_Result(Output_Result)
    );

    assign uo_out = {2'b00, Output_Result};  // Output result (6-bit) padded to 8-bit
    assign uio_out = 0;            // Not used
    assign uio_oe = 0;             // Not used
    wire _unused = &{ena, clk, rst_n, 1'b0};

endmodule

// ----------------- 3-BIT KOGGE-STONE ADDER -----------------
module kogge_stone_adder_3bit (
    input  wire [2:0] A, B,
    input  wire Enable,
    output wire [3:0] Sum_Carry  // {Cout, Sum[2:0]}
);
    wire [2:0] G, P, C;
    wire [2:0] sum;
    wire cout;

    assign G = A & B;
    assign P = A ^ B;

    wire G1_0 = G[1] | (P[1] & G[0]);
    wire P1_0 = P[1] & P[0];
    wire G2_0 = G[2] | (P[2] & G1_0);

    assign C[0] = 1'b0;
    assign C[1] = G[0];
    assign C[2] = G1_0;
    assign cout  = G2_0;

    assign sum = P ^ C;
    assign Sum_Carry = Enable ? {cout, sum} : 4'b0000;

endmodule

// ----------------- ARRAY MULTIPLIER (3-BIT X 3-BIT) -----------------
module array_multiplier_3bit (
    input wire [2:0] A, B,
    input wire Enable,
    output wire [5:0] Product
);
    wire [2:0] pp0, pp1, pp2;
    wire [5:0] sum1, sum2;

    assign pp0 = A[0] ? B : 3'b000;
    assign pp1 = A[1] ? B : 3'b000;
    assign pp2 = A[2] ? B : 3'b000;

    assign sum1 = {2'b00, pp0} + {pp1, 1'b0};
    assign sum2 = sum1 + {pp2, 2'b00};

    assign Product = Enable ? 6'b000000 : sum2;

endmodule

// ----------------- MAIN MODULE -----------------
module main_module (
    input wire [2:0] A, B,
    input wire Enable,
    output wire [5:0] Output_Result
);
    wire [3:0] adder_output;
    wire [5:0] multiplier_output;

    kogge_stone_adder_3bit adder_inst (
        .A(A),
        .B(B),
        .Enable(Enable),
        .Sum_Carry(adder_output)
    );

    array_multiplier_3bit multiplier_inst (
        .A(A),
        .B(B),
        .Enable(Enable),
        .Product(multiplier_output)
    );

    assign Output_Result = Enable ? {2'b00, adder_output} : multiplier_output;

endmodule







