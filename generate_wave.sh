ghdl -a adder_full.vhd subtractor_full.vhd alu.vhd alu_n.vhd register.vhd controller.vhd bench.vhdl && ghdl -e test_bench && ghdl -r  test_bench --stop-time=1200ns --vcd=waveform.vcd && gtkwave waveform.vcd