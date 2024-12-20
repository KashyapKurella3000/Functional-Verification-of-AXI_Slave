class axi_gen;

axi_tx tx;

task run();
	
	$display("axi_gen::run");
	repeat(10)begin
		tx = new();
		tx.randomize() with {wr_rd == WRITE;};  //Only write transactions as of now
		axi_common::gen2bfm.put(tx);
	end

endtask
endclass
