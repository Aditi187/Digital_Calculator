## SWITCHES (A)
set_property PACKAGE_PIN J15 [get_ports {A[0]}]
set_property PACKAGE_PIN L16 [get_ports {A[1]}]
set_property PACKAGE_PIN M13 [get_ports {A[2]}]
set_property PACKAGE_PIN R15 [get_ports {A[3]}]

## SWITCHES (B)
set_property PACKAGE_PIN R17 [get_ports {B[0]}]
set_property PACKAGE_PIN T18 [get_ports {B[1]}]
set_property PACKAGE_PIN U18 [get_ports {B[2]}]
set_property PACKAGE_PIN R13 [get_ports {B[3]}]

## SELECT (3 switches)
set_property PACKAGE_PIN T8  [get_ports {sel[0]}]
set_property PACKAGE_PIN U8  [get_ports {sel[1]}]
set_property PACKAGE_PIN R16 [get_ports {sel[2]}]

## OUTPUT LEDs
set_property PACKAGE_PIN H17 [get_ports {result[0]}]
set_property PACKAGE_PIN K15 [get_ports {result[1]}]
set_property PACKAGE_PIN J13 [get_ports {result[2]}]
set_property PACKAGE_PIN N14 [get_ports {result[3]}]
set_property PACKAGE_PIN R18 [get_ports {result[4]}]
set_property PACKAGE_PIN V17 [get_ports {result[5]}]
set_property PACKAGE_PIN U17 [get_ports {result[6]}]
set_property PACKAGE_PIN U16 [get_ports {result[7]}]

## OVERFLOW LED
set_property PACKAGE_PIN H16 [get_ports overflow]

## STANDARD
set_property IOSTANDARD LVCMOS33 [get_ports *]