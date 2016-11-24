class halfadder_env extends uvm_env;
	`uvm_component_utils(halfadder_env)

	halfadder_agent ha_agent;
	halfadder_scoreboard ha_sb;

	function new(string name, uvm_component parent);
		super.new(name, parent);
	endfunction: new

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		sa_agent	= halfadder_agent::type_id::create(.name("ha_agent"), .parent(this));
		sa_sb		= halfadder_scoreboard::type_id::create(.name("ha_sb"), .parent(this));
	endfunction: build_phase

	function void connect_phase(uvm_phase phase);
		super.connect_phase(phase);
		ha_agent.agent_ap_before.connect(ha_sb.sb_export_before);
		ha_agent.agent_ap_after.connect(ha_sb.sb_export_after);
	endfunction: connect_phase
endclass: halfadder_env