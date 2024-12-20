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

// Read Address signals
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


endinterface
