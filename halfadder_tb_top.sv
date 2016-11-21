'include "halfadder_pkg.sv"
'include "halfadder.v"
'include "halfadder_intf.sv"

module halfadder_tb_top;
       import uvm_pkg::*;
       
       halfadder_intf virtualadderif();

       //link interface to the dut

       halfadder dut(virtualadderif.sig_clock,
                     virtualadderif.sig_reset,
                     virtualadderif.sig_in_a,
                     virtualadderif.sig_in_b,
                     virtualadderif.sig_carry,
                     virtualadderif.sig_sum);

        initial begin

                uvm_resource_db#(virtual halfadder_intf)::set
                        (.scope("ifs"), .name("halfadder_intf"), .val(virtualadderif));

                run_test();
        end

        initial begin
                virtualadderif.sig_clock <= 1'b1;
        end

        always
             #10 virtualadderif.sig_clock = ~virtualadderif.sig_clock;
endmodule