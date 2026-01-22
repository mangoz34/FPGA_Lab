# ============================================================
# Create work library
# ============================================================
vlib work

# ============================================================
# Compile needed files
# (Only modules used in 1.3)
# ============================================================
vlog "./hex7seg.sv"
vlog "./ram32x4_ff.sv"
vlog "./DE1_SoC.sv"
vlog "./DE1_SoC_testbench.sv"

# ============================================================
# Launch simulator
# ============================================================
vsim -voptargs="+acc" -t 1ns work.DE1_SoC_testbench

# ============================================================
# Add waveform signals
# ============================================================

# Top-level
add wave -divider "Testbench Inputs"
add wave sim:/DE1_SoC_testbench/CLOCK_50
add wave sim:/DE1_SoC_testbench/KEY
add wave sim:/DE1_SoC_testbench/SW

# Outputs
add wave -divider "Top-level Outputs"
add wave sim:/DE1_SoC_testbench/HEX0
add wave sim:/DE1_SoC_testbench/HEX2
add wave sim:/DE1_SoC_testbench/HEX4
add wave sim:/DE1_SoC_testbench/HEX5

# RAM Internal Signals
add wave -divider "RAM internals"
add wave sim:/DE1_SoC_testbench/dut/ram/memory_array
add wave sim:/DE1_SoC_testbench/dut/ram/addr
add wave sim:/DE1_SoC_testbench/dut/ram/data_in
add wave sim:/DE1_SoC_testbench/dut/ram/data_out
add wave sim:/DE1_SoC_testbench/dut/ram/we
add wave sim:/DE1_SoC_testbench/dut/ram/clk

# ============================================================
# Wave viewer setup
# ============================================================
view wave
view structure
view signals

configure wave -namecolwidth 200
configure wave -valuecolwidth 120

# ============================================================
# Run simulation
# ============================================================
run -all

