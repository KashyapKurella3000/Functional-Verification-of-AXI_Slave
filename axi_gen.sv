class axi_gen;

axi_tx tx;
axi_tx txQ[$];

task run();
	
	$display("axi_gen::run");

case(axi_common::testname)

"test_5_wr": begin
		repeat(5) begin
		tx = new();
		tx.randomize() with {wr_rd == WRITE;};
		axi_common::gen2bfm.put(tx);
		end
	end

"test_5_wr_5_rd": begin  //Write and read to random locations
		
		// Write operation
		for(int i = 0; i < 5; i++) begin
			tx = new();
			tx.randomize() with {wr_rd == WRITE;};  //Only write transactions as of now
			axi_common::gen2bfm.put(tx);
			txQ[i] = new tx; // Performing a shallow copy so that when tx = new is doen again, it shouldn't impact Queue tx's.
		end

		// Reading the previously written locations
		for(int i = 0; i < 5; i++) begin
			tx = new();
			/*tx.randomize() with {wr_rd == WRITE;}; -> Cannot use this because here, reads happen to random locations but, we are supposed to read the same locations which 				were previously written. */
			tx.randomize() with {wr_rd == READ; addr == txQ[i].addr; len == txQ[i].len; burst_size == txQ[i].burst_size;}; // making sure we read the same locations written before{Inline constraints}
			axi_common::gen2bfm.put(tx);
		end
	end

endcase

endtask

endclass
