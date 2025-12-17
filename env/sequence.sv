//=====================================================
// Project     : SPI (Serial Peripheral Interface)
// File        : sequence.sv
// Author      : Brahma Ganesh Katrapalli
// Created On  : 18-12-2025
// Revision    : 1.0
// Description : Sequence class generating transaction streams
//=====================================================

class spi_sequence extends uvm_sequence#(spi_transaction);
    `uvm_object_utils(spi_sequence)
  	
    spi_transaction tr;
  	
    function new (string name="spi_sequence");
        super.new(name);
    endfunction
  
    virtual task body();
    endtask
  
endclass