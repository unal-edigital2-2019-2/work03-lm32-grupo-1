# Autogenerated by LiteX / git: 2638393b
set -e
source /opt/Xilinx/14.7/ISE_DS/settings64.sh

xst -ifn top.xst

netgen -ofmt verilog -w -sim top.ngc top_synth.v

ngdbuild  -uc top.ucf top.ngc top.ngd

map -ol high -w -o top_map.ncd top.ngd top.pcf
par -ol high -w top_map.ncd top.ncd top.pcf
bitgen -g Binary:Yes -w top.ncd top.bit