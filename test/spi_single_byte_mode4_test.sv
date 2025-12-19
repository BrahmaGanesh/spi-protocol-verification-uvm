//=====================================================
// Project     : SPI
// File        : spi_single_byte_mode3_test.sv
// Author      : Brahma Ganesh Katrapalli
// Created On  : 19-12-2025
// Revision    : 1.0
// Description : UVM sequence and test for single-byte SPI Mode 3 transfer
//=====================================================

class spi_mode3_sequence extends spi_sequence;
    `uvm_object_utils(spi_mode3_sequence)

    spi_transaction tr;

    function new(string name = "spi_mode3_sequence");
        super.new(name);
    endfunction

    task body();
        tr = spi_transaction::type_id::create("tr");
        start_item(tr);
            tr.randomize() with {mode == 2'b11;};
        finish_item(tr);
    endtask
endclass

class spi_mode3_test extends base_test;
    `uvm_component_utils(spi_mode3_test)

    spi_mode3_sequence spi_m3;

    function new (string name = "spi_mode3_test", uvm_component parent = null);
        super.new(name, parent);
    endfunction

    task run_phase(uvm_phase phase);
        phase.raise_objection(this);
        spi_m3 = spi_mode3_sequence::type_id::create("spi_m3");
        spi_m3.start(env.m_agent.sqer);
        phase.drop_objection(this);
    
    endtask

endclass