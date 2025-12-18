//=====================================================
// Project     : SPI
// File        : agent.sv
// Author      : Brahma Ganesh Katrapalli
// Created On  : 18-12-2025
// Revision    : 1.0
// Description : Agent class encapsulating driver, monitor, sequencer
//=====================================================

class spi_agent extends uvm_agent;
    `uvm_component_utils(spi_agent)

    spi_driver drv;
    spi_monitor mon;
    spi_sequencer sqer;

    uvm_active_passive_enum is_active = UVM_ACTIVE;

    function new(string name = "spi_agent", uvm_component parent = null);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        drv = spi_driver::type_id::create("drv", this);
        mon = spi_monitor::type_id::create("mon", this);
        sqer = spi_sequencer::type_id::create("sqer", this);

    endfunction

    function void connect_phase(uvm_phase phase);
    
        if(is_active == UVM_ACTIVE) begin
            drv.seq_item_port.connect(sqer.seq_item_export);
        end

    endfunction

endclass