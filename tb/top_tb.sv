//=====================================================
// Project     : SPI
// File        : top_tb.sv
// Author      : Brahma Ganesh Katrapalli
// Created On  : 18-12-2025
// Revision    : 1.0
// Description : Top-level testbench connecting DUT and environment
//=====================================================

`include "interface.sv"
`include "package.sv"

module tb;

    import pkg::*;

    spi_interface vif();

    spi_slave #(0,0) DUT(
        .SCL(vif.SCL),
        .rst_n(vif.rst_n),
        .CS_n(vif.CS_n),
        .MOSI(vif.MOSI),
        .MISO(vif.MISO),
        .tx_data(vif.tx_data),
        .rx_data(vif.rx_data),
        .rx_valid(vif.rx_valid)
    );

    initial begin
        vif.SCL = 1'b0;
        forever #5 vif.SCL = ~vif.SCL;
    end

    initial begin
        vif.mode = 2'b00;
        vif.rst_n = 1'b0;
        #5 vif.rst_n = 1'b1;
    end

    initial begin
        $dumpfile("waveform.vcd");
        $dumpvars(0,tb);
    end

    initial begin
        uvm_config_db#(virtual spi_interface)::set(null, "*", "vif", vif);
        run_test();
    end

endmodule
