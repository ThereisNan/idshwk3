global agentTable :table[addr] of set[string];

event http_header(c: connection, is_orig: bool, name: string, value: string) {
	local orig_addr: addr = c$id$orig_h;
	if (c$http?$user_agent){
		local agent: string = to_lower(c$http$user_agent);
		if (orig_addr in agentTable) {
			add agent[orig_addr][agent];
		} else {
			agentTable[orig_addr] = set(agent);
		}
	}
}

event zeek_done() {
	for (orig_addr in agentTable) {
		if (|agentTable[orig_addr]| >= 3) {
			print fmt("%s is a proxy",orig_addr);
		}
	}
}
