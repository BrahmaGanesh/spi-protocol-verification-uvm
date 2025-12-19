//=====================================================
// Project     : SPI
// File        : package.sv
// Author      : Brahma Ganesh Katrapalli
// Created On  : 19-12-2025
// Revision    : 1.0
// Description : UVM package including all SPI verification components,
//               sequences, agents, environment, and test cases
//=====================================================

package pkg;
    import uvm_pkg::*;
    `include "uvm_macros.svh"

  	`include "transaction.sv"
  	`include "sequence.sv"
  	`include "sequencer.sv"
  	`include "driver.sv"
  	`include "monitor.sv"
	`include "scoreboard.sv";
    `include "agent.sv";
	`include "env.sv";

	`include "base_test.sv"
    `include "spi_back_to_back_test.sv"

	`include "spi_single_byte_mode0_test.sv"
    `include "spi_single_byte_mode1_test.sv"
    `include "spi_single_byte_mode2_test.sv"
    `include "spi_single_byte_mode3_test.sv"

    `include "spi_single_byte_repeat_mode0_test.sv"
    `include "spi_single_byte_repeat_mode1_test.sv"
    `include "spi_single_byte_repeat_mode2_test.sv"
    `include "spi_single_byte_repeat_mode3_test.sv"

endpackage