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
    logic rst_n;
    logic CS_n;
    logic MOSI;
    logic MISO;
    logic rx_valid;
    logic [7:0] tx_data;
    logic [7:0] rx_data;
    logic [1:0] mode;

    modport master  ( output SCL, CS_n, MOSI, tx_data, 
                     input rx_data, MISO, rx_valid
                    ); 

    modport slave   ( input rst_n,SCL, CS_n, MOSI, tx_data,
                    output rx_data, MISO, rx_valid
                    );

endinterface