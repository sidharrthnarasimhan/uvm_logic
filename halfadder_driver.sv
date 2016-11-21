class halfadder_driver extends uvm_driver#(halfadder_transaction);
      'uvm_component_utils(halfadder_driver)


      virtual halfadder_intf virtualadderif;

      fucntion new(string name, uvm_component parent);
               super.new(name, parent);
      endfucntion: new

      function void build_phase(uvm_phase phase);
               super.build_phase(phase);

               void'(uvm_resource_db#(virtual halfadder_intf)::read_by_name
                    (.scope("ifs"), .name("halfadder_intf"), .val(virtualadderif)));
      endfunction: build_phase

      task run_phase(uvm_phase phase);
           drive();
      endtask: run_phase


      virtual task drive();
          halfadder_transaction ha_tx;
          integer counter = 0, state = 0;
          virtualadderif.sig_in_a = 0'b0;
          virtualadderif.sig_in_b = 0'b0;
          

          forever begin 
                  if(counter == 0)
                  begin 
                       seq_item_port.get_next_item(ha_tx);
                  end

                  @(posedge virtualadderif.sig_clock)
                  begin

                       if(counter == 0)
                        begin

                            state = 1;
                        end
                       case(state)


                       1: begin
                               virtualadderif.sig_in_a = ha.tx_in_a[1];
                               virtualadderif.sig_in_b = ha.tx_in_b[1];

                               ha.tx.in_a = ha.tx.in_a << 1;
                               ha.tx.in_b = ha.tx.in_b << 1;

                               counter = counter + 1;
                               if(counter == 2) state = 2;
                          end

                       2: begin
                              virtualadderif.sig_in_a = 1'b0;
                              virtualadderif.sig_in_b = 1'b0;
                              counter = counter + 1;

                              if(counter ==6)
                              begin
                                   counter = 0;
                                   state = 0;
                                   seq_item_port.item_done();
                              end
                          end

                       endcase
                    end
                end
        endtask: drive
endclass: halfadder_driver