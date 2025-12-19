//=====================================================
// Project     : SPI
// File        : spi_single_byte_repeat_mode1_test.sv
// Author      : Brahma Ganesh Katrapalli
// Created On  : 19-12-2025
// Revision    : 1.0
// Description : UVM sequence and test for repeated single-byte SPI Mode 1 transfers
//=====================================================

class spi_single_byte_repeat_mode1_sequence extends spi_sequence;
  `uvm_object_utils(spi_single_byte_repeat_mode1_sequence)

    spi_transaction tr;

  function new(string name = "spi_single_byte_repeat_mode1_sequence");
        super.new(name);
    endfunction

    task body();
      repeat(10) begin
        tr = spi_transaction::type_id::create("tr");
        start_item(tr);
            tr.randomize() with {mode == 2'b01;};
        finish_item(tr);
      end
    endtask
endclass

class spi_single_byte_repeat_mode1_test extends base_test;
    `uvm_component_utils(spi_single_byte_repeat_mode1_test)

    spi_single_byte_repeat_mode1_sequence spi_m1;

    function new (string name = "spi_single_byte_repeat_mode1_test", uvm_component parent = null);
        super.new(name, parent);
    endfunction

    task run_phase(uvm_phase phase);
        phase.raise_objection(this);
        spi_m1 = spi_single_byte_repeat_mode1_sequence::type_id::create("spi_m1");
        spi_m1.start(env.m_agent.sqer);
        phase.drop_objection(this);
    
    endtask

endclass