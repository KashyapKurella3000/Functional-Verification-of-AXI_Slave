
// DUT Instantiation (AXI Slave)
// Interface Instantiation
// clk, rst declaration
// clk, rst generation
// Program block(axi_tb) instantiation
// Assertion module instantiation
// logic to decide when to enter simulation

`include "axi_assertions.sv"
`include "axi_slave.sv"
`include "axi_common.sv"
`include "axi_tx.sv"
`include "axi_bfm.sv"
`include "axi_cov.sv"
`include "axi_gen.sv"
`include "axi_mon.sv"
`include "axi_env.sv"
`include "axi_intf.sv"


module top;

reg clk, rst;

axi_intf pif(clk,rst);
axi_env env;

initial begin
	clk = 0;
	forever #5 clk = ~clk;
end

initial begin

	//$value$plusargs("testname = %s",axi_common::testname);
	axi_common::vif = pif; //pointing physical interface to virtual interface
	rst = 1;
	//reset_design_inputs();
	@(posedge clk);
	rst = 0;
	env = new();
	env.run();
end


task reset_design_inputs();

// Write Address signals
 pif.awid = 0 ;
 pif.awaddr = 0 ;
 pif.awlen = 0 ;
 pif.awsize = 0 ;
 pif.awburst = 0 ;
 pif.awlock = 0 ;
 pif.awcache = 0 ;
 pif.awprot = 0 ;
 pif.awqos = 0 ;
 pif.awregion = 0 ;
 //pif.awuser = 0 ;
 pif.awvalid = 0 ;
 pif.awready = 0 ;

// Write Data signals
 pif.wid = 0 ;
 pif.wdata = 0 ;
 pif.wstrb = 0 ;
 pif.wlast = 0 ;
 pif.wvalid = 0 ;
 pif.wready = 0 ;

// Write Response Signals

 pif.bid = 0 ;
 pif.bresp = 0 ;
 pif.bvalid = 0 ;
 pif.bready = 0 ;

//##################### READ Channel ######################################

// Read Address signals
 pif.arid = 0 ;
 pif.araddr = 0 ;
 pif.arlen = 0 ;
 pif.arsize = 0 ;
 pif.arburst = 0 ;
 pif.arlock = 0 ;
 pif.arcache = 0 ;
 pif.arprot = 0 ;
 pif.arqos = 0 ;
 pif.arregion = 0 ;
 //pif.aruser = 0 ;
 pif.arvalid = 0 ;
 pif.arready = 0 ;

// Read Data signals
 pif.rid = 0 ;
 pif.rdata = 0 ;
 pif.rlast = 0 ;
 //pif.ruser = 0 ;
 pif.rvalid = 0 ;
 pif.rready = 0 ;

// Read Response Signals
  pif.rresp = 0 ;

endtask


axi_assertion axi_assertion_i();

axi_slave dut(

//Physical interface signals should be connected to axi_slave ports
  .aclk(pif.aclk),
  .arst(pif.arst),
  .awid(pif.awid),
  .awaddr(pif.awaddr),
  .awlen(pif.awlen),
  .awsize(pif.awsize),
  .awburst(pif.awburst),
  .awlock(pif.awlock),
  .awcache(pif.awcache),
  .awprot(pif.awprot),
  .awqos(pif.awqos),
  .awregion(pif.awregion),
  //.awuser(pif.awuser),
  .awvalid(pif.awvalid),
  .awready(pif.awready),

// Write Data signals
  .wid(pif.wid),
  .wdata(pif.wdata),
  .wstrb(pif.wstrb),
  .wlast(pif.wlast),
  .wvalid(pif.wvalid),
  .wready(pif.wready),

// Write Response Signals

  .bid(pif.bid),
  .bresp(pif.bresp),
  .bvalid(pif.bvalid),
  .bready(pif.bready),

//##################### READ Channel ######################################

// Read Address signals
  .arid(pif.arid),
  .araddr(pif.araddr),
  .arlen(pif.arlen),
  .arsize(pif.arsize),
  .arburst(pif.arburst),
  .arlock(pif.arlock),
  .arcache(pif.arcache),
  .arprot(pif.arprot),
  .arqos(pif.arqos),
  .arregion(pif.arregion),
  //.aruser(pif.aruser),
  .arvalid(pif.arvalid),
  .arready(pif.arready),

// Read Data signals
  .rid(pif.rid),
  .rdata(pif.rdata),
  .rlast(pif.rlast),
  //.ruser(pif.ruser),
  .rvalid(pif.rvalid),
  .rready(pif.rready),

// Read Response Signals
  .rresp(pif.rresp)
);

initial begin
#2000;
$finish;
end

initial begin
$dumpfile("waveforms.vcd");
$dumpvars();
end


endmodule
