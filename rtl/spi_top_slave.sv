module spi_slave(
    input   logic SCL,
    input   logic resetn,
    input   logic CS,
    input   logic MOSI,
    output  logic MISO,
    input   logic [7:0] tx_data,
    output  logic [7:0] rx_data
);
    typedef enum logic [1:0] {IDLE, LOAD, TRANSFER} state_t;
    state_t state, next_state;

    logic [7:0] rx_shift;
    logic [7:0] tx_shift;
    logic [3:0] bit_count;

    always_ff @(posedge SCL or negedge resetn) begin
        if(!resetn) begin
            rx_shift <= 0;
            rx_data <= 0;
            bit_count <= 0;
            state   <= IDLE;
        end
         else if (CS) begin
        state     <= IDLE;
        bit_count <= 0;
        end
        else begin
            state   <= next_state;
            case(state)
                IDLE        :  bit_count <= 0;
                TRANSFER    :  begin
                                    rx_shift <= {rx_shift[6:0], MOSI};
                                    bit_count++;
                                    if(bit_count == 7)
                                        rx_data <= {rx_shift[6:0] ,MOSI};
                            end
            endcase
        end
    end
    always_ff @(negedge SCL or negedge resetn) begin
        if(!resetn) begin
            MISO <= 1'bz;
            tx_shift <= 0;
            end
        else if(CS) begin
             MISO <= 1'bz;
             tx_shift <= 8'b0;
        end
        else begin
            case(state)
                LOAD     :  begin
                                tx_shift <= tx_data;
                                MISO <= tx_data[7];
                            end
                TRANSFER :  begin
                                MISO <= tx_shift[7];
                                tx_shift <= {tx_shift[6:0], 1'b0};
                            end
            endcase
        end
    end

    always_comb begin
        next_state = state;
        case(state)
            IDLE    :   if(!CS) next_state = LOAD;
            LOAD    :   next_state = TRANSFER;
            TRANSFER :  begin
                            if(CS)
                                next_state = IDLE;
                            else if(bit_count == 7) 
                                next_state = IDLE;
                        end
            default :   next_state    = IDLE;
        endcase
    end
endmodule

