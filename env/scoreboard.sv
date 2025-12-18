//=====================================================
// Project     : SPI
// File        : scoreboard.sv
// Author      : Brahma Ganesh Katrapalli
// Created On  : 18-12-2025
// Revision    : 1.0
// Description : Scoreboard comparing expected vs actual DUT outputs
//=====================================================

class spi_scoreboard extends uvm_component;
    `uvm_component_utils(spi_scoreboard)

    uvm_analysis_imp #( spi_transaction, spi_scoreboard) sb_export;

    int total_reads         = 0;
    int matched_reads       = 0;
    int mismatched_reads    = 0;

    function new ( string name = "spi_scoreboard", uvm_component parent = null);
        super.new(name, parent);

        sb_export = new ("sb_export", this);
    endfunction

    task write( spi_transaction tr);
        if(tr.rx_valid)begin
            total_reads++;
            if(tr.MISO_data == tr.tx_data) begin
                matched_reads++;
                `uvm_info(get_type_name(), $sformatf("Transaction matched: 0x%0h", tr.MISO_data), UVM_LOW)
            end
            else begin
            mismatched_reads++;
                `uvm_error(get_type_name(), $sformatf("Transaction mismatch! RX: 0x%0h, Expected: 0x%0h", tr.MISO_data, tr.tx_data))
            end
        end
    endtask

    function void report_phase(uvm_phase phase);
        super.report_phase(phase);

        `uvm_info(get_type_name(),$sformatf("Total Reads = %0d",total_reads),UVM_LOW)
        `uvm_info(get_type_name(),$sformatf("Total PASS = %0d",matched_reads),UVM_LOW)
        `uvm_info(get_type_name(),$sformatf("Total FAIL = %0d",mismatched_reads),UVM_LOW)
    endfunction

endclass