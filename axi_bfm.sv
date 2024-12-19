class axi_bfm;

axi_tx tx;

task run();
	
	$display("axi_bfm::run");
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
			write_addr_phase();
			write_data_phase();
			write_resp_phase();
			$display("########### END OF WRITE TXN ###################\n");
		end

		READ: begin
			$display("########### START OF READ TXN #################");
			read_addr_phase();
			read_data_phase();
			$display("########### END OF READ TXN  ##################\n");

		end
	endcase

endtask


task write_addr_phase();
	$display("write_addr_phase");

endtask

task write_data_phase();
	$display("write_data_phase");

endtask

task write_resp_phase();
	$display("write_resp_phase");

endtask

task read_addr_phase();
	$display("read_addr_phase");

endtask

task read_data_phase();
	$display("read_data_phase");

endtask


endclass
