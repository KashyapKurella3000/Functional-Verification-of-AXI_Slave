class axi_tx;

rand bit [31:0] addr;
rand bit [31:0] dataQ[$];
rand bit [3:0] len;
rand bit wr_rd;


constraint dataQ_c {

 dataQ.size() == len+1;

}


function void print();

	$display("axi_tx::print");
	$display("addr = %h", addr);
	$display("dataQ = %p", dataQ);
	$display("len = %h", len);
	$display("wr_rd = %h", wr_rd);


endfunction



endclass
