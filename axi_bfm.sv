class axi_bfm;

axi_tx tx;

virtual axi_intf.master_mp vif; //Virtual Interface

task run();
	
	$display("axi_bfm::run");
	vif = axi_common::vif;
	forever begin
		axi_common::gen2bfm.get(tx);
		tx.print();
		drive_tx(tx);  //Driving the recieved interface to the interface
	end
endtask

task drive_tx(axi_tx tx);

	case(tx.wr_rd)
		WRITE: begin
			$display("########### START OF WRITE TXN #################");
			write_addr_phase(tx);
			write_data_phase(tx);
			write_resp_phase(tx);
			$display("########### END OF WRITE TXN ###################\n");
		end

		READ: begin
			$display("########### START OF READ TXN #################");
			read_addr_phase(tx);
			read_data_phase(tx);
			$display("########### END OF READ TXN  ##################\n");

		end
	endcase

endtask

// Replicate these tasks from READ and WRITE timing diagrams

task write_addr_phase(axi_tx tx);
	$display("write_addr_phase"); 
	@(vif.master_cb);
	vif.master_cb.awid  <= tx.id;
	vif.master_cb.awaddr <= tx.addr;
	vif.master_cb.awlen <= tx.len;
	vif.master_cb.awsize <= tx.burst_size;
	vif.master_cb.awburst <= tx.burst_type;
	vif.master_cb.awlock <= tx.lock;
	vif.master_cb.awcache <= tx.cache;
	vif.master_cb.awprot <= tx.prot;
	vif.master_cb.awqos <= 1'b0; // unused as of now
	vif.master_cb.awregion <= 1'b0; //unused as of now
	//vif.awuser = 1'b0; //unused as of now
	vif.master_cb.awvalid <= 1'b1; //unused as of now
	wait(vif.master_cb.awready == 1); //Wait for handshake completion
	
	//Reset Signals	
	@(vif.master_cb);
	vif.master_cb.awvalid <= 0;
	vif.master_cb.awid <= 0;
	vif.master_cb.awaddr <= 0;
	vif.master_cb.awlen <= 0;
	vif.master_cb.awsize <= 0;
	vif.master_cb.awburst <= 0;
	vif.master_cb.awlock <= 0;
	vif.master_cb.awcache <= 0;
	vif.master_cb.awprot <= 0;

endtask

task write_data_phase(axi_tx tx);
	$display("write_data_phase");

	for(int i = 0; i <= tx.len; i++)begin
		@(vif.master_cb);
		vif.master_cb.wdata <= tx.dataQ.pop_front();
		vif.master_cb.wid   <= tx.id;
		vif.master_cb.wstrb <= 4'hF; //Driving all bytes for now	
		vif.master_cb.wlast <= (i == tx.len)? 1 : 0;
		vif.master_cb.wvalid<= 1;
		wait(vif.master_cb.wready == 1); //Wait for handshake completion
	end

		@(vif.master_cb);
		vif.master_cb.wdata <= 0;
		vif.master_cb.wid   <= 0;
		vif.master_cb.wstrb <= 0;
		vif.master_cb.wlast <= 0;
		vif.master_cb.wvalid<= 0;

endtask

task write_resp_phase(axi_tx tx); //Initiated by slave
	$display("write_resp_phase");
       /* wait(vif.bvalid == 1);  ----> Should always be triggered on posedge of clock
	vif.ready = 1 */
	@(vif.master_cb);
	while(vif.master_cb.bvalid == 0) begin
		@(vif.master_cb);
	end

	vif.master_cb.bready <= 1;
	@(vif.master_cb); //Reset to 0
	vif.master_cb.bready <= 0;
	
endtask

task read_addr_phase(axi_tx tx);
	$display("read_addr_phase");

	//@(vif.master_cb);
	vif.master_cb.arid     <= tx.id;
	vif.master_cb.araddr   <= tx.addr;
	vif.master_cb.arlen    <= tx.len;
	vif.master_cb.arsize   <= tx.burst_size;
	vif.master_cb.arburst  <= tx.burst_type;
	vif.master_cb.arlock   <= tx.lock;
	vif.master_cb.arcache  <= tx.cache;
	vif.master_cb.arprot   <= tx.prot;
	vif.master_cb.arqos    <= 1'b0; // unused as of now
	vif.master_cb.arregion <= 1'b0; //unused as of now
	//vif.awuser = 1'b0; //unused as of now
	vif.master_cb.arvalid  <= 1'b1; //unused as of now
	@(vif.master_cb);

	wait(vif.master_cb.arready == 1); //Wait for handshake completion
	
	//Reset Signals	
	//@(vif.master_cb);
	vif.master_cb.arvalid <= 0; //
	vif.master_cb.arid <= 0;
	vif.master_cb.araddr <= 0;
	vif.master_cb.arlen <= 0;
	vif.master_cb.arsize <= 0;
	vif.master_cb.arburst <= 0;
	vif.master_cb.arlock <= 0;
	vif.master_cb.arcache <= 0;
	vif.master_cb.arprot <= 0;


endtask

task read_data_phase(axi_tx tx);

	tx.dataQ.delete(); //Emptying dataQ to hold the read data coming from slave
	$display("read_data_phase");

	for(int i = 0;i <= tx.len; i++) begin

		while(vif.master_cb.rvalid == 0) begin
			@(vif.master_cb);
		end
// when rvalid = 1, while loop exits, I get in dication that master is giving me valid read data.
	tx.dataQ.push_back(vif.master_cb.rdata);
	vif.master_cb.rready <= 1; // To complete handshaking , axi_bfm makes rready = 1
	@(vif.master_cb); //wait for one clock edge
	vif.master_cb.rready <= 0;
	end

// By the time for loop ends, dataQ has all the read data's
endtask


endclass
