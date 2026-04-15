## ============================================================
## Nexys A7-100T  –  Vivado XDC Constraint File
## Project: 4-bit Arithmetic Calculator
##
## Board: Digilent Nexys A7-100T (XC7A100T-1CSG324C)
## Tool : Xilinx Vivado
## ============================================================

## ------------------------------------------------------------
## Clock – 100 MHz on-board oscillator
## ------------------------------------------------------------
set_property PACKAGE_PIN W5   [get_ports clk]
set_property IOSTANDARD  LVCMOS33 [get_ports clk]
create_clock -period 10.000   [get_ports clk]

## ------------------------------------------------------------
## Slide Switches  (SW[9:0])
##   SW[3:0]  = Operand A
##   SW[7:4]  = Operand B
##   SW[9:8]  = Mode select:
##              2'b00 = Addition
##              2'b01 = Subtraction
##              2'b10 = Multiplication
##              2'b11 = Division
## ------------------------------------------------------------
set_property PACKAGE_PIN V17  [get_ports {SW[0]}]
set_property PACKAGE_PIN V16  [get_ports {SW[1]}]
set_property PACKAGE_PIN W16  [get_ports {SW[2]}]
set_property PACKAGE_PIN W17  [get_ports {SW[3]}]
set_property PACKAGE_PIN W15  [get_ports {SW[4]}]
set_property PACKAGE_PIN V15  [get_ports {SW[5]}]
set_property PACKAGE_PIN W14  [get_ports {SW[6]}]
set_property PACKAGE_PIN W13  [get_ports {SW[7]}]
set_property PACKAGE_PIN V2   [get_ports {SW[8]}]
set_property PACKAGE_PIN T3   [get_ports {SW[9]}]

set_property IOSTANDARD LVCMOS33 [get_ports {SW[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {SW[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {SW[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {SW[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {SW[4]}]
set_property IOSTANDARD LVCMOS33 [get_ports {SW[5]}]
set_property IOSTANDARD LVCMOS33 [get_ports {SW[6]}]
set_property IOSTANDARD LVCMOS33 [get_ports {SW[7]}]
set_property IOSTANDARD LVCMOS33 [get_ports {SW[8]}]
set_property IOSTANDARD LVCMOS33 [get_ports {SW[9]}]

## ------------------------------------------------------------
## Seven-Segment Display – Cathodes (SEG, shared bus)
## Nexys A7 segment order: {CA, CB, CC, CD, CE, CF, CG}
##   SEG[0] = CA (segment a – top)
##   SEG[1] = CB (segment b – top-right)
##   SEG[2] = CC (segment c – bottom-right)
##   SEG[3] = CD (segment d – bottom)
##   SEG[4] = CE (segment e – bottom-left)
##   SEG[5] = CF (segment f – top-left)
##   SEG[6] = CG (segment g – middle)
## Active-HIGH on Nexys A7
## ------------------------------------------------------------
set_property PACKAGE_PIN W7  [get_ports {SEG[0]}]
set_property PACKAGE_PIN W6  [get_ports {SEG[1]}]
set_property PACKAGE_PIN U8  [get_ports {SEG[2]}]
set_property PACKAGE_PIN V8  [get_ports {SEG[3]}]
set_property PACKAGE_PIN U5  [get_ports {SEG[4]}]
set_property PACKAGE_PIN V5  [get_ports {SEG[5]}]
set_property PACKAGE_PIN U7  [get_ports {SEG[6]}]

set_property IOSTANDARD LVCMOS33 [get_ports {SEG[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {SEG[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {SEG[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {SEG[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {SEG[4]}]
set_property IOSTANDARD LVCMOS33 [get_ports {SEG[5]}]
set_property IOSTANDARD LVCMOS33 [get_ports {SEG[6]}]

## ------------------------------------------------------------
## Seven-Segment Display – Decimal Point
## Active-LOW  (we drive it high = OFF)
## ------------------------------------------------------------
set_property PACKAGE_PIN V7  [get_ports DP]
set_property IOSTANDARD LVCMOS33 [get_ports DP]

## ------------------------------------------------------------
## Seven-Segment Display – Anodes  AN[7:0]
## AN[7] = leftmost digit,  AN[0] = rightmost digit
## Active-LOW (0 = digit selected/ON)
## ------------------------------------------------------------
set_property PACKAGE_PIN U2  [get_ports {AN[0]}]
set_property PACKAGE_PIN U4  [get_ports {AN[1]}]
set_property PACKAGE_PIN V4  [get_ports {AN[2]}]
set_property PACKAGE_PIN W4  [get_ports {AN[3]}]
set_property PACKAGE_PIN W3  [get_ports {AN[4]}]
set_property PACKAGE_PIN V3  [get_ports {AN[5]}]
set_property PACKAGE_PIN V1  [get_ports {AN[6]}]
set_property PACKAGE_PIN U1  [get_ports {AN[7]}]

set_property IOSTANDARD LVCMOS33 [get_ports {AN[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {AN[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {AN[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {AN[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {AN[4]}]
set_property IOSTANDARD LVCMOS33 [get_ports {AN[5]}]
set_property IOSTANDARD LVCMOS33 [get_ports {AN[6]}]
set_property IOSTANDARD LVCMOS33 [get_ports {AN[7]}]
