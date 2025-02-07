IVERILOG = iverilog
IVERILOG_FLAGS = -g2012
VVP = vvp

LAST_EDITED_FILE = $(shell ls -t *.sv | grep -v '_tb.sv' | head -n 1)
TESTBENCH_FILE = $(patsubst %.sv,%_tb.sv,$(LAST_EDITED_FILE))
MODULE_NAME = $(basename $(LAST_EDITED_FILE))
OUTPUT_FILE = $(MODULE_NAME)_tb

all: run

compile:
	@if [ -z "$(LAST_EDITED_FILE)" ]; then \
		echo "Error: No source file found."; \
		exit 1; \
	fi
	@echo "Compiling $(LAST_EDITED_FILE) and $(TESTBENCH_FILE)..."
	$(IVERILOG) $(IVERILOG_FLAGS) -o $(OUTPUT_FILE) $(LAST_EDITED_FILE) $(TESTBENCH_FILE)

run: compile
	@echo "Running $(OUTPUT_FILE)..."
	$(VVP) $(OUTPUT_FILE)
	@echo "Waveform file generated: waveform.vcd"
	@if ! pgrep -f "code .*waveform.vcd" > /dev/null; then \
		echo "Opening waveform.vcd in VS Code..."; \
		code waveform.vcd; \
	else \
		echo "waveform.vcd is already open in VS Code."; \
	fi

clean:
	@echo "Cleaning up..."
	rm -f *.vcd $(OUTPUT_FILE)

.PHONY: all compile run clean
