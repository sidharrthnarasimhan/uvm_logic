class halfadder_transaction extends uvm_sequence_item;
         rand bit[1:0] in_a;
         rand bit[1:0] in_b;
         bit[2:0] out;

         function new(string name = "");
                 super.new(name);
         endfunction: new

         'uvm_object_utils_begin(halfadder_transaction)
               'uvm_field_int(in_a UVM_ALL_ON)
               'uvm_field_int(in_b UVM_ALL_ON)
               'uvm_field_int(carry UVM_ALL_ON)
               'uvm_field_int(sum UVM_ALL_ON)
         'uvm_object_utils_end
endclass: halfadder_transaction

class halfadder_sequence extends uvm_sequence#(halfadder_transaction);
         'uvm_object_utils(halfadder_sequence)

         function new(string name = "");
                 super.new(name);

         endfunction: new


         task body();
              halfadder_transaction hs_tx;

              repeat(15) begin
              ha_tx = halfadder_transaction::type_id::create(.name("ha_tx"), .contxt(get_full_name());

              start_item(ha_tx);
              assert(ha_tx.randomize());
              finish_item(ha_tx);
              end
         endtask: body
endclass: ha;fadder_sequence

typedef uvm_sequence#(halfadder_transaction) halfadder_sequencer;