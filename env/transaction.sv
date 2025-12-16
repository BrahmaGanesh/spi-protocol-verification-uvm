//=====================================================
// Project     : SPI (Serial Peripheral Interface)
// File        : transaction.sv
// Author      : Brahma Ganesh Katrapalli
// Created On  : 17-12-2025
// Revision    : 1.0
// Description : Transaction class carrying stimulus data
//=====================================================

class spi_transaction extends uvm_sequence_item;

    rand bit [7:0] tx_data;
         bit [7:0] rx_data; 
         bit       MISO;
         bit       MOSI_data;
    rand bit       CS;
  
    function new (string name = "spi_transaction");
        super.new(name);
    endfunction
  
    `uvm_object_utils_begin(spi_transaction)
        `uvm_field_int(tx_data, UVM_ALL_ON)
        `uvm_field_int(rx_data, UVM_ALL_ON)
        `uvm_field_bit(MOSI_data, UVM_ALL_ON)
        `uvm_field_bit(MISO, UVM_ALL_ON)
        `uvm_field_bit(CS, UVM_ALL_ON)
    `uvm_object_utils_end
 
endclass