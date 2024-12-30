class axi_bfm;

axi_tx tx;

virtual axi_intf vif; //Virtual Interface

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
	@(vif.aclk);
	vif.awid = tx.id;
	vif.awaddr = tx.addr;
	vif.awlen = tx.len;
	vif.awsize = tx.burst_size;
	vif.awburst = tx.burst_type;
	vif.awlock = tx.lock;
	vif.awcache = tx.cache;
	vif.awprot = tx.prot;
	vif.awqos = 1'b0; // unused as of now
	vif.awregion = 1'b0; //unused as of now
	//vif.awuser = 1'b0; //unused as of now
	vif.awvalid = 1'b1; //unused as of now
	wait(vif.awready == 1); //Wait for handshake completion
	
	//Reset Signals	
	@(vif.aclk);
	vif.awvalid = 0;
	vif.awid = 0;
	vif.awaddr = 0;
	vif.awlen = 0;
	vif.awsize = 0;
	vif.awburst = 0;
	vif.awlock = 0;
	vif.awcache = 0;
	vif.awprot = 0;

endtask

task write_data_phase(axi_tx tx);
	$display("write_data_phase");

	for(int i = 0; i <= tx.len; i++)begin
		@(posedge vif.aclk);
		vif.wdata = tx.dataQ.pop_front();
		vif.wid   = tx.id;
		vif.wstrb = 4'hF; //Driving all bytes for now	
		vif.wlast = (i == tx.len)? 1 : 0;
		vif.wvalid= 1;
		wait(vif.wready == 1); //Wait for handshake completion
	end

		@(posedge vif.aclk);
		vif.wdata = 0;
		vif.wid   = 0;
		vif.wstrb = 0;
		vif.wlast = 0;
		vif.wvalid= 0;

endtask

task write_resp_phase(axi_tx tx); //Initiated by slave
	$display("write_resp_phase");
       /* wait(vif.bvalid == 1);  ----> Should always be triggered on posedge of clock
	vif.ready = 1 */

	while(vif.bvalid == 0) begin
		@(posedge vif.aclk);
	end

	vif.bready = 1;
	@(posedge vif.aclk); //Reset to 0
	vif.bready = 0;
	
endtask

task read_addr_phase(axi_tx tx);
	$display("read_addr_phase");

	@(vif.aclk);
	vif.arid     = tx.id;
	vif.araddr   = tx.addr;
	vif.arlen    = tx.len;
	vif.arsize   = tx.burst_size;
	vif.arburst  = tx.burst_type;
	vif.arlock   = tx.lock;
	vif.arcache  = tx.cache;
	vif.arprot   = tx.prot;
	vif.arqos    = 1'b0; // unused as of now
	vif.arregion = 1'b0; //unused as of now
	//vif.awuser = 1'b0; //unused as of now
	vif.arvalid  = 1'b1; //unused as of now
	wait(vif.arready == 1); //Wait for handshake completion
	
	//Reset Signals	
	@(vif.aclk);
	vif.arvalid = 0;
	vif.arid = 0;
	vif.araddr = 0;
	vif.arlen = 0;
	vif.arsize = 0;
	vif.arburst = 0;
	vif.arlock = 0;
	vif.arcache = 0;
	vif.arprot = 0;


endtask

task read_data_phase(axi_tx tx);

	tx.dataQ.delete(); //Emptying dataQ to hold the read data coming from slave
	$display("read_data_phase");

	for(int i = 0;i <= tx.len; i++) begin

		while(vif.rvalid == 0) begin
			@(posedge vif.aclk);
		end
// when rvalid = 1, while loop exits, I get in dication that master is giving me valid read data.
	tx.dataQ.push_back(vif.rdata);
	vif.rready = 1; // To complete handshaking , axi_bfm makes rready = 1
	@(posedge vif.aclk); //wait for one clock edge
	vif.rready = 0;
	end

// By the time for loop ends, dataQ has all the read data's
endtask


endclass
