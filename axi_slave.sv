module axi_slave(
parameter WIDTH =32;
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
input [WIDTH-1:0] wdata,
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
output reg [WIDTH-1:0] rdata,
output reg rlast,
//output reg ruser,
output reg rvalid,
input rready,

// Read Response Signals
output reg [1:0] rresp

);


//reg[WIDTH-1:0] mem [DEPTH-1:0]; // if addr is 32 bit, DEPTH = 2 **ADDR_WIDTH == 2**32 = 4GB(my laptop RAM will become full, laptop might hang)

reg[WIDTH-1:0] mem [int]; //Associative array to be used -> use only locations which are being access

//Slave needs to complete handshaking

// Write Address Handshake
always@(posedge aclk) begin

if(arst)
	begin
		// Make all the outputs zero
		arready = 0;
		wready  = 0;
		awready = 0;
		rid     = 0;
		rdata   = 0;
		rlast   = 0;
		rvalid  = 0;
		bid     = 0;
		bresp   = 0;
		bvalid  = 0;
		rresp   = 0;
	end
else 
	begin
		//Write Address Handshake
		if(awvalid)begin
			awready   = 1;

		// Slave is collecting the write address information in to temp.varibles

			awaddr_t  = awaddr;
			awlen_t   = awlwn;
			awsize_t  = awsize;
			awburst_t = awburst;
			awid_t    = awid;
			awlock_t  = awlock;
			awprot_t  = awprot;
			awcache_t = awcache;
		end

		else begin
			awready   = 0;
		end
	// Write Data Handshake
		if(wvalid)begin
			wready = 1;
			store_write_data();
			write_count++; //Check if write_count = awlen_t + 1
				if(wlast)begin
				//bvalid = 1;  // Should not be valid throughout
					if (write_count != awlen + 1) begin
						$error("write bursts are not matching awlen + 1");
					end
					write_resp_phase(wid);
				end
		end
		else begin
			wready  = 0;
		end
	// Read Address Handshake
		if(arvalid)begin
			arready = 1;
			araddr_t  = araddr;
			arlen_t   = arlwn;
			arsize_t  = arsize;
			arburst_t = arburst;
			arid_t    = arid;
			arlock_t  = arlock;
			arprot_t  = arprot;
			arcache_t = arcache;
			drive_read_data(); // After master sends a read request, I need to provide read data
		end

		else begin
			arready = 0;
		end
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

// This "store_write_data" task represents storage of one beat of AXI transaction

task store_write_data();

if(awsize_t == 0)begin

	mem[awaddr_t]     = wdata[7:0];
end

if(awsize_t == 1)begin

	mem[awaddr_t]     = wdata[7:0];
	mem[awaddr_t + 1] = wdata[15:8];
end

if(awsize_t == 2)begin

	mem[awaddr_t]     = wdata[7:0];
	mem[awaddr_t + 1] = wdata[15:8];
	mem[awaddr_t + 2] = wdata[23:16];
	mem[awaddr_t + 3] = wdata[31:24];
end

if(awsize_t == 3)begin

	mem[awaddr_t]     = wdata[7:0];
	mem[awaddr_t + 1] = wdata[15:8];
	mem[awaddr_t + 2] = wdata[23:16];
	mem[awaddr_t + 3] = wdata[31:24];
	mem[awaddr_t + 4] = wdata[39:32];
	mem[awaddr_t + 5] = wdata[47:40];
	mem[awaddr_t + 6] = wdata[55:48];
	mem[awaddr_t + 7] = wdata[63:56];
end

//Slave should intenally updateits address, because whatever next data comes, it should store to the next address as per burst type.	
	
	awaddr_t         += 2**awsize_t;

//Need to add a functionality to wrap upper boundary check, if it crosses, then do wrap to lower update: TO-DO

endtask


//This "drive_read_data" task represents reading of one beat of AXI Transaction

task drive_read_data();

for (int i = 0;i< arlen_t +1; i++) begin
	@(posedge aclk);

if(arsize_t == 0)begin

	      rdata[7:0]= mem[araddr_t];
end

if(arsize_t == 1)begin

	    rdata[7:0]  = mem[araddr_t] ;
	    rdata[15:8] = mem[araddr_t + 1];
end

if(arsize_t == 2)begin

	      rdata[7:0] = mem[araddr_t];
	    rdata[15:8]  = mem[araddr_t + 1];
	    rdata[23:16] = mem[araddr_t + 2];
	    rdata[31:24] = mem[araddr_t + 3];
end

if(arsize_t == 3)begin

	     rdata[7:0]	 = mem[araddr_t] ;
	    rdata[15:8]  = mem[araddr_t + 1];
	    rdata[23:16] = mem[araddr_t + 2];
	    rdata[31:24] = mem[araddr_t + 3];
	    rdata[39:32] = mem[araddr_t + 4] ;
	    rdata[47:40] = mem[araddr_t + 5] ;
	    rdata[55:48] = mem[araddr_t + 6];
	    rdata[63:56] = mem[araddr_t + 7] ;
end

rvalid = 1;
rid = arid_t;
rresp = 2'b00; //OKAY response

if(i == arlen_t) rlast = 1;
	wait (rready == 1);	
        araddr_t += 2**arsize_t;


end //End of for loop

	@(posedge aclk);
	rvalid = 0;
	rid = 0;
	rdata = 0;
	rlast = 0;

endtask

endmodule
