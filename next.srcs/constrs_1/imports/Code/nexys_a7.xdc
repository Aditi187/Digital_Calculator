## ============================================================
## Nexys A7-100T – Vivado XDC Constraint File
## Board: Digilent Nexys A7-100T (XC7A100T-1CSG324C)
## ============================================================

## Clock – 100 MHz on-board oscillator
set_property PACKAGE_PIN E3 [get_ports clk]
set_property IOSTANDARD LVCMOS33 [get_ports clk]
create_clock -period 10.000 [get_ports clk]

## Slide Switches (SW[9:0])
set_property PACKAGE_PIN J15 [get_ports {SW[0]}]
set_property PACKAGE_PIN L16 [get_ports {SW[1]}]
set_property PACKAGE_PIN M13 [get_ports {SW[2]}]
set_property PACKAGE_PIN R15 [get_ports {SW[3]}]
set_property PACKAGE_PIN R17 [get_ports {SW[4]}]
set_property PACKAGE_PIN T18 [get_ports {SW[5]}]
set_property PACKAGE_PIN U18 [get_ports {SW[6]}]
set_property PACKAGE_PIN R13 [get_ports {SW[7]}]
set_property PACKAGE_PIN T8  [get_ports {SW[8]}]
set_property PACKAGE_PIN U8  [get_ports {SW[9]}]
set_property IOSTANDARD LVCMOS33 [get_ports {SW[*]}]

## Seven-Segment Display (Cathodes)
## Mapping: CA, CB, CC, CD, CE, CF, CG
set_property PACKAGE_PIN T10 [get_ports {SEG[0]}]
set_property PACKAGE_PIN R10 [get_ports {SEG[1]}]
set_property PACKAGE_PIN K16 [get_ports {SEG[2]}]
set_property PACKAGE_PIN K13 [get_ports {SEG[3]}]
set_property PACKAGE_PIN P15 [get_ports {SEG[4]}]
set_property PACKAGE_PIN T11 [get_ports {SEG[5]}]
set_property PACKAGE_PIN L18 [get_ports {SEG[6]}]
set_property IOSTANDARD LVCMOS33 [get_ports {SEG[*]}]

## Decimal Point
set_property PACKAGE_PIN H15 [get_ports DP]
set_property IOSTANDARD LVCMOS33 [get_ports DP]

## Seven-Segment Display (Anodes AN[7:0])
set_property PACKAGE_PIN J17 [get_ports {AN[0]}]
set_property PACKAGE_PIN J18 [get_ports {AN[1]}]
set_property PACKAGE_PIN T9  [get_ports {AN[2]}]
set_property PACKAGE_PIN J14 [get_ports {AN[3]}]
set_property PACKAGE_PIN P14 [get_ports {AN[4]}]
set_property PACKAGE_PIN T14 [get_ports {AN[5]}]
set_property PACKAGE_PIN K2  [get_ports {AN[6]}]
set_property PACKAGE_PIN U13 [get_ports {AN[7]}]
set_property IOSTANDARD LVCMOS33 [get_ports {AN[*]}]

## Configuration Bank Voltage Select
set_property CFGBVS VCCO [current_design]
set_property CONFIG_VOLTAGE 3.3 [current_design]
