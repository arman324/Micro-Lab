
;CodeVisionAVR C Compiler V3.12 Advanced
;(C) Copyright 1998-2014 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com

;Build configuration    : Debug
;Chip type              : ATmega16
;Program type           : Application
;Clock frequency        : 8.000000 MHz
;Memory model           : Small
;Optimize for           : Size
;(s)printf features     : int, width
;(s)scanf features      : int, width
;External RAM size      : 0
;Data Stack size        : 256 byte(s)
;Heap size              : 0 byte(s)
;Promote 'char' to 'int': Yes
;'char' is unsigned     : Yes
;8 bit enums            : Yes
;Global 'const' stored in FLASH: No
;Enhanced function parameter passing: Yes
;Enhanced core instructions: On
;Automatic register allocation for global variables: On
;Smart register allocation: On

	#define _MODEL_SMALL_

	#pragma AVRPART ADMIN PART_NAME ATmega16
	#pragma AVRPART MEMORY PROG_FLASH 16384
	#pragma AVRPART MEMORY EEPROM 512
	#pragma AVRPART MEMORY INT_SRAM SIZE 1024
	#pragma AVRPART MEMORY INT_SRAM START_ADDR 0x60

	#define CALL_SUPPORTED 1

	.LISTMAC
	.EQU UDRE=0x5
	.EQU RXC=0x7
	.EQU USR=0xB
	.EQU UDR=0xC
	.EQU SPSR=0xE
	.EQU SPDR=0xF
	.EQU EERE=0x0
	.EQU EEWE=0x1
	.EQU EEMWE=0x2
	.EQU EECR=0x1C
	.EQU EEDR=0x1D
	.EQU EEARL=0x1E
	.EQU EEARH=0x1F
	.EQU WDTCR=0x21
	.EQU MCUCR=0x35
	.EQU GICR=0x3B
	.EQU SPL=0x3D
	.EQU SPH=0x3E
	.EQU SREG=0x3F

	.DEF R0X0=R0
	.DEF R0X1=R1
	.DEF R0X2=R2
	.DEF R0X3=R3
	.DEF R0X4=R4
	.DEF R0X5=R5
	.DEF R0X6=R6
	.DEF R0X7=R7
	.DEF R0X8=R8
	.DEF R0X9=R9
	.DEF R0XA=R10
	.DEF R0XB=R11
	.DEF R0XC=R12
	.DEF R0XD=R13
	.DEF R0XE=R14
	.DEF R0XF=R15
	.DEF R0X10=R16
	.DEF R0X11=R17
	.DEF R0X12=R18
	.DEF R0X13=R19
	.DEF R0X14=R20
	.DEF R0X15=R21
	.DEF R0X16=R22
	.DEF R0X17=R23
	.DEF R0X18=R24
	.DEF R0X19=R25
	.DEF R0X1A=R26
	.DEF R0X1B=R27
	.DEF R0X1C=R28
	.DEF R0X1D=R29
	.DEF R0X1E=R30
	.DEF R0X1F=R31

	.EQU __SRAM_START=0x0060
	.EQU __SRAM_END=0x045F
	.EQU __DSTACK_SIZE=0x0100
	.EQU __HEAP_SIZE=0x0000
	.EQU __CLEAR_SRAM_SIZE=__SRAM_END-__SRAM_START+1

	.MACRO __CPD1N
	CPI  R30,LOW(@0)
	LDI  R26,HIGH(@0)
	CPC  R31,R26
	LDI  R26,BYTE3(@0)
	CPC  R22,R26
	LDI  R26,BYTE4(@0)
	CPC  R23,R26
	.ENDM

	.MACRO __CPD2N
	CPI  R26,LOW(@0)
	LDI  R30,HIGH(@0)
	CPC  R27,R30
	LDI  R30,BYTE3(@0)
	CPC  R24,R30
	LDI  R30,BYTE4(@0)
	CPC  R25,R30
	.ENDM

	.MACRO __CPWRR
	CP   R@0,R@2
	CPC  R@1,R@3
	.ENDM

	.MACRO __CPWRN
	CPI  R@0,LOW(@2)
	LDI  R30,HIGH(@2)
	CPC  R@1,R30
	.ENDM

	.MACRO __ADDB1MN
	SUBI R30,LOW(-@0-(@1))
	.ENDM

	.MACRO __ADDB2MN
	SUBI R26,LOW(-@0-(@1))
	.ENDM

	.MACRO __ADDW1MN
	SUBI R30,LOW(-@0-(@1))
	SBCI R31,HIGH(-@0-(@1))
	.ENDM

	.MACRO __ADDW2MN
	SUBI R26,LOW(-@0-(@1))
	SBCI R27,HIGH(-@0-(@1))
	.ENDM

	.MACRO __ADDW1FN
	SUBI R30,LOW(-2*@0-(@1))
	SBCI R31,HIGH(-2*@0-(@1))
	.ENDM

	.MACRO __ADDD1FN
	SUBI R30,LOW(-2*@0-(@1))
	SBCI R31,HIGH(-2*@0-(@1))
	SBCI R22,BYTE3(-2*@0-(@1))
	.ENDM

	.MACRO __ADDD1N
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	SBCI R22,BYTE3(-@0)
	SBCI R23,BYTE4(-@0)
	.ENDM

	.MACRO __ADDD2N
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	SBCI R24,BYTE3(-@0)
	SBCI R25,BYTE4(-@0)
	.ENDM

	.MACRO __SUBD1N
	SUBI R30,LOW(@0)
	SBCI R31,HIGH(@0)
	SBCI R22,BYTE3(@0)
	SBCI R23,BYTE4(@0)
	.ENDM

	.MACRO __SUBD2N
	SUBI R26,LOW(@0)
	SBCI R27,HIGH(@0)
	SBCI R24,BYTE3(@0)
	SBCI R25,BYTE4(@0)
	.ENDM

	.MACRO __ANDBMNN
	LDS  R30,@0+(@1)
	ANDI R30,LOW(@2)
	STS  @0+(@1),R30
	.ENDM

	.MACRO __ANDWMNN
	LDS  R30,@0+(@1)
	ANDI R30,LOW(@2)
	STS  @0+(@1),R30
	LDS  R30,@0+(@1)+1
	ANDI R30,HIGH(@2)
	STS  @0+(@1)+1,R30
	.ENDM

	.MACRO __ANDD1N
	ANDI R30,LOW(@0)
	ANDI R31,HIGH(@0)
	ANDI R22,BYTE3(@0)
	ANDI R23,BYTE4(@0)
	.ENDM

	.MACRO __ANDD2N
	ANDI R26,LOW(@0)
	ANDI R27,HIGH(@0)
	ANDI R24,BYTE3(@0)
	ANDI R25,BYTE4(@0)
	.ENDM

	.MACRO __ORBMNN
	LDS  R30,@0+(@1)
	ORI  R30,LOW(@2)
	STS  @0+(@1),R30
	.ENDM

	.MACRO __ORWMNN
	LDS  R30,@0+(@1)
	ORI  R30,LOW(@2)
	STS  @0+(@1),R30
	LDS  R30,@0+(@1)+1
	ORI  R30,HIGH(@2)
	STS  @0+(@1)+1,R30
	.ENDM

	.MACRO __ORD1N
	ORI  R30,LOW(@0)
	ORI  R31,HIGH(@0)
	ORI  R22,BYTE3(@0)
	ORI  R23,BYTE4(@0)
	.ENDM

	.MACRO __ORD2N
	ORI  R26,LOW(@0)
	ORI  R27,HIGH(@0)
	ORI  R24,BYTE3(@0)
	ORI  R25,BYTE4(@0)
	.ENDM

	.MACRO __DELAY_USB
	LDI  R24,LOW(@0)
__DELAY_USB_LOOP:
	DEC  R24
	BRNE __DELAY_USB_LOOP
	.ENDM

	.MACRO __DELAY_USW
	LDI  R24,LOW(@0)
	LDI  R25,HIGH(@0)
__DELAY_USW_LOOP:
	SBIW R24,1
	BRNE __DELAY_USW_LOOP
	.ENDM

	.MACRO __GETD1S
	LDD  R30,Y+@0
	LDD  R31,Y+@0+1
	LDD  R22,Y+@0+2
	LDD  R23,Y+@0+3
	.ENDM

	.MACRO __GETD2S
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	LDD  R24,Y+@0+2
	LDD  R25,Y+@0+3
	.ENDM

	.MACRO __PUTD1S
	STD  Y+@0,R30
	STD  Y+@0+1,R31
	STD  Y+@0+2,R22
	STD  Y+@0+3,R23
	.ENDM

	.MACRO __PUTD2S
	STD  Y+@0,R26
	STD  Y+@0+1,R27
	STD  Y+@0+2,R24
	STD  Y+@0+3,R25
	.ENDM

	.MACRO __PUTDZ2
	STD  Z+@0,R26
	STD  Z+@0+1,R27
	STD  Z+@0+2,R24
	STD  Z+@0+3,R25
	.ENDM

	.MACRO __CLRD1S
	STD  Y+@0,R30
	STD  Y+@0+1,R30
	STD  Y+@0+2,R30
	STD  Y+@0+3,R30
	.ENDM

	.MACRO __POINTB1MN
	LDI  R30,LOW(@0+(@1))
	.ENDM

	.MACRO __POINTW1MN
	LDI  R30,LOW(@0+(@1))
	LDI  R31,HIGH(@0+(@1))
	.ENDM

	.MACRO __POINTD1M
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __POINTW1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	.ENDM

	.MACRO __POINTD1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	LDI  R22,BYTE3(2*@0+(@1))
	LDI  R23,BYTE4(2*@0+(@1))
	.ENDM

	.MACRO __POINTB2MN
	LDI  R26,LOW(@0+(@1))
	.ENDM

	.MACRO __POINTW2MN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	.ENDM

	.MACRO __POINTW2FN
	LDI  R26,LOW(2*@0+(@1))
	LDI  R27,HIGH(2*@0+(@1))
	.ENDM

	.MACRO __POINTD2FN
	LDI  R26,LOW(2*@0+(@1))
	LDI  R27,HIGH(2*@0+(@1))
	LDI  R24,BYTE3(2*@0+(@1))
	LDI  R25,BYTE4(2*@0+(@1))
	.ENDM

	.MACRO __POINTBRM
	LDI  R@0,LOW(@1)
	.ENDM

	.MACRO __POINTWRM
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __POINTBRMN
	LDI  R@0,LOW(@1+(@2))
	.ENDM

	.MACRO __POINTWRMN
	LDI  R@0,LOW(@2+(@3))
	LDI  R@1,HIGH(@2+(@3))
	.ENDM

	.MACRO __POINTWRFN
	LDI  R@0,LOW(@2*2+(@3))
	LDI  R@1,HIGH(@2*2+(@3))
	.ENDM

	.MACRO __GETD1N
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __GETD2N
	LDI  R26,LOW(@0)
	LDI  R27,HIGH(@0)
	LDI  R24,BYTE3(@0)
	LDI  R25,BYTE4(@0)
	.ENDM

	.MACRO __GETB1MN
	LDS  R30,@0+(@1)
	.ENDM

	.MACRO __GETB1HMN
	LDS  R31,@0+(@1)
	.ENDM

	.MACRO __GETW1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	.ENDM

	.MACRO __GETD1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	LDS  R22,@0+(@1)+2
	LDS  R23,@0+(@1)+3
	.ENDM

	.MACRO __GETBRMN
	LDS  R@0,@1+(@2)
	.ENDM

	.MACRO __GETWRMN
	LDS  R@0,@2+(@3)
	LDS  R@1,@2+(@3)+1
	.ENDM

	.MACRO __GETWRZ
	LDD  R@0,Z+@2
	LDD  R@1,Z+@2+1
	.ENDM

	.MACRO __GETD2Z
	LDD  R26,Z+@0
	LDD  R27,Z+@0+1
	LDD  R24,Z+@0+2
	LDD  R25,Z+@0+3
	.ENDM

	.MACRO __GETB2MN
	LDS  R26,@0+(@1)
	.ENDM

	.MACRO __GETW2MN
	LDS  R26,@0+(@1)
	LDS  R27,@0+(@1)+1
	.ENDM

	.MACRO __GETD2MN
	LDS  R26,@0+(@1)
	LDS  R27,@0+(@1)+1
	LDS  R24,@0+(@1)+2
	LDS  R25,@0+(@1)+3
	.ENDM

	.MACRO __PUTB1MN
	STS  @0+(@1),R30
	.ENDM

	.MACRO __PUTW1MN
	STS  @0+(@1),R30
	STS  @0+(@1)+1,R31
	.ENDM

	.MACRO __PUTD1MN
	STS  @0+(@1),R30
	STS  @0+(@1)+1,R31
	STS  @0+(@1)+2,R22
	STS  @0+(@1)+3,R23
	.ENDM

	.MACRO __PUTB1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRB
	.ENDM

	.MACRO __PUTW1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRW
	.ENDM

	.MACRO __PUTD1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRD
	.ENDM

	.MACRO __PUTBR0MN
	STS  @0+(@1),R0
	.ENDM

	.MACRO __PUTBMRN
	STS  @0+(@1),R@2
	.ENDM

	.MACRO __PUTWMRN
	STS  @0+(@1),R@2
	STS  @0+(@1)+1,R@3
	.ENDM

	.MACRO __PUTBZR
	STD  Z+@1,R@0
	.ENDM

	.MACRO __PUTWZR
	STD  Z+@2,R@0
	STD  Z+@2+1,R@1
	.ENDM

	.MACRO __GETW1R
	MOV  R30,R@0
	MOV  R31,R@1
	.ENDM

	.MACRO __GETW2R
	MOV  R26,R@0
	MOV  R27,R@1
	.ENDM

	.MACRO __GETWRN
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __PUTW1R
	MOV  R@0,R30
	MOV  R@1,R31
	.ENDM

	.MACRO __PUTW2R
	MOV  R@0,R26
	MOV  R@1,R27
	.ENDM

	.MACRO __ADDWRN
	SUBI R@0,LOW(-@2)
	SBCI R@1,HIGH(-@2)
	.ENDM

	.MACRO __ADDWRR
	ADD  R@0,R@2
	ADC  R@1,R@3
	.ENDM

	.MACRO __SUBWRN
	SUBI R@0,LOW(@2)
	SBCI R@1,HIGH(@2)
	.ENDM

	.MACRO __SUBWRR
	SUB  R@0,R@2
	SBC  R@1,R@3
	.ENDM

	.MACRO __ANDWRN
	ANDI R@0,LOW(@2)
	ANDI R@1,HIGH(@2)
	.ENDM

	.MACRO __ANDWRR
	AND  R@0,R@2
	AND  R@1,R@3
	.ENDM

	.MACRO __ORWRN
	ORI  R@0,LOW(@2)
	ORI  R@1,HIGH(@2)
	.ENDM

	.MACRO __ORWRR
	OR   R@0,R@2
	OR   R@1,R@3
	.ENDM

	.MACRO __EORWRR
	EOR  R@0,R@2
	EOR  R@1,R@3
	.ENDM

	.MACRO __GETWRS
	LDD  R@0,Y+@2
	LDD  R@1,Y+@2+1
	.ENDM

	.MACRO __PUTBSR
	STD  Y+@1,R@0
	.ENDM

	.MACRO __PUTWSR
	STD  Y+@2,R@0
	STD  Y+@2+1,R@1
	.ENDM

	.MACRO __MOVEWRR
	MOV  R@0,R@2
	MOV  R@1,R@3
	.ENDM

	.MACRO __INWR
	IN   R@0,@2
	IN   R@1,@2+1
	.ENDM

	.MACRO __OUTWR
	OUT  @2+1,R@1
	OUT  @2,R@0
	.ENDM

	.MACRO __CALL1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	ICALL
	.ENDM

	.MACRO __CALL1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	CALL __GETW1PF
	ICALL
	.ENDM

	.MACRO __CALL2EN
	PUSH R26
	PUSH R27
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMRDW
	POP  R27
	POP  R26
	ICALL
	.ENDM

	.MACRO __CALL2EX
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	CALL __EEPROMRDD
	ICALL
	.ENDM

	.MACRO __GETW1STACK
	IN   R30,SPL
	IN   R31,SPH
	ADIW R30,@0+1
	LD   R0,Z+
	LD   R31,Z
	MOV  R30,R0
	.ENDM

	.MACRO __GETD1STACK
	IN   R30,SPL
	IN   R31,SPH
	ADIW R30,@0+1
	LD   R0,Z+
	LD   R1,Z+
	LD   R22,Z
	MOVW R30,R0
	.ENDM

	.MACRO __NBST
	BST  R@0,@1
	IN   R30,SREG
	LDI  R31,0x40
	EOR  R30,R31
	OUT  SREG,R30
	.ENDM


	.MACRO __PUTB1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RNS
	MOVW R26,R@0
	ADIW R26,@1
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	CALL __PUTDP1
	.ENDM


	.MACRO __GETB1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R30,Z
	.ENDM

	.MACRO __GETB1HSX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	.ENDM

	.MACRO __GETW1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R0,Z+
	LD   R31,Z
	MOV  R30,R0
	.ENDM

	.MACRO __GETD1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R0,Z+
	LD   R1,Z+
	LD   R22,Z+
	LD   R23,Z
	MOVW R30,R0
	.ENDM

	.MACRO __GETB2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R26,X
	.ENDM

	.MACRO __GETW2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	.ENDM

	.MACRO __GETD2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R1,X+
	LD   R24,X+
	LD   R25,X
	MOVW R26,R0
	.ENDM

	.MACRO __GETBRSX
	MOVW R30,R28
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	LD   R@0,Z
	.ENDM

	.MACRO __GETWRSX
	MOVW R30,R28
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	LD   R@0,Z+
	LD   R@1,Z
	.ENDM

	.MACRO __GETBRSX2
	MOVW R26,R28
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	LD   R@0,X
	.ENDM

	.MACRO __GETWRSX2
	MOVW R26,R28
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	LD   R@0,X+
	LD   R@1,X
	.ENDM

	.MACRO __LSLW8SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	CLR  R30
	.ENDM

	.MACRO __PUTB1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __CLRW1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R30
	.ENDM

	.MACRO __CLRD1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R30
	ST   X+,R30
	ST   X,R30
	.ENDM

	.MACRO __PUTB2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z,R26
	.ENDM

	.MACRO __PUTW2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z,R27
	.ENDM

	.MACRO __PUTD2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z+,R27
	ST   Z+,R24
	ST   Z,R25
	.ENDM

	.MACRO __PUTBSRX
	MOVW R30,R28
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	ST   Z,R@0
	.ENDM

	.MACRO __PUTWSRX
	MOVW R30,R28
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	ST   Z+,R@0
	ST   Z,R@1
	.ENDM

	.MACRO __PUTB1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __MULBRR
	MULS R@0,R@1
	MOVW R30,R0
	.ENDM

	.MACRO __MULBRRU
	MUL  R@0,R@1
	MOVW R30,R0
	.ENDM

	.MACRO __MULBRR0
	MULS R@0,R@1
	.ENDM

	.MACRO __MULBRRU0
	MUL  R@0,R@1
	.ENDM

	.MACRO __MULBNWRU
	LDI  R26,@2
	MUL  R26,R@0
	MOVW R30,R0
	MUL  R26,R@1
	ADD  R31,R0
	.ENDM

;NAME DEFINITIONS FOR GLOBAL VARIABLES ALLOCATED TO REGISTERS
	.DEF _count=R4
	.DEF _count_msb=R5
	.DEF _temp=R6
	.DEF _temp_msb=R7
	.DEF _firstSevenSeg=R8
	.DEF _firstSevenSeg_msb=R9
	.DEF _secondSevenSeg=R10
	.DEF _secondSevenSeg_msb=R11
	.DEF _thirdSevenSeg=R12
	.DEF _thirdSevenSeg_msb=R13

	.CSEG
	.ORG 0x00

;START OF CODE MARKER
__START_OF_CODE:

;INTERRUPT VECTORS
	JMP  __RESET
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00

;GLOBAL REGISTER VARIABLES INITIALIZATION
__REG_VARS:
	.DB  0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0
	.DB  0x0,0x0

_0x3:
	.DB  0x3F,0x0,0x6,0x0,0x5B,0x0,0x4F,0x0
	.DB  0x66,0x0,0x6D,0x0,0x7D,0x0,0x7,0x0
	.DB  0x7F,0x0,0x6F

__GLOBAL_INI_TBL:
	.DW  0x0A
	.DW  0x04
	.DW  __REG_VARS*2

	.DW  0x13
	.DW  _sevenSeg
	.DW  _0x3*2

_0xFFFFFFFF:
	.DW  0

#define __GLOBAL_INI_TBL_PRESENT 1

__RESET:
	CLI
	CLR  R30
	OUT  EECR,R30

;INTERRUPT VECTORS ARE PLACED
;AT THE START OF FLASH
	LDI  R31,1
	OUT  GICR,R31
	OUT  GICR,R30
	OUT  MCUCR,R30

;CLEAR R2-R14
	LDI  R24,(14-2)+1
	LDI  R26,2
	CLR  R27
__CLEAR_REG:
	ST   X+,R30
	DEC  R24
	BRNE __CLEAR_REG

;CLEAR SRAM
	LDI  R24,LOW(__CLEAR_SRAM_SIZE)
	LDI  R25,HIGH(__CLEAR_SRAM_SIZE)
	LDI  R26,__SRAM_START
__CLEAR_SRAM:
	ST   X+,R30
	SBIW R24,1
	BRNE __CLEAR_SRAM

;GLOBAL VARIABLES INITIALIZATION
	LDI  R30,LOW(__GLOBAL_INI_TBL*2)
	LDI  R31,HIGH(__GLOBAL_INI_TBL*2)
__GLOBAL_INI_NEXT:
	LPM  R24,Z+
	LPM  R25,Z+
	SBIW R24,0
	BREQ __GLOBAL_INI_END
	LPM  R26,Z+
	LPM  R27,Z+
	LPM  R0,Z+
	LPM  R1,Z+
	MOVW R22,R30
	MOVW R30,R0
__GLOBAL_INI_LOOP:
	LPM  R0,Z+
	ST   X+,R0
	SBIW R24,1
	BRNE __GLOBAL_INI_LOOP
	MOVW R30,R22
	RJMP __GLOBAL_INI_NEXT
__GLOBAL_INI_END:

;HARDWARE STACK POINTER INITIALIZATION
	LDI  R30,LOW(__SRAM_END-__HEAP_SIZE)
	OUT  SPL,R30
	LDI  R30,HIGH(__SRAM_END-__HEAP_SIZE)
	OUT  SPH,R30

;DATA STACK POINTER INITIALIZATION
	LDI  R28,LOW(__SRAM_START+__DSTACK_SIZE)
	LDI  R29,HIGH(__SRAM_START+__DSTACK_SIZE)

	JMP  _main

	.ESEG
	.ORG 0

	.DSEG
	.ORG 0x160

	.CSEG
;/*
; * Source.c
; *
; * Created: 9/30/2020 3:42:41 PM
; * Author: Arman Riasi
; */
;
;#include <io.h>
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x40
	.EQU __sm_mask=0xB0
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0xA0
	.EQU __sm_ext_standby=0xB0
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif
;#include <delay.h>
;
;void question_01();
;void question_02();
;void question_03();
;void question_04();
;void question_05();
;void question_06();
;
;
;int count = 0;
;int temp = 0;
;unsigned int firstSevenSeg = 0;
;unsigned int secondSevenSeg = 0;
;unsigned int thirdSevenSeg = 0;
;unsigned int fourthSevenSeg = 0;
;unsigned int sevenSeg[] = {
;    0b00111111, //showing number 0 on 7_seg
;    0b00000110, //showing number 1 on 7_seg
;    0b01011011, //showing number 2 on 7_seg
;    0b01001111, //showing number 3 on 7_seg
;    0b01100110, //showing number 4 on 7_seg
;    0b01101101, //showing number 5 on 7_seg
;    0b01111101, //showing number 6 on 7_seg
;    0b00000111, //showing number 7 on 7_seg
;    0b01111111, //showing number 8 on 7_seg
;    0b01101111, //showing number 9 on 7_seg
;};

	.DSEG
;
;
;void main(void)
; 0000 0028 {

	.CSEG
_main:
; .FSTART _main
; 0000 0029     //question_01(); //calling question one
; 0000 002A     //question_02(); //calling question two
; 0000 002B     //question_03(); //calling question three
; 0000 002C     //question_04(); //calling question four
; 0000 002D     //question_05(); //calling question five
; 0000 002E     //question_06(); //calling question six
; 0000 002F 
; 0000 0030     //////////quetion seven:
; 0000 0031     question_01();
	RCALL _question_01
; 0000 0032     question_02();
	RCALL _question_02
; 0000 0033     question_04();
	RCALL _question_04
; 0000 0034     while(1){
_0x4:
; 0000 0035         question_03();
	RCALL _question_03
; 0000 0036         question_05();
	RCALL _question_05
; 0000 0037         question_06();
	RCALL _question_06
; 0000 0038     }
	RJMP _0x4
; 0000 0039 
; 0000 003A }
_0x7:
	RJMP _0x7
; .FEND
;
;
;void question_01(){
; 0000 003D void question_01(){
_question_01:
; .FSTART _question_01
; 0000 003E     DDRB = 0xFF;
	LDI  R30,LOW(255)
	OUT  0x17,R30
; 0000 003F     count = 0;
	CLR  R4
	CLR  R5
; 0000 0040     while(count <4){
_0x8:
	LDI  R30,LOW(4)
	LDI  R31,HIGH(4)
	CP   R4,R30
	CPC  R5,R31
	BRGE _0xA
; 0000 0041     PORTB = 0xFF;
	LDI  R30,LOW(255)
	OUT  0x18,R30
; 0000 0042     delay_ms(500); //calling 500ms delay == 0.5 second
	RCALL SUBOPT_0x0
; 0000 0043     PORTB = 0x00;
	LDI  R30,LOW(0)
	OUT  0x18,R30
; 0000 0044     delay_ms(500); //calling 500ms delay == 0.5 second
	RCALL SUBOPT_0x0
; 0000 0045     count++;
	MOVW R30,R4
	ADIW R30,1
	MOVW R4,R30
; 0000 0046     }
	RJMP _0x8
_0xA:
; 0000 0047 
; 0000 0048 }
	RET
; .FEND
;
;void question_02(){
; 0000 004A void question_02(){
_question_02:
; .FSTART _question_02
; 0000 004B     DDRB = 0xFF;
	LDI  R30,LOW(255)
	OUT  0x17,R30
; 0000 004C     count = 0;
	CLR  R4
	CLR  R5
; 0000 004D     while(count <2){    //Changing the point of light each 0.5 second, Then after 8 seconds it will stop
_0xB:
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	CP   R4,R30
	CPC  R5,R31
	BRGE _0xD
; 0000 004E     PORTB.7 = 0;
	CBI  0x18,7
; 0000 004F     PORTB.0 = 1;
	SBI  0x18,0
; 0000 0050     delay_ms(500);
	RCALL SUBOPT_0x0
; 0000 0051     PORTB.0 = 0;
	CBI  0x18,0
; 0000 0052     PORTB.1 = 1;
	SBI  0x18,1
; 0000 0053     delay_ms(500);
	RCALL SUBOPT_0x0
; 0000 0054     PORTB.1 = 0;
	CBI  0x18,1
; 0000 0055     PORTB.2 = 1;
	SBI  0x18,2
; 0000 0056     delay_ms(500);
	RCALL SUBOPT_0x0
; 0000 0057     PORTB.2 = 0;
	CBI  0x18,2
; 0000 0058     PORTB.3 = 1;
	SBI  0x18,3
; 0000 0059     delay_ms(500);
	RCALL SUBOPT_0x0
; 0000 005A     PORTB.3 = 0;
	CBI  0x18,3
; 0000 005B     PORTB.4 = 1;
	SBI  0x18,4
; 0000 005C     delay_ms(500);
	RCALL SUBOPT_0x0
; 0000 005D     PORTB.4 = 0;
	CBI  0x18,4
; 0000 005E     PORTB.5 = 1;
	SBI  0x18,5
; 0000 005F     delay_ms(500);
	RCALL SUBOPT_0x0
; 0000 0060     PORTB.5 = 0;
	CBI  0x18,5
; 0000 0061     PORTB.6 = 1;
	SBI  0x18,6
; 0000 0062     delay_ms(500);
	RCALL SUBOPT_0x0
; 0000 0063     PORTB.6 = 0;
	CBI  0x18,6
; 0000 0064     PORTB.7 = 1;
	SBI  0x18,7
; 0000 0065     delay_ms(500);
	RCALL SUBOPT_0x0
; 0000 0066     count++;
	MOVW R30,R4
	ADIW R30,1
	MOVW R4,R30
; 0000 0067     }
	RJMP _0xB
_0xD:
; 0000 0068 
; 0000 0069     PORTB.7 = 0;
	CBI  0x18,7
; 0000 006A 
; 0000 006B }
	RET
; .FEND
;
;
;void question_03(){
; 0000 006E void question_03(){
_question_03:
; .FSTART _question_03
; 0000 006F 
; 0000 0070     count = 0;
	CLR  R4
	CLR  R5
; 0000 0071     while(1){
_0x30:
; 0000 0072      DDRA = 0x00;
	LDI  R30,LOW(0)
	OUT  0x1A,R30
; 0000 0073      DDRB = 0xFF;
	LDI  R30,LOW(255)
	OUT  0x17,R30
; 0000 0074 
; 0000 0075     PORTB.0 = PINA.0;
	SBIC 0x19,0
	RJMP _0x33
	CBI  0x18,0
	RJMP _0x34
_0x33:
	SBI  0x18,0
_0x34:
; 0000 0076     PORTB.1 = PINA.1;
	SBIC 0x19,1
	RJMP _0x35
	CBI  0x18,1
	RJMP _0x36
_0x35:
	SBI  0x18,1
_0x36:
; 0000 0077     PORTB.2 = PINA.2;
	SBIC 0x19,2
	RJMP _0x37
	CBI  0x18,2
	RJMP _0x38
_0x37:
	SBI  0x18,2
_0x38:
; 0000 0078     PORTB.3 = PINA.3;
	SBIC 0x19,3
	RJMP _0x39
	CBI  0x18,3
	RJMP _0x3A
_0x39:
	SBI  0x18,3
_0x3A:
; 0000 0079     PORTB.4 = PINA.4;
	SBIC 0x19,4
	RJMP _0x3B
	CBI  0x18,4
	RJMP _0x3C
_0x3B:
	SBI  0x18,4
_0x3C:
; 0000 007A     PORTB.5 = PINA.5;
	SBIC 0x19,5
	RJMP _0x3D
	CBI  0x18,5
	RJMP _0x3E
_0x3D:
	SBI  0x18,5
_0x3E:
; 0000 007B     PORTB.6 = PINA.6;
	SBIC 0x19,6
	RJMP _0x3F
	CBI  0x18,6
	RJMP _0x40
_0x3F:
	SBI  0x18,6
_0x40:
; 0000 007C     PORTB.7 = PINA.7;
	SBIC 0x19,7
	RJMP _0x41
	CBI  0x18,7
	RJMP _0x42
_0x41:
	SBI  0x18,7
_0x42:
; 0000 007D 
; 0000 007E     count ++;
	MOVW R30,R4
	ADIW R30,1
	MOVW R4,R30
; 0000 007F 
; 0000 0080     if (count == 50) break;
	LDI  R30,LOW(50)
	LDI  R31,HIGH(50)
	CP   R30,R4
	CPC  R31,R5
	BRNE _0x30
; 0000 0081     }
; 0000 0082 
; 0000 0083 }
	RET
; .FEND
;
;void question_04(){
; 0000 0085 void question_04(){
_question_04:
; .FSTART _question_04
; 0000 0086     DDRD = 0x0F;
	RCALL SUBOPT_0x1
; 0000 0087     DDRC = 0xFF;
; 0000 0088 
; 0000 0089 
; 0000 008A     PORTD = 0x00;
	LDI  R30,LOW(0)
	OUT  0x12,R30
; 0000 008B 
; 0000 008C 
; 0000 008D     for (count = 9; count >= 0; count--){
	LDI  R30,LOW(9)
	LDI  R31,HIGH(9)
	MOVW R4,R30
_0x45:
	CLR  R0
	CP   R4,R0
	CPC  R5,R0
	BRLT _0x46
; 0000 008E      PORTC = sevenSeg[count];
	MOVW R30,R4
	RCALL SUBOPT_0x2
; 0000 008F      delay_ms(1000);
	LDI  R26,LOW(1000)
	LDI  R27,HIGH(1000)
	CALL _delay_ms
; 0000 0090     }
	MOVW R30,R4
	SBIW R30,1
	MOVW R4,R30
	RJMP _0x45
_0x46:
; 0000 0091 
; 0000 0092 
; 0000 0093 }
	RET
; .FEND
;
;void question_05() {
; 0000 0095 void question_05() {
_question_05:
; .FSTART _question_05
; 0000 0096      DDRA = 0x00;
	RCALL SUBOPT_0x3
; 0000 0097      temp = 0;
; 0000 0098      DDRD = 0x0F;
; 0000 0099      DDRC = 0xFF;
; 0000 009A      count = 0;
	RCALL SUBOPT_0x4
; 0000 009B 
; 0000 009C 
; 0000 009D      fourthSevenSeg = 0;
; 0000 009E      thirdSevenSeg = PINA%10;
; 0000 009F      temp = PINA/10;
; 0000 00A0      secondSevenSeg = temp%10;
; 0000 00A1      temp = temp/10;
; 0000 00A2      firstSevenSeg = temp%10;
; 0000 00A3 
; 0000 00A4      while(1) {
_0x47:
; 0000 00A5 
; 0000 00A6          PORTC = sevenSeg[fourthSevenSeg];
	RCALL SUBOPT_0x5
	RCALL SUBOPT_0x2
; 0000 00A7          delay_ms(4);
	RCALL SUBOPT_0x6
; 0000 00A8          PORTD = 0x08;
	RCALL SUBOPT_0x7
; 0000 00A9          PORTC = sevenSeg[thirdSevenSeg]+0x80 ;
; 0000 00AA          delay_ms(4);
; 0000 00AB          PORTD = 0x04;
	LDI  R30,LOW(4)
	OUT  0x12,R30
; 0000 00AC          PORTC = sevenSeg[secondSevenSeg];
	MOVW R30,R10
	RCALL SUBOPT_0x2
; 0000 00AD          delay_ms(4);
	RCALL SUBOPT_0x6
; 0000 00AE          PORTD = 0x02;
	LDI  R30,LOW(2)
	OUT  0x12,R30
; 0000 00AF          PORTC = sevenSeg[firstSevenSeg];
	MOVW R30,R8
	RCALL SUBOPT_0x2
; 0000 00B0          delay_ms(4);
	RCALL SUBOPT_0x6
; 0000 00B1          PORTD = 0x01;
	RCALL SUBOPT_0x8
; 0000 00B2 
; 0000 00B3          count += 1;
; 0000 00B4          if (count == 10) {
	BRNE _0x4A
; 0000 00B5             if (fourthSevenSeg == 0){
	RCALL SUBOPT_0x5
	SBIW R30,0
	BRNE _0x4B
; 0000 00B6                  fourthSevenSeg = 10;
	RCALL SUBOPT_0x9
; 0000 00B7                  if (thirdSevenSeg == 0){
	BRNE _0x4C
; 0000 00B8                     thirdSevenSeg = 9;
	LDI  R30,LOW(9)
	LDI  R31,HIGH(9)
	MOVW R12,R30
; 0000 00B9                     if (secondSevenSeg == 0){
	MOV  R0,R10
	OR   R0,R11
	BRNE _0x4D
; 0000 00BA                         secondSevenSeg = 9;
	MOVW R10,R30
; 0000 00BB                         if (firstSevenSeg != 0) firstSevenSeg --;
	MOV  R0,R8
	OR   R0,R9
	BREQ _0x4E
	MOVW R30,R8
	SBIW R30,1
	MOVW R8,R30
	ADIW R30,1
; 0000 00BC                     }
_0x4E:
; 0000 00BD                     else secondSevenSeg --;
	RJMP _0x4F
_0x4D:
	MOVW R30,R10
	SBIW R30,1
	MOVW R10,R30
	ADIW R30,1
; 0000 00BE                  }
_0x4F:
; 0000 00BF                  else thirdSevenSeg --;
	RJMP _0x50
_0x4C:
	MOVW R30,R12
	SBIW R30,1
	MOVW R12,R30
	ADIW R30,1
; 0000 00C0             }
_0x50:
; 0000 00C1             fourthSevenSeg -= 2;
_0x4B:
	RCALL SUBOPT_0xA
; 0000 00C2             count = 0;
; 0000 00C3          }
; 0000 00C4 
; 0000 00C5          if (fourthSevenSeg == 0 && thirdSevenSeg == 0 && secondSevenSeg == 0&& firstSevenSeg == 0) break;
_0x4A:
	LDS  R26,_fourthSevenSeg
	LDS  R27,_fourthSevenSeg+1
	SBIW R26,0
	BRNE _0x52
	CLR  R0
	CP   R0,R12
	CPC  R0,R13
	BRNE _0x52
	CLR  R0
	CP   R0,R10
	CPC  R0,R11
	BRNE _0x52
	CLR  R0
	CP   R0,R8
	CPC  R0,R9
	BREQ _0x53
_0x52:
	RJMP _0x51
_0x53:
	RJMP _0x49
; 0000 00C6      }
_0x51:
	RJMP _0x47
_0x49:
; 0000 00C7 }
	RET
; .FEND
;
;
;void question_06() {
; 0000 00CA void question_06() {
_question_06:
; .FSTART _question_06
; 0000 00CB      DDRA = 0x00;
	RCALL SUBOPT_0x3
; 0000 00CC      temp = 0;
; 0000 00CD      DDRD = 0x0F;
; 0000 00CE      DDRC = 0xFF;
; 0000 00CF      count = 0;
	RCALL SUBOPT_0x4
; 0000 00D0 
; 0000 00D1      fourthSevenSeg = 0;
; 0000 00D2      thirdSevenSeg = PINA%10;
; 0000 00D3      temp = PINA/10;
; 0000 00D4      secondSevenSeg = temp%10;
; 0000 00D5      temp = temp/10;
; 0000 00D6      firstSevenSeg = temp%10;
; 0000 00D7 
; 0000 00D8      while(1) {
_0x54:
; 0000 00D9 
; 0000 00DA          if (PIND.4 == 0) {
	SBIC 0x10,4
	RJMP _0x57
; 0000 00DB              firstSevenSeg = 0;
	CLR  R8
	CLR  R9
; 0000 00DC          }
; 0000 00DD          if (PIND.5 == 0) {
_0x57:
	SBIC 0x10,5
	RJMP _0x58
; 0000 00DE              secondSevenSeg = 0;
	CLR  R10
	CLR  R11
; 0000 00DF          }
; 0000 00E0          if (PIND.6 == 0) {
_0x58:
	SBIC 0x10,6
	RJMP _0x59
; 0000 00E1              thirdSevenSeg = 0;
	CLR  R12
	CLR  R13
; 0000 00E2          }
; 0000 00E3          if (PIND.7 == 0) {
_0x59:
	SBIC 0x10,7
	RJMP _0x5A
; 0000 00E4              fourthSevenSeg = 0;
	LDI  R30,LOW(0)
	STS  _fourthSevenSeg,R30
	STS  _fourthSevenSeg+1,R30
; 0000 00E5          }
; 0000 00E6 
; 0000 00E7 
; 0000 00E8          PORTC = sevenSeg[fourthSevenSeg];
_0x5A:
	RCALL SUBOPT_0x5
	RCALL SUBOPT_0x2
; 0000 00E9          delay_ms(4);
	RCALL SUBOPT_0x6
; 0000 00EA          PORTD = 0x08;
	RCALL SUBOPT_0x7
; 0000 00EB          PORTC = sevenSeg[thirdSevenSeg]+0x80 ;
; 0000 00EC          delay_ms(4);
; 0000 00ED          PORTD = 0x04;
	LDI  R30,LOW(4)
	OUT  0x12,R30
; 0000 00EE          PORTC = sevenSeg[secondSevenSeg];
	MOVW R30,R10
	RCALL SUBOPT_0x2
; 0000 00EF          delay_ms(4);
	RCALL SUBOPT_0x6
; 0000 00F0          PORTD = 0x02;
	LDI  R30,LOW(2)
	OUT  0x12,R30
; 0000 00F1          PORTC = sevenSeg[firstSevenSeg];
	MOVW R30,R8
	RCALL SUBOPT_0x2
; 0000 00F2          delay_ms(4);
	RCALL SUBOPT_0x6
; 0000 00F3          PORTD = 0x01;
	RCALL SUBOPT_0x8
; 0000 00F4 
; 0000 00F5          count += 1;
; 0000 00F6          if (count == 10) {
	BRNE _0x5B
; 0000 00F7             if (fourthSevenSeg == 0){
	RCALL SUBOPT_0x5
	SBIW R30,0
	BRNE _0x5C
; 0000 00F8                  fourthSevenSeg = 10;
	RCALL SUBOPT_0x9
; 0000 00F9                  if (thirdSevenSeg == 0){
	BRNE _0x5D
; 0000 00FA                     thirdSevenSeg = 9;
	LDI  R30,LOW(9)
	LDI  R31,HIGH(9)
	MOVW R12,R30
; 0000 00FB                     if (secondSevenSeg == 0){
	MOV  R0,R10
	OR   R0,R11
	BRNE _0x5E
; 0000 00FC                         secondSevenSeg = 9;
	MOVW R10,R30
; 0000 00FD                         if (firstSevenSeg != 0) firstSevenSeg --;
	MOV  R0,R8
	OR   R0,R9
	BREQ _0x5F
	MOVW R30,R8
	SBIW R30,1
	MOVW R8,R30
	ADIW R30,1
; 0000 00FE                     }
_0x5F:
; 0000 00FF                     else secondSevenSeg --;
	RJMP _0x60
_0x5E:
	MOVW R30,R10
	SBIW R30,1
	MOVW R10,R30
	ADIW R30,1
; 0000 0100                  }
_0x60:
; 0000 0101                  else thirdSevenSeg --;
	RJMP _0x61
_0x5D:
	MOVW R30,R12
	SBIW R30,1
	MOVW R12,R30
	ADIW R30,1
; 0000 0102             }
_0x61:
; 0000 0103             fourthSevenSeg -= 2;
_0x5C:
	RCALL SUBOPT_0xA
; 0000 0104             count = 0;
; 0000 0105          }
; 0000 0106 
; 0000 0107          if (fourthSevenSeg == 0 && thirdSevenSeg == 0 && secondSevenSeg == 0&& firstSevenSeg == 0) break;
_0x5B:
	LDS  R26,_fourthSevenSeg
	LDS  R27,_fourthSevenSeg+1
	SBIW R26,0
	BRNE _0x63
	CLR  R0
	CP   R0,R12
	CPC  R0,R13
	BRNE _0x63
	CLR  R0
	CP   R0,R10
	CPC  R0,R11
	BRNE _0x63
	CLR  R0
	CP   R0,R8
	CPC  R0,R9
	BREQ _0x64
_0x63:
	RJMP _0x62
_0x64:
	RJMP _0x56
; 0000 0108      }
_0x62:
	RJMP _0x54
_0x56:
; 0000 0109 }
	RET
; .FEND

	.DSEG
_fourthSevenSeg:
	.BYTE 0x2
_sevenSeg:
	.BYTE 0x14

	.CSEG
;OPTIMIZER ADDED SUBROUTINE, CALLED 10 TIMES, CODE SIZE REDUCTION:15 WORDS
SUBOPT_0x0:
	LDI  R26,LOW(500)
	LDI  R27,HIGH(500)
	JMP  _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x1:
	LDI  R30,LOW(15)
	OUT  0x11,R30
	LDI  R30,LOW(255)
	OUT  0x14,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:33 WORDS
SUBOPT_0x2:
	LDI  R26,LOW(_sevenSeg)
	LDI  R27,HIGH(_sevenSeg)
	LSL  R30
	ROL  R31
	ADD  R26,R30
	ADC  R27,R31
	LD   R30,X
	OUT  0x15,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x3:
	LDI  R30,LOW(0)
	OUT  0x1A,R30
	CLR  R6
	CLR  R7
	RJMP SUBOPT_0x1

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:36 WORDS
SUBOPT_0x4:
	CLR  R4
	CLR  R5
	LDI  R30,LOW(0)
	STS  _fourthSevenSeg,R30
	STS  _fourthSevenSeg+1,R30
	IN   R30,0x19
	LDI  R31,0
	MOVW R26,R30
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CALL __MODW21
	MOVW R12,R30
	IN   R30,0x19
	LDI  R31,0
	MOVW R26,R30
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CALL __DIVW21
	MOVW R6,R30
	MOVW R26,R6
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CALL __MODW21
	MOVW R10,R30
	MOVW R26,R6
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CALL __DIVW21
	MOVW R6,R30
	MOVW R26,R6
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CALL __MODW21
	MOVW R8,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x5:
	LDS  R30,_fourthSevenSeg
	LDS  R31,_fourthSevenSeg+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:11 WORDS
SUBOPT_0x6:
	LDI  R26,LOW(4)
	LDI  R27,0
	JMP  _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x7:
	LDI  R30,LOW(8)
	OUT  0x12,R30
	MOVW R30,R12
	LDI  R26,LOW(_sevenSeg)
	LDI  R27,HIGH(_sevenSeg)
	LSL  R30
	ROL  R31
	ADD  R26,R30
	ADC  R27,R31
	LD   R30,X
	SUBI R30,-LOW(128)
	OUT  0x15,R30
	RJMP SUBOPT_0x6

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x8:
	LDI  R30,LOW(1)
	OUT  0x12,R30
	MOVW R30,R4
	ADIW R30,1
	MOVW R4,R30
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CP   R30,R4
	CPC  R31,R5
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x9:
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	STS  _fourthSevenSeg,R30
	STS  _fourthSevenSeg+1,R31
	MOV  R0,R12
	OR   R0,R13
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0xA:
	RCALL SUBOPT_0x5
	SBIW R30,2
	STS  _fourthSevenSeg,R30
	STS  _fourthSevenSeg+1,R31
	CLR  R4
	CLR  R5
	RET


	.CSEG
_delay_ms:
	adiw r26,0
	breq __delay_ms1
__delay_ms0:
	__DELAY_USW 0x7D0
	wdr
	sbiw r26,1
	brne __delay_ms0
__delay_ms1:
	ret

__ANEGW1:
	NEG  R31
	NEG  R30
	SBCI R31,0
	RET

__DIVW21U:
	CLR  R0
	CLR  R1
	LDI  R25,16
__DIVW21U1:
	LSL  R26
	ROL  R27
	ROL  R0
	ROL  R1
	SUB  R0,R30
	SBC  R1,R31
	BRCC __DIVW21U2
	ADD  R0,R30
	ADC  R1,R31
	RJMP __DIVW21U3
__DIVW21U2:
	SBR  R26,1
__DIVW21U3:
	DEC  R25
	BRNE __DIVW21U1
	MOVW R30,R26
	MOVW R26,R0
	RET

__DIVW21:
	RCALL __CHKSIGNW
	RCALL __DIVW21U
	BRTC __DIVW211
	RCALL __ANEGW1
__DIVW211:
	RET

__MODW21:
	CLT
	SBRS R27,7
	RJMP __MODW211
	COM  R26
	COM  R27
	ADIW R26,1
	SET
__MODW211:
	SBRC R31,7
	RCALL __ANEGW1
	RCALL __DIVW21U
	MOVW R30,R26
	BRTC __MODW212
	RCALL __ANEGW1
__MODW212:
	RET

__CHKSIGNW:
	CLT
	SBRS R31,7
	RJMP __CHKSW1
	RCALL __ANEGW1
	SET
__CHKSW1:
	SBRS R27,7
	RJMP __CHKSW2
	COM  R26
	COM  R27
	ADIW R26,1
	BLD  R0,0
	INC  R0
	BST  R0,0
__CHKSW2:
	RET

;END OF CODE MARKER
__END_OF_CODE:
