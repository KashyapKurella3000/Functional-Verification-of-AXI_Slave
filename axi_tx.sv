class axi_tx; //Same Tx can be associated with both write and read

rand wr_rd_t wr_rd;
//Hand-Shaking signals should not be a part of transaction class, they usually handled by BFM or Driver Class
rand bit [31:0] addr;
rand bit [31:0] dataQ[$];
rand bit [3:0] len;
rand burst_size_t burst_size; // Number of bytes per beat
rand bit [3:0] id; // since (awid = wid = bid = id), no need to declare individual ID's
// wstrb will be taken care by BFM, hence not required here
rand burst_type_t burst_type;
rand lock_t lock;
rand bit [2:0] prot; //Each bit has an unique meaning and collectively do not have any meaning so, cannot be used as enums
rand bit [3:0] cache;
rand resp_t resp;

//last is taken care by BFM

// Signals which have RESERVED modes should be constrained
constraint rsvd_c {
	burst_type != RSVD_BURSTT;
	lock != RSVD_LOCKT;
}

constraint dataQ_c {
 	dataQ.size() == len+1;
}

constraint soft_c {
	soft resp == OKAY;
	soft burst_size == 2;
	soft burst_type == INCR;
	soft prot == 3'b0;
	soft cache == 4'b0;
	soft lock == NORMAL;
}

function void print();

	$display("############################");
	$display("####### axi_tx::print ######");
	$display("############################");
	$display("addr = %h", addr);
	$display("dataQ = %p", dataQ);
	$display("len = %d", len);
	$display("wr_rd = %s", wr_rd);
	$display("burst_size = %s", burst_size);
	$display("id = %d", id);
	$display("burst_type = %s", burst_type);
	$display("lock = %s", lock);
	$display("prot = %h", prot);
	$display("cache = %d", cache);
	$display("resp = %s", resp);
	
endfunction



endclass
