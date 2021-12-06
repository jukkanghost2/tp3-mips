/* Instruction Fields in bits */
// opcode
#define	R_FORMAT	"000000"
#define	LW			"100011"
#define	LWU			"100111"
#define	LB			"100000"
#define	LBU			"100100"
#define	LH			"100001"
#define	LHU			"100101"
#define	SW			"101011"
#define	SB			"101000"
#define	SH			"101001"
#define BEQ  "000100"
#define BNE  "000101"
#define ADDI  "001000"
#define ANDI  "001100"
#define ORI  "001101"
#define XORI  "001110"
#define LUI  "001111"
#define SLTI  "001010"
#define J  "000010"
#define JAL  "000011"
#define JR  "001000"
#define JALR  "001001"
#define NOP  "111000"
#define HALT  "111111"

// funct
#define SLL  "000000"
#define SRL  "000010"
#define SRA  "000011"
#define SLLV  "000100"
#define SRLV  "000110"
#define SRAV  "000111"
#define ADDU  "100001"
#define SUBU  "100011"
#define OR  "100101"
#define XOR "100110"
#define AND "100100"
#define NOR  "100111"
#define SLT  "101010"

// regs
#define	REG0		"00000"
#define	REG1		"00001"
#define	REG2		"00010"
#define	REG3		"00011"
#define	REG4		"00100"
#define	REG5		"00101"
#define	REG6		"00110"
#define	REG7		"00111"
#define	REG8		"01000"
#define	REG9		"01001"
#define	REG10		"01010"
#define	REG11		"01011"
#define	REG12		"01100"
#define	REG13		"01101"
#define	REG14		"01110"
#define	REG15		"01111"
#define	REG16		"10000"
#define	REG17		"10001"
#define	REG18		"10010"
#define	REG19		"10011"
#define	REG20		"10100"
#define	REG21		"10101"
#define	REG22		"10110"
#define	REG23		"10111"
#define	REG24		"11000"
#define	REG25		"11001"
#define	REG26		"11010"
#define	REG27		"11011"
#define	REG28		"11100"
#define	REG29		"11101"
#define	REG30		"11110"
#define	REG31		"11111"
