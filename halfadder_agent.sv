class halfadder_agent extends uvm_agent;
	`uvm_component_utils(halfadder_agent)

	uvm_analysis_port#(halfadder_transaction) agent_ap_before;
	uvm_analysis_port#(halfadder_transaction) agent_ap_after;

	halfadder_sequencer		ha_seqr;
	halfadder_driver		ha_drvr;
	halfadder_monitor_before	ha_mon_before;
	halfadder_monitor_after	ha_mon_after;

	function new(string name, uvm_component parent);
		super.new(name, parent);
	endfunction: new

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);

		agent_ap_before	= new(.name("agent_ap_before"), .parent(this));
		agent_ap_after	= new(.name("agent_ap_after"), .parent(this));

		ha_seqr		= halfadder_sequencer::type_id::create(.name("ha_seqr"), .parent(this));
		ha_drvr		= halfadder_driver::type_id::create(.name("ha_drvr"), .parent(this));
		ha_mon_before	= halfadder_monitor_before::type_id::create(.name("ha_mon_before"), .parent(this));
		ha_mon_after	= halfadder_monitor_after::type_id::create(.name("ha_mon_after"), .parent(this));
	endfunction: build_phase

	function void connect_phase(uvm_phase phase);
		super.connect_phase(phase);
		
		ha_drvr.seq_item_port.connect(ha_seqr.seq_item_export);
		ha_mon_before.mon_ap_before.connect(agent_ap_before);
		ha_mon_after.mon_ap_after.connect(agent_ap_after);
	endfunction: connect_phase
endclass: halfadder_agent