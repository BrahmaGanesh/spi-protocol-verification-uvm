# SPI Slave Verification – UVM Framework

A **production-style UVM verification environment** for an SPI Slave supporting **all four SPI modes (Mode 0–3)** with functional coverage, scoreboard checking, and reusable test architecture.

> **Focus**: ASIC Design Verification, SystemVerilog, UVM, protocol-level validation

---

## 📌 Overview

This project verifies a **parameterized SPI Slave RTL** using a complete **UVM-based testbench**.  
All SPI clock modes (CPOL/CPHA combinations) are exercised with directed and repeated tests, ensuring protocol compliance and data integrity.

**Author**: Brahma Ganesh Katrapalli  
**Domain**: ASIC Design Verification  
**Methodology**: SystemVerilog + UVM

---

## 🔧 Features

### SPI Protocol Support
- Mode 0 (CPOL=0, CPHA=0)
- Mode 1 (CPOL=0, CPHA=1)
- Mode 2 (CPOL=1, CPHA=0)
- Mode 3 (CPOL=1, CPHA=1)

### UVM Environment
- Modular agent-based architecture
- Active driver / passive monitor separation
- Scoreboard with automatic data comparison
- Reusable sequences and tests
- Clean phase-based execution

### Functional Coverage
- SPI mode coverage (0–3)
- TX data pattern coverage (0x00, 0xFF, mid-range)
- RX valid and chip-select behavior
- Cross coverage: **Mode × TX data**

---

## 🧱 Project Structure

```
SPI_Verification_Framework/
├── docs/
│   ├── coverage_summary.png
│   ├── waveform.png
│   └── sim_log.txt
├── RTL/
│   └── spi_top_slave.sv
│
├── TB/
│   └── top_tb.sv
│
├── env/
│   ├── interface.sv
│   ├── transaction.sv
│   ├── sequence.sv
│   ├── sequencer.sv
│   ├── driver.sv
│   ├── monitor.sv
│   ├── scoreboard.sv
│   ├── coverage.sv
│   ├── agent.sv
│   └── env.sv
│   │
├── tests/
│   ├── base_test.sv
│   ├── spi_single_byte_mode0_test.sv
│   ├── spi_single_byte_mode1_test.sv
│   ├── spi_single_byte_mode2_test.sv
│   ├── spi_single_byte_mode3_test.sv
│   ├── spi_single_byte_repeat_mode0_tests.sv
│   ├── spi_single_byte_repeat_mode0_tests.sv
│   ├── spi_single_byte_repeat_mode0_tests.sv
│   ├── spi_single_byte_repeat_mode0_tests.sv
│   └── spi_back_to_back_test.sv
│
├── waves/
│   ├── spi_single_byte_mode0_test.png
│   ├── spi_single_byte_mode1_test.png
│   ├── spi_single_byte_mode2_test.png
│   ├── spi_single_byte_mode3_test.png
│   ├── spi_single_byte_repeat_mode0_tests.png
│   ├── spi_single_byte_repeat_mode0_tests.png
│   ├── spi_single_byte_repeat_mode0_tests.png
│   ├── spi_single_byte_repeat_mode0_tests.png
│   └── spi_back_to_back_test.png
│
└── README.md
```

---

## 🔍 RTL Summary

**Module**: `spi_tob_slave`

- 8-bit serial data transfer
- State-machine driven (IDLE / TRANSFER)
- Mode-dependent clock edge sampling
- RX valid asserted after full-byte reception
- Parameterized CPOL and CPHA

---

## 🧪 Verification Architecture

### Transaction
```systemverilog
class spi_transaction extends uvm_sequence_item;
  rand bit [7:0] tx_data;
  rand bit [1:0] mode;
       bit [7:0] rx_data;
       bit       rx_valid;
endclass
```

### Driver
- Drives MOSI, SCL, CS_n based on selected SPI mode
- Handles edge-sensitive behavior per CPOL/CPHA
- Supports back-to-back and repeated transfers

### Monitor
- Passively samples MOSI/MISO
- Detects transfer completion via rx_valid
- Sends collected transactions to scoreboard and coverage

### Scoreboard
- Compares expected TX data with observed RX/MISO
- Reports mismatches with transaction-level detail

---

## 📊 Coverage Model

| Coverpoint | Details |
|-----------|---------|
| `mode_cp` | All 4 SPI modes exercised |
| `tx_cp` | Data pattern: 0x00, 0xFF, mid-range |
| `rx_cp` | RX valid behavior validation |
| `cs_cp` | Chip-select activity |
| `mode_tx_cross` | Mode × data pattern correlation |

> **Note**: Individual tests achieve partial coverage (~70%).  
> Full functional coverage closure is obtained through regression by running all mode-specific and repeated-transfer tests together.

**Target Coverage**: ≥ 90%  
**Achieved**: 100% functional coverage across full regression

---

## ▶️ Simulation

### Compile
```bash
vcs -sverilog -full64 \
    -timescale=1ns/1ps \
    -f rtl_filelist.f \
    -f tb_filelist.f
```

### Run
```bash
./simv +UVM_TESTNAME=spi_mode0_test
./simv +UVM_TESTNAME=spi_mode3_test
```

### Waveform
```bash
dve -full64 -vpd waveform.vcd &
```

---

## ✅ Verification Results

- All SPI modes verified (Mode 0–3)
- 10+ SPI transactions executed across directed and repeated tests
- Zero scoreboard mismatches
- 100% functional coverage achieved

This demonstrates protocol-aware stimulus generation and clock-edge–accurate sampling for CPOL/CPHA variations.

---

## 🚀 Why This Project Matters

This project demonstrates:
- Real-world UVM testbench architecture
- Protocol-driven verification (not toy examples)
- Coverage-driven validation
- Debug-ready, scalable environment

Suitable for **ASIC DV fresher / junior roles** and interview discussions.

---

**Status**: Complete & Interview-Ready  
**Focus Role**: ASIC Design Verification Engineer
