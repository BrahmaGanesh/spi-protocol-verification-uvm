//=====================================================
// Project     : SPI (Serial Peripheral Interface)
// File        : interface.sv
// Author      : Brahma Ganesh Katrapalli
// Created On  : 20-12-2025
// Revision    : 2.0
// Description : SPI interface definition with signals, modports and assertion
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

    sequence spi_8_active_clks;
        !CS_n ##1 !CS_n ##1 !CS_n ##1 !CS_n
        ##1 !CS_n ##1 !CS_n ##1 !CS_n ##1 !CS_n;
    endsequence

    property spi_rx_valid_after_8_bits;
        @(posedge SCL)
        (rst_n == 0)|-> $fell(CS_n) ##1 spi_8_active_clks |-> rx_valid;
    endproperty

    assert property (spi_rx_valid_after_8_bits)
    else $error("RX_VALID missing after 8-bit SPI transfer");

    property spi_rx_valid_single_pulse;
        @(posedge SCL)
        (rst_n == 0 )|-> $rose(rx_valid) |-> ##1 !rx_valid;
    endproperty

    assert property (spi_rx_valid_single_pulse)
    else $error("RX_VALID asserted while CS inactive");

    property spi_miso_stable_when_idle;
        @(posedge SCL)
        (rst_n==0)|-> (CS_n && $past(CS_n)) |-> $stable(MISO);
    endproperty

    assert property (spi_miso_stable_when_idle)
    else $error("MISO toggled while CS inactive");

endinterface