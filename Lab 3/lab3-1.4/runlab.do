# ============================================================
# Create / map libraries
# ============================================================

vlib work
vmap work work

# Quartus 24.1 Lite simulation libraries
vlib altera_mf
vmap altera_mf "C:/intelFPGA_lite/24.1std/quartus/eda/sim_lib/altera_mf"

vlib lpm
vmap lpm "C:/intelFPGA_lite/24.1std/quartus/eda/sim_lib/lpm"

# (Optional but recommended) include other simulation libs
vlib sgate
vmap sgate "C:/intelFPGA_lite/24.1std/quartus/eda/sim_lib/sgate"

vlib altera_primitives
vmap altera_primitives "C:/intelFPGA_lite/24.1std/quartus/eda/sim_lib/altera_primitives"

# ============================================================
# Compile design files
# ============================================================

vlog DE1_SoC.sv
vlog hex7seg.sv
vlog button_input.sv
vlog counter.sv
vlog ram32x4port2.v
vlog DE1_SoC_testbench.sv

# ============================================================
# Launch simulation
# ============================================================

vsim -voptargs="+acc" work.DE1_SoC_testbench

# Add waves
add wave -r /*

run -all
