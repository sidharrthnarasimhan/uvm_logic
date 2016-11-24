class halfadder_test extends uvm_test;
		`uvm_component_utils(halfadder_test)

		halfadder_env ha_env;

		function new(string name, uvm_component parent);
			super.new(name, parent);
		endfunction: new

		function void build_phase(uvm_phase phase);
			super.build_phase(phase);
			ha_env = simpleadder_env::type_id::create(.name("ha_env"), .parent(this));
		endfunction: build_phase

		task run_phase(uvm_phase phase);
			halfadder_sequence ha_seq;

			phase.raise_objection(.obj(this));
				ha_seq = simpleadder_sequence::type_id::create(.name("ha_seq"), .contxt(get_full_name()));
				assert(ha_seq.randomize());
				ha_seq.start(ha_env.ha_agent.ha_seqr);
			phase.drop_objection(.obj(this));
		endtask: run_phase
endclass: halfadder_test