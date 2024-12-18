class axi_bfm;

axi_tx tx;

task run();
	
	$display("axi_bfm::run");
	forever begin
		axi_common::gen2bfm.get(tx);
		tx.print();
	end
endtask
endclass
