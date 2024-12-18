
// DUT Instantiation (AXI Slave)
// Interface Instantiation
// clk, rst declaration
// clk, rst generation
// Program block(axi_tb) instantiation
// Assertion module instantiation
// logic to decide when to enter simulation

`include "axi_assertions.sv"
`include "axi_memory.sv"
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
	rst = 1;
	@(posedge clk);
	rst = 0;
	env = new();
	env.run();
end

axi_assertion axi_assertion_i();
axi_memory dut();

initial begin
#1000;
$finish;
end


endmodule
