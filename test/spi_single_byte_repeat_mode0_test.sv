//=====================================================
// Project     : SPI
// File        : spi_single_byte_repeat_mode0_test.sv
// Author      : Brahma Ganesh Katrapalli
// Created On  : 19-12-2025
// Revision    : 1.0
// Description : UVM sequence and test for repeated single-byte SPI Mode 0 transfers
//=====================================================

class spi_single_byte_repeat_mode0_sequence extends spi_sequence;
  `uvm_object_utils(spi_single_byte_repeat_mode0_sequence)

    spi_transaction tr;

  function new(string name = "spi_single_byte_repeat_mode0_sequence");
        super.new(name);
    endfunction

    task body();
      for(int i=0; i<10; i++)begin
        tr = spi_transaction::type_id::create("tr");
        if(i==0)begin
          tr.randomize() with {mode == 2'b00;tx_data==8'h00;};
        end
        else if(i==1)begin
          tr.randomize() with {mode == 2'b00; tx_data==8'hFF;};
        end
        else begin
            tr.randomize() with {mode == 2'b00;};
        end
        start_item(tr);
        finish_item(tr);
      end
    endtask
endclass

class spi_single_byte_repeat_mode0_test extends base_test;
    `uvm_component_utils(spi_single_byte_repeat_mode0_test)

    spi_single_byte_repeat_mode0_sequence spi_m0;

    function new (string name = "spi_single_byte_repeat_mode0_test", uvm_component parent = null);
        super.new(name, parent);
    endfunction

    task run_phase(uvm_phase phase);
        phase.raise_objection(this);
        spi_m0 = spi_single_byte_repeat_mode0_sequence::type_id::create("spi_m0");
        spi_m0.start(env.m_agent.sqer);
        phase.drop_objection(this);
    
    endtask

endclass