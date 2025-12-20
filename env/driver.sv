//=====================================================
// Project     : SPI
// File        : driver.sv
// Author      : Brahma Ganesh Katrapalli
// Created On  : 18-12-2025
// Revision    : 1.0
// Description : Driver class driving signals to DUT
//=====================================================

class spi_driver extends uvm_driver#(spi_transaction);
    `uvm_component_utils(spi_driver)

    virtual spi_interface vif;
    spi_transaction tr;

    function new(string name = "spi_driver", uvm_component parent = null);
        super.new(name, parent);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        if(!uvm_config_db#(virtual spi_interface)::get(this,"","vif",vif))
            `uvm_fatal(get_type_name(),"virtual spi_interface not set")
    endfunction

    task mode0_mode3();
        vif.CS_n <= 1;
        vif.tx_data <= tr.tx_data;
        @(negedge vif.SCL);
        vif.CS_n <= 0;
        `uvm_info("DRV",$sformatf("tx_data=%0h rx_data=%0h mode=%0d",vif.tx_data,tr.MOSI_data,vif.mode),UVM_LOW)

        for(int i=7; i>=0; i--) begin
            vif.MOSI <= tr.MOSI_data[i];
            @(posedge vif.SCL);
            @(negedge vif.SCL);
        end

        vif.CS_n <= 1;
    endtask

    task mode1_mode2();
        vif.CS_n <= 1;
        vif.tx_data <= tr.tx_data;
        @(negedge vif.SCL);
        vif.CS_n <= 0;
        `uvm_info("DRV",$sformatf("tx_data=%0h rx_data=%0h mode=%0d",vif.tx_data,tr.MOSI_data,vif.mode),UVM_LOW)

        for(int i=7; i>=0; i--) begin
            vif.MOSI <= tr.MOSI_data[i];
            @(negedge vif.SCL);
            @(posedge vif.SCL);
        end
        @(negedge vif.SCL);
        vif.CS_n <= 1;
    endtask

    task run_phase(uvm_phase phase);
        forever begin
            seq_item_port.get_next_item(tr);
                if((tr.mode==2'b00 && vif.mode==2'b00) || (tr.mode==2'b11 && vif.mode==2'b11)) begin
                    mode0_mode3();
                end
                else  if((tr.mode==2'b01 && vif.mode==2'b01) || (tr.mode==2'b10 && vif.mode==2'b10)) begin
                    mode1_mode2();
                end
            seq_item_port.item_done();
        end
    endtask

endclass


