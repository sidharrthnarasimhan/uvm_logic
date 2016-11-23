class halfadder_monitor_before extends uvm_monitor;
	`uvm_component_utils(halfadder_monitor_before)

	uvm_analysis_port#(halfadder_transaction) mon_ap_before;

	virtual halfadder_intf virtualadderif;

	function new(string name, uvm_component parent);
		super.new(name, parent);
	endfunction: new

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);

		void'(uvm_resource_db#(virtual halfadder_intf)::read_by_name
			(.scope("ifs"), .name("halfadder_intf"), .val(virtualadderif)));
		mon_ap_before = new(.name("mon_ap_before"), .parent(this));
	endfunction: build_phase

	task run_phase(uvm_phase phase);
		integer counter_mon = 0, state = 0;

		halfadder_transaction ha_tx;
		ha_tx = halfadder_transaction::type_id::create
			(.name("ha_tx"), .contxt(get_full_name()));

		forever begin
			@(posedge virtualadderif.sig_clock)
			begin
				state = 3;

				if(state==3)
				begin
					ha_tx.carry = ha_tx.carry << 1;
					ha_tx.carry[0] = virtualadderif.sig_carry;

					ha_tx.sum = ha_tx.sum << 1;
					ha_tx.sum[0] = virtualadderif.sig_sum;
				
					counter_mon = counter_mon + 1;

					if(counter_mon==3)
					begin
						state = 0;
						counter_mon = 0;

						//Send the transaction to the analysis port
						mon_ap_before.write(ha_tx);
					end
				end
			end
		end
	endtask: run_phase
endclass: halfadder_monitor_before

class simpleadder_monitor_after extends uvm_monitor;
	`uvm_component_utils(halfadder_monitor_after)

	uvm_analysis_port#(halfadder_transaction) mon_ap_after;

	virtual halfadder_intf virtualadderif;

	halfadder_transaction ha_tx;
	
	//For coverage
	halfadder_transaction ha_tx_cg;

	//Define coverpoints
	covergroup halfadder_cg;
      		in_a_cp:     coverpoint ha_tx_cg.in_a;
      		in_b_cp:     coverpoint ha_tx_cg.in_b;
		cross in_a_cp, in_b_cp;
	endgroup: halfadder_cg

	function new(string name, uvm_component parent);
		super.new(name, parent);
		halfadder_cg = new;
	endfunction: new

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);

		void'(uvm_resource_db#(virtual halfadder_intf)::read_by_name
			(.scope("ifs"), .name("halfadder_intf"), .val(virtualadderif)));
		mon_ap_after= new(.name("mon_ap_after"), .parent(this));
	endfunction: build_phase

	task run_phase(uvm_phase phase);
		integer counter_mon = 0, state = 0;
		sa_tx = halfadderadder_transaction::type_id::create
			(.name("ha_tx"), .contxt(get_full_name()));

		forever begin
			@(posedge virtualadderif.sig_clock)
			begin
				
					state = 1;
					ha_tx.in_a = 2'b00;
					ha_tx.in_b = 2'b00;
					ha_tx.carry = 3'b000;
					ha_tx.sum = 3'b000;
				end

				if(state==1)
				begin
					ha_tx.in_a = ha_tx.in_a << 1;
					ha_tx.in_b = ha_tx.in_b << 1;

					ha_tx.in_a[0] = virtualadderif.sig_ina;
					ha_tx.in_b[0] = virtualadderif.sig_inb;

					counter_mon = counter_mon + 1;

					if(counter_mon==2)
					begin
						state = 0;
						counter_mon = 0;

						//Predict the result
						predictor();
						ha_tx_cg = ha_tx;

						//Coverage
						halfadder_cg.sample();

						//Send the transaction to the analysis port
						mon_ap_after.write(ha_tx);
					end
				end
			end
		end
	endtask: run_phase

	virtual function void predictor();
		ha_tx.carry = ha_tx.in_a & ha_tx.in_b;
		ha_tx.sum = ha_tx.in_a ^ ha_tx.in_b;
	endfunction: predictor
endclass: halfadder_monitor_after