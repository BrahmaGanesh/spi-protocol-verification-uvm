//=====================================================
// Project     : SPI
// File        : env.sv
// Author      : Brahma Ganesh Katrapalli
// Created On  : 18-12-2025
// Revision    : 1.0
// Description : Environment class instantiating agent, scoreboard, coverage
//=====================================================

class spi_env extends uvm_env;
    `uvm_component_utils(spi_env)

    spi_agent m_agent;
    spi_scoreboard sbc;

    function new(string name = "spi_env", uvm_component parent = null);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        m_agent     = spi_agent::type_id::create("m_agent", this);
        sbc         = spi_scoreboard::type_id::create("sbc", this);

    endfunction

    function void connect_phase(uvm_phase phase);

        m_agent.mon.mon_ap.connect(sbc.sb_export);
    
    endfunction

endclass

