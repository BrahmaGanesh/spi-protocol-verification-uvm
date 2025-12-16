//=====================================================
// Project     : SPI (Serial Peripheral Interface)
// File        : interface.sv
// Author      : Brahma Ganesh Katrapalli
// Created On  : 17-12-2025
// Revision    : 1.0
// Description : SPI interface definition with signals and modports
//=====================================================

interface spi_interface;
    logic SCL;
    logic resetn;
    logic CS_n;
    logic MOSI;
    logic MISO;
    logic [7:0] tx_data;
    logic [7:0] rx_data;

    modport master  ( output SCL, MOSI, tx_data, CS_n, 
                     input MISO, rx_data
                    ); 

    modport slave   ( input SCL, MOSI, CS_n, tx_data,
                    output MISO, rx_data
                    );

endinterface