//=====================================================
// Project     : SPI
// File        : spi_single_byte_mode0_test.sv
// Author      : Brahma Ganesh Katrapalli
// Created On  : 19-12-2025
// Revision    : 1.0
// Description : UVM sequence and test for back-to-back single-byte SPI Mode 0 transfers
//=====================================================

class spi_back_to_back_sequence extends spi_sequence;
    `uvm_object_utils(spi_back_to_back_sequence)

    spi_transaction tr;

    function new(string name = "spi_back_to_back_sequence");
        super.new(name);
    endfunction

    task body();
        tr = spi_transaction::type_id::create("tr1");
        assert(tr.randomize() with {
            tx_data == 8'h45;
            MOSI_data == 8'h55;
            mode == 2'b00;
        });
        start_item(tr);
        finish_item(tr);
        #10;
        tr = spi_transaction::type_id::create("t2");
        assert(tr.randomize() with {
            tx_data == 8'h52;
            MOSI_data == 8'h65;
            mode == 2'b00;
        });
        start_item(tr);
        finish_item(tr);
    endtask
endclass

class spi_back_to_back_test extends base_test;
    `uvm_component_utils(spi_back_to_back_test)

    spi_back_to_back_sequence spi_m0;

    function new (string name = "spi_back_to_back_test", uvm_component parent = null);
        super.new(name, parent);
    endfunction

    task run_phase(uvm_phase phase);
        phase.raise_objection(this);
        spi_m0 = spi_back_to_back_sequence::type_id::create("spi_m0");
        spi_m0.start(env.m_agent.sqer);
        phase.drop_objection(this);
    
    endtask

endclass