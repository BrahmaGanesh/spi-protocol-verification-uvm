//=====================================================
// Project     : SPI (Serial Peripheral Interface)
// File        : slave.sv
// Author      : Brahma Ganesh Katrapalli
// Created On  : 17-12-2025
// Revision    : 2.0
// Description : SPI Slave module implementation
//=====================================================

module spi_slave #(
    parameter CPOL = 0,
    parameter CPHA = 0
    )(
        input   logic rst_n,
        input   logic SCL,
        input   logic CS_n,
        input   logic MOSI,
        input   logic [7:0] tx_data,
        output  logic [7:0] rx_data,
        output  logic MISO,
        output  logic rx_valid
    );

        typedef enum logic { IDLE, TRANSFER } state_t;
        state_t state, next_state;

        logic   [7:0] tx_shift;
        logic   [7:0] rx_shift;
        logic   [2:0] bit_count;

        generate
            if((CPOL == 0 && CPHA == 0) || (CPOL == 1 && CPHA == 1)) begin
                always_ff @( posedge SCL or negedge rst_n) begin
                    if(!rst_n) begin
                        state       <= IDLE;
                        bit_count   <= 3'd0;
                        rx_shift    <= 8'd0;
                        rx_valid    <= 1'b0;
                        rx_data     <= 8'd0;
                    end
                    else begin
                        state   <= next_state;
                        case(state)
                            IDLE        : begin
                                            bit_count <= 0;
                                            if(!CS_n) rx_valid <= 1'b0;
                                         end
                            TRANSFER    : begin
                                            rx_shift <= {rx_shift[6:0], MOSI};
                                            bit_count++;
                                            if(bit_count == 3'd7) begin
                                                rx_data <= {rx_shift[6:0],MOSI};
                                                rx_valid <= 1'b1;
                                            end
                                          end
                        endcase
                    end
                end
            end
            else begin
                always_ff @( negedge SCL or negedge rst_n) begin
                    if(!rst_n) begin
                        state       <= IDLE;
                        bit_count   <= 3'd0;
                        rx_shift    <= 8'd0;
                        rx_valid    <= 1'b0;
                    end
                    else begin
                        state   <= next_state;
                        case(state)
                            IDLE        : begin
                                            bit_count <= 0;
                                            if(!CS_n) rx_valid <= 1'b0;
                                          end
                            TRANSFER    : begin
                                            rx_shift <= {rx_shift[6:0], MOSI};
                                            bit_count++;
                                            if(bit_count == 3'd7) begin
                                                rx_data <= {rx_shift[6:0],MOSI};
                                                rx_valid <= 1'b1;
                                            end
                                          end
                        endcase
                    end
                end
            end
        endgenerate

        generate
             if((CPOL == 0 && CPHA == 0) || (CPOL == 1 && CPHA == 1)) begin
                always_ff @(negedge SCL or negedge rst_n) begin
                    if (!rst_n) begin
                        tx_shift <= 8'd0;
                        MISO     <= 1'b0;
                    end
                    else if (CS_n && state == IDLE) begin
                            tx_shift <= tx_data;   
                            MISO     <= tx_data[7];
                    end
                    else if (!CS_n && state == TRANSFER) begin
                            MISO     <= tx_shift[6];
                            tx_shift <= {tx_shift[6:0], 1'b0};
                    end
                end
             end
             else begin
                always_ff @(posedge SCL or negedge rst_n) begin
                    if (!rst_n) begin
                        tx_shift <= 8'd0;
                        MISO     <= 1'b0;
                    end
                    else if (CS_n && state == IDLE) begin
                            tx_shift <= tx_data;  
                            MISO     <= tx_data[7];
                    end
                    else if (!CS_n && state == TRANSFER) begin
                            MISO     <= tx_shift[6];
                            tx_shift <= {tx_shift[6:0], 1'b0};
                    end
                end
             end
        endgenerate

        always_comb begin
            next_state = state;
            case(state)
                IDLE        : if(!CS_n) next_state = TRANSFER;
                TRANSFER    : begin
                                if(CS_n)
                                    next_state = IDLE;
                                else
                                    if( bit_count == 3'd7 )
                                        next_state = IDLE;
                              end
                default     : next_state = IDLE;
            endcase
        end

endmodule