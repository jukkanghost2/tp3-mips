#ifndef	_INSTR_FIELDS_
#define	_INSTR_FIELDS_

/* Instruction Fields in bits */
// opcode
#define	R_FORMAT	"000000"
#define	LW			"100011"
#define	SW			"101011"
#define BEQ  "000100"
#define BNE  "000101"
#define ADDI  "001000"
#define ANDI  "001100"
#define ORI  "001101"
#define XORI  "001110"
#define LUI  "001111"
#define SLTI  "001010"
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

#endif	// _INSTR_FIELDS_

#include <stdio.h>
#include <string.h>
#include <stdlib.h>



int main(int argc, char **argv){

	FILE *fpr, *fpw;            /* declare the file pointer */
	char line[80];	// from input
	int line_n;		// for input
	int address;	// for output
	char *new_field, *buffer;
	char final_fld[200];
	unsigned int i;
	
	/* File manipulation */
	// open input file .txt with assembler
	if(NULL == (fpr = fopen(argv[_MASM_], "r"))){
		fprintf(stderr, "Error: Can't open .masm input file!\n");
		exit(2);
	}
	
	// open output file .txt with machine code
	if(NULL == (fpw = fopen(argv[_MBIN_], "w"))){
		fprintf(stderr, "Error: Can't open .mbin output file!\n");
		exit(2);
	}
	
	char *op;
	
	if(NULL == (new_field = malloc(60*sizeof(char)))){
		fprintf(stderr, "Error: Can't allocate memory for the line buffer!\n");
		exit(3);
	}
	if(NULL == (buffer = malloc(60*sizeof(char)))){
		fprintf(stderr, "Error: Can't allocate memory for the line buffer!\n");
		exit(3);
	}
	
	line_n = 1;
	while(NULL != fgets(line, 80, fpr)){
	
		/*  STAGE 1  */
		// Get the first token to check the opcode
//		printf("STAGE 1....done\n");
		op = strtok(line, delim);

		/*  STAGE 2  */
		// Check the instruction format &&
		// Return the field parsed
//		printf("STAGE 2....done\n");
		
		if(NULL != (buffer = is_r_format(line_n, argv, op, new_field))){
			
			strcpy(new_field, buffer);

			/*  STAGE 3  */
			// A - Initialization of final_fld
//			printf("STAGE 3....done\n");
			for(i=0; i<strlen(final_fld); ++i){
				final_fld[i] = '\0';
			}		
			
			// B -  Write to the output file
			strcat(final_fld, new_field);
			strcat(final_fld, "\n");
			printf("%s", final_fld);
			fputs(final_fld, fpw);
		}
		else if(NULL != (buffer = is_i_format(line_n, argv, op, new_field))){
			strcpy(new_field, buffer);
			
			/*  STAGE 3  */
			// A - Initialization of final_fld
//			printf("STAGE 3....done\n");
			for(i=0; i<strlen(final_fld); ++i){
				final_fld[i] = '\0';
			}
		
			// B -  Write to the output file
			strcat(final_fld, new_field);
			strcat(final_fld, "\n");
			printf("%s", final_fld);
			fputs(final_fld, fpw);
		}
		else{
			printf("Error:%s:line:%d -  Unknown instruction\n", argv[argc==3?1:2], line_n);
			return(1);
		}
		
		fflush(fpw);
		// C - Increase counters
		++ line_n;
	}
	
	printf("\n Output is ready \n");
	/*
	free(new_field);
	free(buffer);
	*/
	fclose(fpr);
	fclose(fpw);

	return(0);
}

/*
 * MIPS Instruction Based Functions
 */
/*
 * Checks if instruction has I-Format
 */
char *is_i_format(int line_n, char **argv, const char *op, char *new_field){

	unsigned int i;
	char *rs, *rt;
	char *other_tokens;
	char *binary;
	int offset;
	
	if(!strcmp(op, "ADDI") || !strcmp(op, "ANDI") || !strcmp(op, "ORI") \
     || !strcmp(op, "XORI") || !strcmp(op, "LUI") || !strcmp(op, "SLTI") ){

		// char *oper[] = {"\0\0\0\0\0\0", "\0\0\0\0\0\0\0\0\0\0\0\0\0", "\0\0\0\0\0\0"};
		char *oper[] = {"\0\0\0\0\0\0", "\0\0\0\0\0\0", "\0\0\0\0\0\0\0\0\0\0\0\0\0"};
		
		// Walk through other tokens
		i = 0;
		while(i < 3){	// strtok() saves the previous state :P
			oper[i] = strtok(NULL, delim);
			i++;
		}
		// Take away the other tokens, just to initialize the state of strtok()
		while(other_tokens != NULL) other_tokens = strtok(NULL, delim);
		
		// Initialize the input/output string just to be sure
		for(i=0; i<strlen(new_field); ++i) new_field[i] = '\0';
		
		// MAKE UP THE FIELDS -->
		// OPCODE
		if(!strcmp(op, "ADDI"))	strcat(new_field,ADDI );
        else if(!strcmp(op, "ANDI"))	strcat(new_field,ANDI );
		else if(!strcmp(op, "ORI"))	strcat(new_field,ORI );
		else if(!strcmp(op, "XORI"))	strcat(new_field,XORI );
		else if(!strcmp(op, "LUI"))	    strcat(new_field,LUI );
        else if(!strcmp(op, "SLTI"))	    strcat(new_field,SLTI );
		strcat(new_field, "_");
		
		// REGISTERS
		if(NULL == (rs = malloc(6*sizeof(char)))){
			printf("Error: Unable to allocate memory for rs.\n");
			exit(1);
		}
		if(NULL == (rt = malloc(6*sizeof(char)))){
			printf("Error: Unable to allocate memory for rt.\n");
			exit(1);
		}
		if(NULL != (strcpy(rs, which_reg(oper[1]))))strcat(new_field, rs);
		else printf("Error:%s:line:%d - Not supported register %s\n", argv[1], line_n, oper[0]);
		strcat(new_field, "_");
		
		if(NULL != (strcpy(rt, which_reg(oper[0])))) strcat(new_field, rt);
		else printf("Error:%s:line:%d - Not supported register %s\n", argv[1], line_n, oper[0]);
		strcat(new_field, "_");
		
		// IMMEDIATE
		sscanf(oper[2], "%d ", &offset);	// convert the string to integer
		
		// Convert the decimal to binary representation
		if(!dec_to_bin(offset, 32, &binary)) return(NULL);
//		printf("binary offset: %s\n", binary);
		
		binary += 16;
		strcat(new_field, binary);
		strcat(new_field, "\0");
		// <-- END
		
		// Optional
		free(rs);
		free(rt);
		
		return(new_field);
	}
    else if(!strcmp(op, "BEQ") || !strcmp(op, "BNE")) {
		char *oper[] = {"\0\0\0\0\0\0", "\0\0\0\0\0\0", "\0\0\0\0\0\0\0\0\0\0\0\0\0"};
		
		// Walk through other tokens
		i = 0;
		while(i < 3){	// strtok() saves the previous state :P
			oper[i] = strtok(NULL, delim);
			i++;
		}
		// Take away the other tokens, just to initialize the state of strtok()
		while(other_tokens != NULL){
			other_tokens = strtok(NULL, delim);
			printf("%s\n", other_tokens);
		}
		// Initialize the input/output string just to be sure
		for(i=0; i<strlen(new_field); ++i) new_field[i] = '\0';

		// MAKE UP THE FIELDS -->
		// OPCODE
		if(!strcmp(op, "BEQ"))	    strcat(new_field,BEQ );
		else if(!strcmp(op, "BNE"))	strcat(new_field,BNE );
		strcat(new_field, "_");

		// REGISTERS
		if(NULL == (rs = malloc(6*sizeof(char)))){
			printf("Error: Unable to allocate memory for rs.\n");
			exit(1);
		}
		if(NULL == (rt = malloc(6*sizeof(char)))){
			printf("Error: Unable to allocate memory for rt.\n");
			exit(1);
		}
		if(NULL != (strcpy(rs, which_reg(oper[0]))))strcat(new_field, rs);
		else printf("Error:%s:line:%d - Not supported register %s\n", argv[1], line_n, oper[0]);
		strcat(new_field, "_");
		if(NULL != (strcpy(rt, which_reg(oper[1])))) strcat(new_field, rt);
		else printf("Error:%s:line:%d - Not supported register %s\n", argv[1], line_n, oper[1]);
		strcat(new_field, "_");
		// ADDRESS (IMMEDIATE)
		sscanf(oper[2], "%d ", &offset);	// convert the string to integer
		// Convert the decimal to binary representation
		if(!dec_to_bin(offset, 32, &binary)) return(NULL);
//		printf("binary offset: %s\n", binary);
		binary += 16;
		strcat(new_field, binary);
		strcat(new_field, "\0");
		// <-- END
		// Optional
		free(rs);
		free(rt);
		
		return(new_field);
	}
	else if(!strcmp(op, "LW") || !strcmp(op, "SW")) {
        char *oper[] = {"\0\0\0\0\0\0", "\0\0\0\0\0\0\0\0\0\0\0\0\0", "\0\0\0\0\0\0"};
		
		// Walk through other tokens
		i = 0;
		while(i < 3){	// strtok() saves the previous state :P
			oper[i] = strtok(NULL, delim);
			i++;
		}
		// Take away the other tokens, just to initialize the state of strtok()
		while(other_tokens != NULL){
			other_tokens = strtok(NULL, delim);
			printf("%s\n", other_tokens);
		}
		// Initialize the input/output string just to be sure
		for(i=0; i<strlen(new_field); ++i) new_field[i] = '\0';

		// MAKE UP THE FIELDS -->
		// OPCODE
		if(!strcmp(op, "LW"))	    strcat(new_field,LW );
		else if(!strcmp(op, "SW"))	strcat(new_field,SW );
		strcat(new_field, "_");

		// REGISTERS
		if(NULL == (rs = malloc(6*sizeof(char)))){
			printf("Error: Unable to allocate memory for rs.\n");
			exit(1);
		}
		if(NULL == (rt = malloc(6*sizeof(char)))){
			printf("Error: Unable to allocate memory for rt.\n");
			exit(1);
		}
		if(NULL != (strcpy(rs, which_reg(oper[2]))))strcat(new_field, rs);
		else printf("Error:%s:line:%d - Not supported register %s\n", argv[1], line_n, oper[0]);
		strcat(new_field, "_");
		if(NULL != (strcpy(rt, which_reg(oper[0])))) strcat(new_field, rt);
		else printf("Error:%s:line:%d - Not supported register %s\n", argv[1], line_n, oper[1]);
		strcat(new_field, "_");
		// ADDRESS (IMMEDIATE)
		sscanf(oper[1], "%d ", &offset);	// convert the string to integer
		// Convert the decimal to binary representation
		if(!dec_to_bin(offset, 32, &binary)) return(NULL);
//		printf("binary offset: %s\n", binary);
		binary += 16;
		strcat(new_field, binary);
		strcat(new_field, "\0");
		// <-- END
		// Optional
		free(rs);
		free(rt);
		
		return(new_field);
    }
	else if(!strcmp(op, "NOP") || !strcmp(op, "HALT")) {
		// Initialize the input/output string just to be sure
		for(i=0; i<strlen(new_field); ++i) new_field[i] = '\0';

		// MAKE UP THE FIELDS -->
		// OPCODE
		if(!strcmp(op, "NOP"))	    strcat(new_field,NOP );
		else if(!strcmp(op, "HALT"))	strcat(new_field,HALT );
		strcat(new_field, "_");
		strcat(new_field, "00000");	// RS
		strcat(new_field, "_");
		strcat(new_field, "00000");	// RT
		strcat(new_field, "_");
		strcat(new_field, "00000");	// RD
		strcat(new_field, "_");
		strcat(new_field, "00000");	// SHAMT
		strcat(new_field, "_");
		strcat(new_field, "000000");// FUNCT
		strcat(new_field, "_");
		strcat(new_field, "\0");
		// <-- END
		// Optional
		free(rs);
		free(rt);
		
		return(new_field);
	}
	
	return(NULL);
}


/*
 * Checks if instruction has R-Format
 */
char *is_r_format(int line_n, char **argv, const char *op, char *new_field){
	
	char *rs, *rt, *rd;
	unsigned int i;
	char *regs[] = {"\0\0\0\0\0\0", "\0\0\0\0\0\0", "\0\0\0\0\0\0"};
	char *other_tokens;
	char *binary;
	int offset;

	if(!strcmp(op, "SLL") || !strcmp(op, "SRL") || !strcmp(op, "SRA") \
		!strcmp(op, "SLLV") || !strcmp(op, "SRLV") || !strcmp(op, "SRAV") \
        !strcmp(op, "ADDU") || !strcmp(op, "SUBU") || !strcmp(op, "OR") \
        !strcmp(op, "XOR") || !strcmp(op, "AND") || !strcmp(op, "NOR") \
        !strcmp(op, "SLT")){

		// Walk through other tokens
		i = 0;
		while(i < 3){	// strtok() saves the previous state :P
			regs[i] = strtok(NULL, delim);
			i++;
		}
		// Take away the other tokens, just to initialize the state of strtok()
		while(other_tokens != NULL) other_tokens = strtok(NULL, delim);
	
		// Initialize the input/output string just to be sure
		for(i=0; i<strlen(new_field); ++i) new_field[i] = '\0';
		
		
		// MAKE UP THE FIELDS -->
		// OPCODE
		strcat(new_field, R_FORMAT);
		strcat(new_field, "_");
		
		// REGISTERS
		if(NULL == (rs = malloc(6*sizeof(char)))){
			printf("Error: Unable to allocate memory for rs.\n");
			exit(1);
		}
		if(NULL == (rt = malloc(6*sizeof(char)))){
			printf("Error: Unable to allocate memory for rt.\n");
			exit(1);
		}
		if(NULL == (rd = malloc(6*sizeof(char)))){
			printf("Error: Unable to allocate memory for rd.\n");
			exit(1);
		}
        if(!strcmp(op, "SLL") || !strcmp(op, "SRL") || !strcmp(op, "SRA")) {
		    strcat(new_field, "00000");	// rs
		    strcat(new_field, "_");
		    if(NULL != (strcpy(rt, which_reg(regs[1])))) strcat(new_field, rt);
		    else printf("Error:%s:line:%d - Not supported register %s\n", argv[1], line_n, regs[2]);
		    strcat(new_field, "_");
		    if(NULL != (strcpy(rd, which_reg(regs[0])))) strcat(new_field, rd);
		    else printf("Error:%s:line:%d - Not supported register %s\n", argv[1], line_n, regs[0]);
		    strcat(new_field, "_");
		    // SHIFT AMOUNT
		    sscanf(regs[2], "%d ", &offset);	// convert the string to integer		
		    // Convert the decimal to binary representation
		    if(!dec_to_bin(offset, 32, &binary)) return(NULL);
            //printf("binary offset: %s\n", binary); HAY QUE VER ESTA PARTE
		    binary += 16;
		    strcat(new_field, binary);
		    strcat(new_field, "_");
        } else {
		    if(NULL != (strcpy(rs, which_reg(regs[1]))))strcat(new_field, rs);
		    else printf("Error:%s:line:%d - Not supported register %s\n", argv[1], line_n, regs[1]);
		    strcat(new_field, "_");
		    if(NULL != (strcpy(rt, which_reg(regs[2])))) strcat(new_field, rt);
		    else printf("Error:%s:line:%d - Not supported register %s\n", argv[1], line_n, regs[2]);
		    strcat(new_field, "_");
		    if(NULL != (strcpy(rd, which_reg(regs[0])))) strcat(new_field, rd);
		    else printf("Error:%s:line:%d - Not supported register %s\n", argv[1], line_n, regs[0]);
		    strcat(new_field, "_");  
		    // SHIFT AMOUNT
		    strcat(new_field, "00000");	// shamt
		    strcat(new_field, "_");
        }
		// FUNC
		if(!strcmp(op, "SLL"))	        strcat(new_field,SLL );
		else if(!strcmp(op, "SRL"))	    strcat(new_field,SRL );
		else if(!strcmp(op, "SRA"))	    strcat(new_field,SRA );
		else if(!strcmp(op, "SLLV"))	strcat(new_field,SLLV );
		else if(!strcmp(op, "SRLV"))	strcat(new_field,SRLV );
        else if(!strcmp(op, "SRAV"))	strcat(new_field,SRAV );
		else if(!strcmp(op, "ADDU"))	strcat(new_field,ADDU );
		else if(!strcmp(op, "SUBU"))	strcat(new_field,SUBU );
		else if(!strcmp(op, "OR"))	    strcat(new_field,OR );
        else if(!strcmp(op, "XOR"))	    strcat(new_field,XOR );
		else if(!strcmp(op, "AND"))	    strcat(new_field,AND );
		else if(!strcmp(op, "NOR"))	    strcat(new_field,NOR );
		else if(!strcmp(op, "SLT"))	    strcat(new_field,SLT );
		strcat(new_field, "\0");
		// <-- END
		
		// Optional
		//free(rs);
		//free(rt);
		//free(rd);
		
		return(new_field);
	}

	return(NULL);
}


/*
 * Check for legal registers and return the binary representation
 */
char *which_reg(const char *reg){
	
	if(NULL == reg) return(NULL);

	if(!strcmp(reg, "$0") || !strcmp(reg, "$zero")) return(REG0);
	else if(!strcmp(reg, "$1") || !strcmp(reg, "$at")) return(REG1);
	else if(!strcmp(reg, "$2") || !strcmp(reg, "$v0")) return(REG2);
	else if(!strcmp(reg, "$3") || !strcmp(reg, "$v1")) return(REG3);
	else if(!strcmp(reg, "$4") || !strcmp(reg, "$a0")) return(REG4);
	else if(!strcmp(reg, "$5") || !strcmp(reg, "$a1")) return(REG5);
	else if(!strcmp(reg, "$6") || !strcmp(reg, "$a2")) return(REG6);
	else if(!strcmp(reg, "$7") || !strcmp(reg, "$a3")) return(REG7);
	else if(!strcmp(reg, "$8") || !strcmp(reg, "$t0")) return(REG8);
	else if(!strcmp(reg, "$9") || !strcmp(reg, "$t1")) return(REG9);
	else if(!strcmp(reg, "$10") || !strcmp(reg, "$t2")) return(REG10);
	else if(!strcmp(reg, "$11") || !strcmp(reg, "$t3")) return(REG11);
	else if(!strcmp(reg, "$12") || !strcmp(reg, "$t4")) return(REG12);
	else if(!strcmp(reg, "$13") || !strcmp(reg, "$t5")) return(REG13);
	else if(!strcmp(reg, "$14") || !strcmp(reg, "$t6")) return(REG14);
	else if(!strcmp(reg, "$15") || !strcmp(reg, "$t7")) return(REG15);
	else if(!strcmp(reg, "$16") || !strcmp(reg, "$s0")) return(REG16);
	else if(!strcmp(reg, "$17") || !strcmp(reg, "$s1")) return(REG17);
	else if(!strcmp(reg, "$18") || !strcmp(reg, "$s2")) return(REG18);
	else if(!strcmp(reg, "$19") || !strcmp(reg, "$s3")) return(REG19);
	else if(!strcmp(reg, "$20") || !strcmp(reg, "$s4")) return(REG20);
	else if(!strcmp(reg, "$21") || !strcmp(reg, "$s5")) return(REG21);
	else if(!strcmp(reg, "$22") || !strcmp(reg, "$s6")) return(REG22);
	else if(!strcmp(reg, "$23") || !strcmp(reg, "$s7")) return(REG23);
	else if(!strcmp(reg, "$24") || !strcmp(reg, "$t8")) return(REG24);
	else if(!strcmp(reg, "$25") || !strcmp(reg, "$t9")) return(REG25);
	else if(!strcmp(reg, "$26") || !strcmp(reg, "$k0")) return(REG26);
	else if(!strcmp(reg, "$27") || !strcmp(reg, "$k1")) return(REG27);
	else if(!strcmp(reg, "$28") || !strcmp(reg, "$gp")) return(REG28);
	else if(!strcmp(reg, "$29") || !strcmp(reg, "$sp")) return(REG29);
	else if(!strcmp(reg, "$30") || !strcmp(reg, "$fp")) return(REG30);
	else if(!strcmp(reg, "$31") || !strcmp(reg, "$ra")) return(REG31);
	return(NULL);
}


/* 
 * Input: Takes a decimal integer, the size of the representation (=32) and an
 *         address to the string result 
 * Output: Returns it's representation in binary system as a string and
 *         an integer: 0 for error, 1 for success.
 */
int dec_to_bin(int dec, const int size, char **bin){
	
	long long int mask = 0x8000000000000000;
	int i;
	
	if(size != 32) return(0);
	
	/* Memory allocation for the string */
	if(NULL == (*bin = malloc(size * sizeof(char)))) return(0);

	/* Creation of the Binary Representation */
	strcpy(*bin, mask == (dec & mask) ? "1" : "0");
	for(dec <<= 1, i = 1; i < size; ++ i, dec <<= 1)
		strcat(*bin, mask == (dec & mask) ? "1" : "0");
	
	return(1);
	
}
