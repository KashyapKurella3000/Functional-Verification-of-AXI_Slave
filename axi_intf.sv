interface axi_intf(input logic aclk, arst);

//################# Write Channel ######################################

// Write Address signals
logic [3:0] awid;
logic [31:0] awaddr;
logic [3:0] awlen;
logic [2:0] awsize;
logic [1:0] awburst;
logic [1:0] awlock;
logic [3:0] awcache;
logic [2:0] awprot;
logic awqos;
logic awregion;
//logic awuser;
logic awvalid;
logic awready;

// Write Data signals
logic [3:0] wid;
logic [31:0] wdata;
logic [3:0] wstrb;
logic wlast;
//logic wuser;
logic wvalid;
logic wready;

// Write Response Signals

logic [3:0] bid;
logic [1:0] bresp;
//logic buser;
logic bvalid;
logic bready;

//##################### READ Channel ######################################

//Read Address signals
logic [3:0] arid;
logic [31:0] araddr;
logic [3:0] arlen;
logic [2:0] arsize;
logic [1:0] arburst;
logic [1:0] arlock;
logic [3:0] arcache;
logic [2:0] arprot;
logic arqos;
logic arregion;
//logic aruser;
logic arvalid;
logic arready;

// Read Data signals
logic [3:0] rid;
logic [31:0] rdata;
logic rlast;
//logic ruser;
logic rvalid;
logic rready;

// Read Response Signals
logic [1:0] rresp;

//Clocking Block

clocking master_cb@(posedge aclk);

default input #0 output #0;

//output arst;
// Write Address signals
output awid;
output awaddr;
output awlen;
output awsize;
output awburst;
output awlock;
output awcache;
output awprot;
output awqos;
output awregion;
//output awuser;
output awvalid;
input   awready;

// Write Data signals
output wid;
output wdata;
output wstrb;
output wlast;
output wvalid;
input  wready;

// Write Response Signals

input  bid;
input  bresp;
input  bvalid;
output bready;

//##################### READ Channel ######################################

// Read Address signals
output arid;
output araddr;
output arlen;
output arsize;
output arburst;
output arlock;
output arcache;
output arprot;
output arqos;
output arregion;
//output aruser;
output arvalid;
input  arready;

// Read Data signals
input  rid;
input  rdata;
input  rlast;
//input   ruser;
input  rvalid;
output rready;

// Read Response Signals
input  rresp;


endclocking


//////////// MONITOR CLOKCING BLOCK ////////////////////////////////////////

clocking monitor_cb@(posedge aclk);

default input #1 ; //output skew is not required for monitor ---> But why ?????

//input aclk,arst;
// Write Address signals
input awid;
input awaddr;
input awlen;
input awsize;
input awburst;
input awlock;
input awcache;
input awprot;
input awqos;
input awregion;
//input awuser;
input awvalid;
output   awready;

// Write Data signals
input wid;
input wdata;
input wstrb;
input wlast;
input wvalid;
output wready;

// Write Response Signals

output  bid;
output  bresp;
output  bvalid;
input bready;

//##################### READ Channel ######################################

// Read Address signals
input arid;
input araddr;
input arlen;
input arsize;
input arburst;
input arlock;
input arcache;
input arprot;
input arqos;
input arregion;
//input aruser;
input arvalid;
output  arready;

// Read Data signals
output  rid;
output  rdata;
output  rlast;
//output   ruser;
output  rvalid;
input rready;

// Read Response Signals
output  rresp;

endclocking


//Modport declarations for clocking blocks

modport master_mp (clocking master_cb);
modport monitor_mp(clocking monitor_cb);


endinterface
