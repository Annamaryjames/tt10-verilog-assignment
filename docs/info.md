<!---

This file is used to generate your project datasheet. Please fill in the information below and delete any unused
sections.

You can also include images in this folder and reference them in the markdown. Each image must be less than
512 kb in size, and the combined size of all images must be less than 1 MB.
-->

## How it works

This project implements a 3-bit Kogge-Stone Adder and a 3-bit Array Multiplier in Verilog. The adder and multiplier share the same input interface and are selected based on the Enable signal

## How to test


Provide 3-bit inputs for ui[0] to ui[2] and ui[3] to ui[5].Set ui[6] (Enable signal) to 1 to select the multiplier or to 0 to select the adder. Can run a Verilog simulation using a testbench to provide the necessary inputs and observe the outputs.


## External hardware

no
