
// To avoid double compilation

`ifndef __AXI_ENV__
`define __AXI_ENV__

class axi_env;

axi_bfm bfm;
axi_gen gen;
axi_mon mon;
axi_cov cov;

function new();
	bfm = new();
	gen = new();
	mon = new();
	cov = new();
endfunction

task run();

fork
	bfm.run();
	gen.run();
	mon.run();
	cov.run();
join

endtask
endclass

`endif
