//=====================================================
// Project     : SPI
// File        : monitor.sv
// Author      : Brahma Ganesh Katrapalli
// Created On  : 18-12-2025
// Revision    : 1.0
// Description : Monitor class observing DUT signals and creating transactions
//=====================================================

class spi_monitor extends uvm_monitor;
    `uvm_component_utils(spi_monitor)

    virtual spi_interface vif;
    spi_transaction tr;
    bit [7:0] MOSI_shift;
    bit [7:0] MISO_shift;
    int bit_count;

    uvm_analysis_port #(spi_transaction) mon_ap;

    function new (string name = "spi_monitor", uvm_component parent = null);
        super.new(name, parent);

        mon_ap = new("mon_ap", this);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        if(!uvm_config_db#(virtual spi_interface)::get(this,"","vif",vif))
            `uvm_fatal(get_type_name(),"virtual spi_interface not set")
    endfunction

    task mode0_mode3();
        while(bit_count < 8) begin
            @(posedge vif.SCL);
            MOSI_shift = {MOSI_shift, vif.MOSI};
            MISO_shift = {MISO_shift, vif.MISO};
            bit_count++;
        end
        @(negedge vif.SCL);
    endtask

    task mode1_mode2();
        while(bit_count < 8) begin
            @(negedge vif.SCL);
            MOSI_shift = {MOSI_shift, vif.MOSI};
            MISO_shift = {MISO_shift, vif.MISO};
            bit_count++;
        end
        @(posedge vif.SCL);
    endtask

    task run_phase(uvm_phase phase);
        
        @(posedge vif.rst_n);

        forever begin
            @(negedge vif.CS_n);

            tr = spi_transaction::type_id::create("tr");
            
            MOSI_shift = 0;
            MISO_shift = 0;
            bit_count = 0;
            
            if((vif.mode == 2'b00) || (vif.mode == 2'b11)) begin
                mode0_mode3();
            end
            else  if((vif.mode == 2'b01) || (vif.mode == 2'b10)) begin
                mode1_mode2();
            end
     

            if (vif.rx_valid) begin
                tr.tx_data    = vif.tx_data;
                tr.MOSI_data  = MOSI_shift;
                tr.MISO_data  = MISO_shift;
                tr.rx_valid   = vif.rx_valid;

                `uvm_info("SPI_MON",
                $sformatf("Captured MOSI=0x%0h MISO=0x%0h RX_VALID=%0b",
                            tr.MOSI_data, tr.MISO_data, tr.rx_valid),
                UVM_LOW)

                mon_ap.write(tr);
            end

            @(posedge vif.CS_n);
        end
    endtask
endclass
