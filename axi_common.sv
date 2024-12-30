typedef enum bit {READ, WRITE} wr_rd_t;

typedef enum bit[2:0] {
	BURST_SIZE_1_BYTE,
	BURST_SIZE_2_BYTE,
	BURST_SIZE_4_BYTE,
	BURST_SIZE_8_BYTE,
	BURST_SIZE_16_BYTE,
	BURST_SIZE_32_BYTE,
	BURST_SIZE_64_BYTE,
	BURST_SIZE_128_BYTE
} burst_size_t; //Number of bytes in each transfer

typedef enum bit [1:0] {
	FIXED = 2'b00,
	INCR,
	WRAP,
	RSVD_BURSTT
} burst_type_t; //Type of burst transfer

typedef enum bit [1:0] {
	NORMAL = 2'b00,
	EXCLUSIVE,
	LOCKED,
	RSVD_LOCKT
} lock_t;

typedef enum bit [1:0] {
	OKAY = 2'b00,
	EXOKAY,
	SLVERR, //Slave Error
	DECERR 	//Decoder Error
} resp_t;

class axi_common;

static mailbox gen2bfm = new();

static virtual axi_intf vif;

static string testname;

endclass
