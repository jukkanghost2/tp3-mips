#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include "define_opcode_reg.h"

int is_i_format(int , char **, const char *, char *);
int is_r_format(int , char **, const char *, char *);
int is_j_format(int , char **, const char *, char *);
int dec_to_bin(int , const int , char *);
char *which_reg(const char *);

int main(int argc, char **argv){

	FILE *fpr, *fpw;            /* declare the file pointer */
	char *line;	// from input
	int line_n;		// for input
	size_t line_length = 80;
	size_t read_characters;
	int address;	// for output
	char *new_field;
	char final_fld[200];
	unsigned int i;
    char* delim = " ";
	/* File manipulation */
	// open input file .txt with assembler
	if(NULL == (fpr = fopen(argv[1], "r"))){
		fprintf(stderr, "Error: Can't open .masm input file!\n");
		exit(2);
	}
	
	// open output file .txt with machine code
	if(NULL == (fpw = fopen(argv[2], "w"))){
		fprintf(stderr, "Error: Can't open .mbin output file!\n");
		exit(2);
	}
	
	char *op;
	
	if(NULL == (new_field = malloc(33*sizeof(char)))){
		fprintf(stderr, "Error: Can't allocate memory for the line buffer!\n");
		exit(3);
	}
	
	if(NULL == (line = malloc(line_length*sizeof(char)))){
		fprintf(stderr, "Error: Can't allocate memory for the line buffer!\n");
		exit(3);
	}
	
	line_n = 1;
	while( (read_characters = getline(&line, &line_length, fpr)) != -1){

		printf("linea de asm %s\n", line);
		/*  STAGE 1  */
		// Get the first token to check the opcode
		op = strtok(line, delim);
       printf("%s\n", op);
		/*  STAGE 2  */
		// Check the instruction format &&
		// Return the field parsed
		
		if(0 == is_r_format(line_n, argv, op, new_field)){
		printf("r-format\n");
			/*  STAGE 3  */
			// A - Initialization of final_fld
			for(i=0; i<strlen(final_fld); ++i){
				final_fld[i] = '\0';
			}		
			// B -  Write to the output file
			strcpy(final_fld, new_field);
			strcat(final_fld, "\n");
			printf("%s", final_fld);
			fputs(final_fld, fpw);
		}
		else if(0 == is_i_format(line_n, argv, op, new_field)){
		printf("i-format\n");
			/*  STAGE 3  */
			// A - Initialization of final_fld
			for(i=0; i<strlen(final_fld); ++i){
				final_fld[i] = '\0';
			}
			// B -  Write to the output file
			strcpy(final_fld, new_field);
			strcat(final_fld, "\n");
			printf("%s", final_fld);
			fputs(final_fld, fpw);
		}
		else if(0 == is_j_format(line_n, argv, op, new_field)){
		printf("j-format\n");
			/*  STAGE 3  */
			// A - Initialization of final_fld
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
int is_i_format(int line_n, char **argv, const char *op, char *new_field){
    char* delim = " ,.()";
	int i;
	char *rs, *rt;
	int offset;

	if(NULL == (rs = malloc(6*sizeof(char)))){
			printf("Error: Unable to allocate memory for rs.\n");
			exit(1);
		}
		if(NULL == (rt = malloc(6*sizeof(char)))){
			printf("Error: Unable to allocate memory for rs.\n");
			exit(1);
		}
		
	if(!strcmp(op, "ADDI") || !strcmp(op, "ANDI") || !strcmp(op, "ORI") \
     || !strcmp(op, "XORI") || !strcmp(op, "SLTI") ){
		char *oper[] = {"\0\0\0\0\0\0", "\0\0\0\0\0\0", "\0\0\0\0\0\0\0\0\0\0\0\0\0"};
		char binary[16];
		// Walk through other tokens
		i = 0;
		while(i < 3){	// strtok() saves the previous state :P
			oper[i] = strtok(NULL, delim);
            // printf("%s\n", oper[i]);
			i++;
		}
		// Initialize the input/output string just to be sure
		for(i=0; i<strlen(new_field); ++i) new_field[i] = '\0';
		// MAKE UP THE FIELDS -->
		// OPCODE
		if(!strcmp(op, "ADDI"))	strcat(new_field,ADDI );
        else if(!strcmp(op, "ANDI"))	strcat(new_field,ANDI );
		else if(!strcmp(op, "ORI"))	strcat(new_field,ORI );
		else if(!strcmp(op, "XORI"))	strcat(new_field,XORI );
        else if(!strcmp(op, "SLTI"))	    strcat(new_field,SLTI );
		strcat(new_field, "_");
		printf("%s\n", new_field);
		
		if(NULL != (strcpy(rs, which_reg(oper[1]))))strcat(new_field, rs);
		else printf("Error:%s:line:%d - Not supported register %s\n", argv[1], line_n, oper[0]);
		strcat(new_field, "_");
		printf("%s\n", new_field);
		if(NULL != (strcpy(rt, which_reg(oper[0])))) strcat(new_field, rt);
		else printf("Error:%s:line:%d - Not supported register %s\n", argv[1], line_n, oper[0]);
		strcat(new_field, "_");
		printf("%s\n", new_field);
		// IMMEDIATE
		sscanf(oper[2], "%d", &offset);	// convert the string to integer
		for (int i = 15; i >= 0; i--) 
		{
			if (offset % 2 == 0) {binary[i] = '0';} 
			else  {binary[i] = '1';}
			offset = offset / 2;
		}
		binary[16] = '\0';
		printf("%s\n", binary);
		strncat(new_field, binary, 16);
		printf("%s\n", new_field);
		strcat(new_field, "\0");
		printf("%s\n", new_field);
		// <-- END
		free(rs);
		free(rt);
		return(0);
	}
    else if(!strcmp(op, "LUI")) {
		char *oper[] = {"\0\0\0\0\0\0", "\0\0\0\0\0\0\0\0\0\0\0\0\0"};
		char binary[16];
		// Walk through other tokens
		i = 0;
		while(i < 2){	// strtok() saves the previous state :P
			oper[i] = strtok(NULL, delim);
            printf("lui %s\n", oper[i]);
			i++;
		}
		// Initialize the input/output string just to be sure
		for(i=0; i<strlen(new_field); ++i) new_field[i] = '\0';
		//OPCODE
		strcat(new_field, LUI);
		strcat(new_field, "_");
		// RS
		strcat(new_field, "00000");
		strcat(new_field, "_");
		if(NULL != (strcpy(rt, which_reg(oper[0])))) strcat(new_field, rt);
		else printf("Error:%s:line:%d - Not supported register %s\n", argv[1], line_n, oper[0]);
		strcat(new_field, "_");
		printf("%s\n", new_field);
		// IMMEDIATE
		sscanf(oper[1], "%d", &offset);	// convert the string to integer		
		// Convert the decimal to binary representation
		for (int i = 15; i >= 0; i--) 
		{
			if (offset % 2 == 0) {binary[i] = '0';} 
			else  {binary[i] = '1';}
			offset = offset / 2;
		}
		binary[16] = '\0';
		printf("%s\n", binary);
		strncat(new_field, binary, 16);
		printf("%s\n", new_field);
		strcat(new_field, "\0");
		printf("%s\n", new_field);
		// <-- END
		free(rs);
		free(rt);
		return(0);
	}
    else if(!strcmp(op, "BEQ") || !strcmp(op, "BNE")) {
		char *oper[] = {"\0\0\0\0\0\0", "\0\0\0\0\0\0", "\0\0\0\0\0\0\0\0\0\0\0\0\0"};
		char binary[16];
		// Walk through other tokens
		i = 0;
		while(i < 3){	// strtok() saves the previous state :P
			oper[i] = strtok(NULL, delim);
			// printf("%s\n", oper[i]);
			i++;
		}
		// Initialize the input/output string just to be sure
		for(i=0; i<strlen(new_field); ++i) new_field[i] = '\0';
		// MAKE UP THE FIELDS -->
		// OPCODE
		if(!strcmp(op, "BEQ"))	    strcat(new_field,BEQ );
		else if(!strcmp(op, "BNE"))	strcat(new_field,BNE );
		strcat(new_field, "_");
		printf("%s\n", new_field);

		if(NULL != (strcpy(rs, which_reg(oper[0]))))strcat(new_field, rs);
		else printf("Error:%s:line:%d - Not supported register %s\n", argv[1], line_n, oper[0]);
		strcat(new_field, "_");
		if(NULL != (strcpy(rt, which_reg(oper[1])))) strcat(new_field, rt);
		else printf("Error:%s:line:%d - Not supported register %s\n", argv[1], line_n, oper[1]);
		strcat(new_field, "_");
		// ADDRESS (IMMEDIATE)
		sscanf(oper[2], "%d", &offset);	// convert the string to integer
		// Convert the decimal to binary representation
		for (int i = 15; i >= 0; i--) 
		{
			if (offset % 2 == 0) {binary[i] = '0';} 
			else  {binary[i] = '1';}
			offset = offset / 2;
		}
		binary[16] = '\0';
		printf("%s\n", binary);
		strncat(new_field, binary, 16);
		printf("%s\n", new_field);
		strcat(new_field, "\0");
		printf("%s\n", new_field);
		// <-- END
		free(rs);
		free(rt);
		return(0);
	}
	else if(!strcmp(op, "LW") || !strcmp(op, "LWU") || !strcmp(op, "SW") \
			|| !strcmp(op, "LB") || !strcmp(op, "LBU") || !strcmp(op, "LH") \
			|| !strcmp(op, "LHU") || !strcmp(op, "SB") || !strcmp(op, "SH")) {
        char *oper[] = {"\0\0\0\0\0\0", "\0\0\0\0\0\0\0\0\0\0\0\0\0", "\0\0\0\0\0\0"};
		char binary[16];
		// Walk through other tokens
		i = 0;
		while(i < 3){	// strtok() saves the previous state :P
			oper[i] = strtok(NULL, delim);
			// printf("%s\n", oper[i]);
			i++;
		}
		// Initialize the input/output string just to be sure
		for(i=0; i<strlen(new_field); ++i) new_field[i] = '\0';
		// MAKE UP THE FIELDS -->
		// OPCODE
		if(!strcmp(op, "LW"))	    strcat(new_field,LW );
		else if(!strcmp(op, "LWU"))	strcat(new_field,LWU );
		else if(!strcmp(op, "LB"))	strcat(new_field,LB );
		else if(!strcmp(op, "LBU"))	strcat(new_field,LBU );
		else if(!strcmp(op, "LH"))	strcat(new_field,LH );
		else if(!strcmp(op, "LHU"))	strcat(new_field,LHU );
		else if(!strcmp(op, "SW"))	strcat(new_field,SW );
		else if(!strcmp(op, "SB"))	strcat(new_field,SB );
		else if(!strcmp(op, "SH"))	strcat(new_field,SH );
		strcat(new_field, "_");

		if(NULL != (strcpy(rs, which_reg(oper[2]))))strcat(new_field, rs);
		else printf("Error:%s:line:%d - Not supported register %s\n", argv[1], line_n, oper[2]);
		strcat(new_field, "_");
		if(NULL != (strcpy(rt, which_reg(oper[0])))) strcat(new_field, rt);
		else printf("Error:%s:line:%d - Not supported register %s\n", argv[1], line_n, oper[0]);
		strcat(new_field, "_");
		// ADDRESS (IMMEDIATE)
		sscanf(oper[1], "%d", &offset);	// convert the string to integer
		// Convert the decimal to binary representation
		printf("offset: %d\n", offset);
		for (int i = 15; i >= 0; i--) 
		{
			if (offset % 2 == 0) {binary[i] = '0';} 
			else  {binary[i] = '1';}
			offset = offset / 2;
		}
		binary[16] = '\0';
		printf("%s\n", binary);
		strncat(new_field, binary, 16);
		printf("%s\n", new_field);
		strcat(new_field, "\0");
		printf("%s\n", new_field);
		// <-- END
		free(rs);
		free(rt);
		return(0);
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
		strcat(new_field, "\0");
		// <-- END
		free(rs);
		free(rt);
		return(0);
	}
	else if(!strcmp(op, "J") || !strcmp(op, "JAL")) {
		char *oper = {"\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"};
		char binary[26];
		// Walk through other tokens
		oper = strtok(NULL, delim);
		// printf("%s\n", oper);
		// Initialize the input/output string just to be sure
		for(i=0; i<strlen(new_field); ++i) new_field[i] = '\0';
		// MAKE UP THE FIELDS -->
		// OPCODE
		if(!strcmp(op, "J"))	    strcat(new_field,J );
		else if(!strcmp(op, "JAL"))	    strcat(new_field,JAL );
		strcat(new_field, "_");
		// ADDRESS (IMMEDIATE)
		sscanf(oper, "%d", &offset);	// convert the string to integer
		// Convert the decimal to binary representation
		for (int i = 25; i >= 0; i--) 
		{
			if (offset % 2 == 0) {binary[i] = '0';} 
			else  {binary[i] = '1';}
			offset = offset / 2;
		}
		binary[26] = '\0';
		printf("%s\n", binary);
		strncat(new_field, binary, 26);
		printf("%s\n", new_field);
		strcat(new_field, "\0");
		printf("%s\n", new_field);
		// <-- END
		free(rs);
		free(rt);
		return(0);
	}
		free(rs);
		free(rt);
		return(-1);
}

/*
 * Checks if instruction has J-Format
 */
int is_j_format(int line_n, char **argv, const char *op, char *new_field){
	char* delim = " ,.";
	char *rs, *rd;
	char *regs[] = {"\0\0\0\0\0\0", "\0\0\0\0\0\0"};
	int i;
// REGISTERS
		if(NULL == (rs = malloc(6*sizeof(char)))){
			printf("Error: Unable to allocate memory for rs.\n");
			exit(1);
		}
		if(NULL == (rd = malloc(6*sizeof(char)))){
			printf("Error: Unable to allocate memory for rs.\n");
			exit(1);
		}
	if(!strcmp(op, "JR")){
		regs[0] = strtok(NULL, delim);
		// Initialize the input/output string just to be sure
		for(i=0; i<strlen(new_field); ++i) new_field[i] = '\0';
		// MAKE UP THE FIELDS -->
		// OPCODE
		strcat(new_field, R_FORMAT);
		strcat(new_field, "_");
		if(NULL != (strcpy(rs, which_reg(regs[0])))) strcat(new_field, rs);
		else printf("Error:%s:line:%d - Not supported register %s\n", argv[1], line_n, regs[0]);
		strcat(new_field, "_");
		strcat(new_field, "000000000000000");
		strcat(new_field, "_");
		strcat(new_field, JR);
		strcat(new_field, "\0");
		free(rs);
		free(rd);
		return (0);
	}
	else if(!strcmp(op, "JALR")){
		i=0;
		while(i<2) {
			regs[i] = strtok(NULL, delim);
			i++;
		}
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
		if(NULL == (rd = malloc(6*sizeof(char)))){
			printf("Error: Unable to allocate memory for rs.\n");
			exit(1);
		}
		if(NULL != (strcpy(rs, which_reg(regs[1])))) strcat(new_field, rs);
		else printf("Error:%s:line:%d - Not supported register %s\n", argv[1], line_n, regs[1]);
		strcat(new_field, "_");
		strcat(new_field, "00000");
		strcat(new_field, "_");
		if(NULL != (strcpy(rd, which_reg(regs[0])))) strcat(new_field, rd);
		else printf("Error:%s:line:%d - Not supported register %s\n", argv[1], line_n, regs[0]);
		strcat(new_field, "_");
		strcat(new_field, "00000");
		strcat(new_field, "_");
		strcat(new_field, JALR);
		strcat(new_field, "\0");
		free(rs);
		free(rd);
		return (0);
	}
	free(rs);
	free(rd);
	return (-1);
}

/*
 * Checks if instruction has R-Format
 */
int is_r_format(int line_n, char **argv, const char *op, char *new_field){
    char* delim = " ,.()";
	char *rs, *rt, *rd;
	int i;
	char *regs[] = {"\0\0\0\0\0\0", "\0\0\0\0\0\0", "\0\0\0\0\0\0"};
	int offset;

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
	if( !strcmp(op, "SLLV") || !strcmp(op, "SRLV") || !strcmp(op, "SRAV") \
        || !strcmp(op, "ADDU") || !strcmp(op, "SUBU") || !strcmp(op, "OR") \
        || !strcmp(op, "XOR") || !strcmp(op, "AND") || !strcmp(op, "NOR") \
        || !strcmp(op, "SLT")){
		// Walk through other tokens
		i = 0;
		while(i < 3){	// strtok() saves the previous state :P
			regs[i] = strtok(NULL, delim);
		//	printf("%s\n", regs[i]);
			i++;
		}
		// Initialize the input/output string just to be sure
		for(i=0; i<strlen(new_field); ++i) new_field[i] = '\0';
		// MAKE UP THE FIELDS -->
		// OPCODE
		strcat(new_field, R_FORMAT);
		strcat(new_field, "_");
		//printf("%s\n", new_field);
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
		if(!strcmp(op, "SLLV"))	strcat(new_field,SLLV );
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
		free(rs);
		free(rt);
		free(rd);
		return(0);
		}
        else if(!strcmp(op, "SLL") || !strcmp(op, "SRL") || !strcmp(op, "SRA")) {
			char binary[5];
			// Walk through other tokens
			i = 0;
			while(i < 3){	// strtok() saves the previous state :P
				regs[i] = strtok(NULL, delim);
			//	printf("%s\n", regs[i]);
				i++;
			}
			// Initialize the input/output string just to be sure
			for(i=0; i<strlen(new_field); ++i) new_field[i] = '\0';
			/* Memory allocation for the string */
		    strcat(new_field, "00000");	// rs
		    strcat(new_field, "_");
			printf("%s\n", new_field);
		    if(NULL != (strcpy(rt, which_reg(regs[1])))) strcat(new_field, rt);
		    else printf("Error:%s:line:%d - Not supported register %s\n", argv[1], line_n, regs[1]);
		    strcat(new_field, "_");
			printf("%s\n", new_field);
		    if(NULL != (strcpy(rd, which_reg(regs[0])))) strcat(new_field, rd);
		    else printf("Error:%s:line:%d - Not supported register %s\n", argv[1], line_n, regs[0]);
		    strcat(new_field, "_");
			printf("%s\n", new_field);
		    // SHIFT AMOUNT
		    sscanf(regs[2], "%d", &offset);	// convert the string to integer		
		    // Convert the decimal to binary representation
		    for (int i = 4; i >= 0; i--) 
			{
				if (offset % 2 == 0) {binary[i] = '0';} 
				else  {binary[i] = '1';}
				offset = offset / 2;
			}
			binary[5] = '\0';
			printf("%s\n", binary);
			strncat(new_field, binary, 5);
			printf("%s\n", new_field);
			strcat(new_field, "\0");
			printf("%s\n", new_field);
			// FUNC
			if(!strcmp(op, "SLL"))	        strcat(new_field,SLL );
			else if(!strcmp(op, "SRL"))	    strcat(new_field,SRL );
			else if(!strcmp(op, "SRA"))	    strcat(new_field,SRA );
			strcat(new_field, "\0");
			// <-- END
			free(rs);
			free(rt);
			free(rd);
			return(0);
	}
	free(rs);
	free(rt);
	free(rd);
	return(-1);
}

/*
 * Check for legal registers and return the binary representation
 */
char *which_reg(const char *reg){
	if(NULL == reg) return(NULL);
	if(!strcmp(reg, "$0") || !strcmp(reg, "$zero")) return(REG0);
	else if(!strcmp(reg, "$1") || !strcmp(reg, "$at")) {return(REG1);}
	else if(!strcmp(reg, "$2") || !strcmp(reg, "$v0")) {return(REG2);}
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
