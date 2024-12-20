module axi_slave(

//################# Write Channel ######################################
input aclk,
input arst,
// Write Address signals
input [3:0] awid,
input [31:0] awaddr,
input [3:0] awlen,
input [2:0] awsize,
input [1:0] awburst,
input [1:0] awlock,
input [3:0] awcache,
input [2:0] awprot,
input awqos,
input awregion,
input awuser,
input awvalid,
output reg awready,

// Write Data signals
input [3:0] wid,
input [31:0] wdata,
input [3:0] wstrb,
input wlast,
input wvalid,
output reg wready,

// Write Response Signals

output reg [3:0] bid,
output reg [1:0] bresp,
output reg bvalid,
input bready,

//##################### READ Channel ######################################

// Read Address signals
input [3:0] arid,
input [31:0] araddr,
input [3:0] arlen,
input [2:0] arsize,
input [1:0] arburst,
input [1:0] arlock,
input [3:0] arcache,
input [2:0] arprot,
input arqos,
input arregion,
input aruser,
input arvalid,
output reg arready,

// Read Data signals
output reg [3:0] rid,
output reg [31:0] rdata,
output reg rlast,
output reg ruser,
output reg rvalid,
input rready,

// Read Response Signals
output reg [1:0] rresp

);

//Slave needs to complete handshaking

// Write Address Handshake
always@(posedge aclk) begin

	if(awvalid)begin
		awready = 1;
	end

	else begin
		awready = 0;
	end
// Write Data Handshake
	if(wvalid)begin
		wready = 1;
			if(wlast)begin
			//bvalid = 1;  // Should not be valid throughout
				write_resp_phase(wid);
			end
	end
	else begin
		wready = 0;
	end
// Read Address Handshake
	if(arvalid)begin
		arready = 1;
	end

	else begin
		arready = 0;
	end

end

task write_resp_phase(input [3:0] id);
	@(posedge aclk);
	bvalid = 1;
	bid = id;
	bresp = 2'b00;
	wait(bready == 1);
	@(posedge aclk);
	bvalid = 0;
endtask

endmodule
