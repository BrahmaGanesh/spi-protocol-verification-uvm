//=====================================================
// Project     : SPI
// File        : coverage.sv
// Author      : Brahma Ganesh Katrapalli
// Created On  : 20-12-2025
// Revision    : 1.0
// Description : SPI Functional Coverage class using UVM 
// Captures mode, tx_data, CS_n, rx_valid, 
// and cross coverage for verification 
//=====================================================

class spi_coverage extends uvm_component;
    `uvm_component_utils(spi_coverage)
    spi_transaction tr;
    
    uvm_analysis_imp #(spi_transaction, spi_coverage) cov_export;
    
        function new(string name = "spi_coverage", uvm_component parent = null);
        super.new(name, parent);
        cov_export = new("cov_export", this);
        spi_cg=new();
        endfunction
        covergroup spi_cg;
            mode_cp : coverpoint tr.mode{
                bins m0 = {2'b00};
                bins m1 = {2'b01};
                bins m2 = {2'b10};
                bins m3 = {2'b11};}
      
            tx_cp : coverpoint tr.tx_data {
                bins zero = {8'h00};
                bins ones = {8'hFF};
                bins mid  = {[8'h01:8'hFE]};
                }

            cs_cp : coverpoint tr.CS_n {
                bins inactive = {1};
                }

            rx_cp : coverpoint tr.rx_valid {
                bins valid = {1};
                }
            mode_tx_cross : cross mode_cp, tx_cp;
        endgroup

  
    function write(spi_transaction tr);
        this.tr = tr;
        spi_cg.sample();
    endfunction
  
    function void report_phase(uvm_phase phase);
        super.report_phase(phase);
        
        `uvm_info(get_type_name(),$sformatf("SPI Functional Coverage mode_cp = %0.2f %%", spi_cg.mode_cp.get_coverage()),UVM_LOW)
        `uvm_info(get_type_name(),$sformatf("SPI Functional Coverage tx_cp = %0.2f %%", spi_cg.tx_cp.get_coverage()),UVM_LOW)
        `uvm_info(get_type_name(),$sformatf("SPI Functional Coverage cs_cp = %0.2f %%", spi_cg.cs_cp.get_coverage()),UVM_LOW) 
        `uvm_info(get_type_name(),$sformatf("SPI Functional Coverage rx_cp = %0.2f %%", spi_cg.rx_cp.get_coverage()),UVM_LOW)
        `uvm_info(get_type_name(),$sformatf("SPI Functional Coverage mode_tx_cross = %0.2f %%", spi_cg.mode_tx_cross.get_coverage()),UVM_LOW)
        `uvm_info(get_type_name(),$sformatf("SPI Functional Coverage = %0.2f %%", spi_cg.get_coverage()),UVM_LOW)
    endfunction
  
endclass
  