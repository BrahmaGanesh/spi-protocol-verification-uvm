//=====================================================
// Project     : SPI
// File        : spi_single_byte_mode2_test.sv
// Author      : Brahma Ganesh Katrapalli
// Created On  : 19-12-2025
// Revision    : 1.0
// Description : UVM sequence and test for single-byte SPI Mode 2 transfer
//=====================================================

class spi_mode2_sequence extends spi_sequence;
    `uvm_object_utils(spi_mode2_sequence)

    spi_transaction tr;

    function new(string name = "spi_mode2_sequence");
        super.new(name);
    endfunction

    task body();
        tr = spi_transaction::type_id::create("tr");
        start_item(tr);
            tr.randomize() with {mode == 2'b10;};
        finish_item(tr);
    endtask
endclass

class spi_mode2_test extends base_test;
    `uvm_component_utils(spi_mode2_test)

    spi_mode2_sequence spi_m2;

    function new (string name = "spi_mode2_test", uvm_component parent = null);
        super.new(name, parent);
    endfunction

    task run_phase(uvm_phase phase);
        phase.raise_objection(this);
        spi_m2 = spi_mode2_sequence::type_id::create("spi_m2");
        spi_m2.start(env.m_agent.sqer);
        phase.drop_objection(this);
    
    endtask

endclass