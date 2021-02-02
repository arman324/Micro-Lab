
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

_0x3:
	.DB  0x3F,0x0,0x6,0x0,0x5B,0x0,0x4F,0x0
	.DB  0x66,0x0,0x6D,0x0,0x7D,0x0,0x7,0x0
	.DB  0x7F,0x0,0x6F

__GLOBAL_INI_TBL:
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
; * Lab02.c
; *
; * Created: 10/4/2020 3:23:32 PM
; * Author: Arman Riasi
; */
;
;
;#include <define.h>
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
;int count;
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
; 0000 001A {

	.CSEG
_main:
; .FSTART _main
; 0000 001B     //question_01(12,portB,250);
; 0000 001C     //question_02(400, position2);
; 0000 001D     //question_03(portB,pinA);
; 0000 001E     //question_04(decrease, thirdSevenSegOn);
; 0000 001F     question_05(5); //choose only number 1 or number 2 or number 5, another input numbers will alter to 5
	LDI  R26,LOW(5)
	LDI  R27,0
	RCALL _question_05
; 0000 0020 }
_0x4:
	RJMP _0x4
; .FEND
;
;
;
;#include <define.h>
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
;
;
;void question_01(int number,char portSelect, int delayTime){
; 0001 0006 void question_01(int number,char portSelect, int delayTime){

	.CSEG
; 0001 0007     count = 0;
;	number -> Y+3
;	portSelect -> Y+2
;	delayTime -> Y+0
; 0001 0008 
; 0001 0009     while(count < number){
; 0001 000A         switch(portSelect){
; 0001 000B          case portA:
; 0001 000C             DDRA = 0xFF;
; 0001 000D             PORTA = 0xFF;
; 0001 000E             delay_ms(delayTime);
; 0001 000F             PORTA = 0x00;
; 0001 0010             delay_ms(delayTime);
; 0001 0011             break;
; 0001 0012 
; 0001 0013          case portB:
; 0001 0014             DDRB = 0xFF;
; 0001 0015             PORTB = 0xFF;
; 0001 0016             delay_ms(delayTime);
; 0001 0017             PORTB = 0x00;
; 0001 0018             delay_ms(delayTime);
; 0001 0019             break;
; 0001 001A 
; 0001 001B          case portC:
; 0001 001C             DDRC = 0xFF;
; 0001 001D             PORTC = 0xFF;
; 0001 001E             delay_ms(delayTime);
; 0001 001F             PORTC = 0x00;
; 0001 0020             delay_ms(delayTime);
; 0001 0021             break;
; 0001 0022 
; 0001 0023          case portD:
; 0001 0024             DDRD = 0xFF;
; 0001 0025             PORTD = 0xFF;
; 0001 0026             delay_ms(delayTime);
; 0001 0027             PORTD = 0x00;
; 0001 0028             delay_ms(delayTime);
; 0001 0029             break;
; 0001 002A 
; 0001 002B          default:
; 0001 002C             DDRD = 0xFF;
; 0001 002D             PORTD = 0xFF;
; 0001 002E             delay_ms(delayTime);
; 0001 002F             PORTD = 0x00;
; 0001 0030             delay_ms(delayTime);
; 0001 0031             break;
; 0001 0032      }
; 0001 0033          count++;
; 0001 0034     }
; 0001 0035 
; 0001 0036 }
;
;void question_02(int delayTime, int position){
; 0001 0038 void question_02(int delayTime, int position){
; 0001 0039     char currentPosition;
; 0001 003A     DDRB = 0xFF;
;	delayTime -> Y+3
;	position -> Y+1
;	currentPosition -> R17
; 0001 003B     count = 0;
; 0001 003C     currentPosition = position;
; 0001 003D     while(1){
; 0001 003E 
; 0001 003F             if (currentPosition == 0) {
; 0001 0040                 PORTB = 0b00000001;
; 0001 0041                 delay_ms(delayTime);
; 0001 0042                 currentPosition ++;
; 0001 0043                 count++;
; 0001 0044                 if (count == 16) break;
; 0001 0045             }
; 0001 0046 
; 0001 0047             if (currentPosition == 1) {
; 0001 0048                 PORTB = 0b00000010;
; 0001 0049                 delay_ms(delayTime);
; 0001 004A                 currentPosition ++;
; 0001 004B                 count++;
; 0001 004C                 if (count == 16) break;
; 0001 004D             }
; 0001 004E 
; 0001 004F             if (currentPosition == 2) {
; 0001 0050                 PORTB = 0b00000100;
; 0001 0051                 delay_ms(delayTime);
; 0001 0052                 currentPosition ++;
; 0001 0053                 count++;
; 0001 0054                 if (count == 16) break;
; 0001 0055             }
; 0001 0056 
; 0001 0057             if (currentPosition == 3) {
; 0001 0058                 PORTB = 0b00001000;
; 0001 0059                 delay_ms(delayTime);
; 0001 005A                 currentPosition ++;
; 0001 005B                 count++;
; 0001 005C                 if (count == 16) break;
; 0001 005D             }
; 0001 005E 
; 0001 005F             if (currentPosition == 4) {
; 0001 0060                 PORTB = 0b00010000;
; 0001 0061                 delay_ms(delayTime);
; 0001 0062                 currentPosition ++;
; 0001 0063                 count++;
; 0001 0064                 if (count == 16) break;
; 0001 0065             }
; 0001 0066 
; 0001 0067             if (currentPosition == 5) {
; 0001 0068                 PORTB = 0b00100000;
; 0001 0069                 delay_ms(delayTime);
; 0001 006A                 currentPosition ++;
; 0001 006B                 count++;
; 0001 006C                 if (count == 16) break;
; 0001 006D 
; 0001 006E             }
; 0001 006F 
; 0001 0070             if (currentPosition == 6) {
; 0001 0071                 PORTB = 0b01000000;
; 0001 0072                 delay_ms(delayTime);
; 0001 0073                 currentPosition ++;
; 0001 0074                 count++;
; 0001 0075                 if (count == 16) break;
; 0001 0076             }
; 0001 0077 
; 0001 0078             if (currentPosition == 7) {
; 0001 0079                 PORTB = 0b10000000;
; 0001 007A                 delay_ms(delayTime);
; 0001 007B                 currentPosition = 0;
; 0001 007C                 count++;
; 0001 007D                 if (count == 16) break;
; 0001 007E             }
; 0001 007F 
; 0001 0080 
; 0001 0081 
; 0001 0082     }
; 0001 0083 
; 0001 0084     PORTB = 0x00;
; 0001 0085 }
;
;
;void question_03(char outputPortSelect, char inputPortSelect){
; 0001 0088 void question_03(char outputPortSelect, char inputPortSelect){
; 0001 0089     unsigned int temp;
; 0001 008A     count = 0;
;	outputPortSelect -> Y+3
;	inputPortSelect -> Y+2
;	temp -> R16,R17
; 0001 008B     temp = 0;
; 0001 008C 
; 0001 008D     while(1){
; 0001 008E         switch(inputPortSelect){
; 0001 008F          case pinA:
; 0001 0090             DDRA = 0x00;
; 0001 0091             temp = PINA;
; 0001 0092             break;
; 0001 0093 
; 0001 0094          case pinB:
; 0001 0095             DDRB = 0x00;
; 0001 0096             temp = PINB;
; 0001 0097             break;
; 0001 0098 
; 0001 0099          case pinC:
; 0001 009A             DDRC = 0x00;
; 0001 009B             temp = PINC;
; 0001 009C             break;
; 0001 009D 
; 0001 009E          case pinD:
; 0001 009F             DDRD = 0x00;
; 0001 00A0             temp = PIND;
; 0001 00A1             break;
; 0001 00A2 
; 0001 00A3          default:
; 0001 00A4             DDRA = 0x00;
; 0001 00A5             temp = PINA;
; 0001 00A6             break;
; 0001 00A7      }
; 0001 00A8 
; 0001 00A9 
; 0001 00AA         switch(outputPortSelect){
; 0001 00AB          case portA:
; 0001 00AC             DDRA = 0xFF;
; 0001 00AD             PORTA = temp;
; 0001 00AE             break;
; 0001 00AF 
; 0001 00B0          case portB:
; 0001 00B1             DDRB = 0xFF;
; 0001 00B2             PORTB = temp;
; 0001 00B3             break;
; 0001 00B4 
; 0001 00B5          case portC:
; 0001 00B6             DDRC = 0xFF;
; 0001 00B7             PORTC = temp;
; 0001 00B8             break;
; 0001 00B9 
; 0001 00BA          case portD:
; 0001 00BB             DDRD = 0xFF;
; 0001 00BC             PORTD = temp;
; 0001 00BD             break;
; 0001 00BE 
; 0001 00BF          default:
; 0001 00C0             DDRB = 0xFF;
; 0001 00C1             PORTB = temp;
; 0001 00C2             break;
; 0001 00C3      }
; 0001 00C4 
; 0001 00C5    // count ++;
; 0001 00C6   //  if (count == 50) break;
; 0001 00C7 
; 0001 00C8     }
; 0001 00C9 }
;
;void question_04(int direction, int sevenSegOn){
; 0001 00CB void question_04(int direction, int sevenSegOn){
; 0001 00CC     DDRD = 0x0F;
;	direction -> Y+2
;	sevenSegOn -> Y+0
; 0001 00CD     DDRC = 0xFF;
; 0001 00CE 
; 0001 00CF     switch(sevenSegOn){
; 0001 00D0         case allSevenSegOn:
; 0001 00D1             PORTD = 0x00;
; 0001 00D2             break;
; 0001 00D3         case firstSevenSegOn:
; 0001 00D4             PORTD = 0b00001110;
; 0001 00D5             break;
; 0001 00D6         case secondSevenSegOn:
; 0001 00D7             PORTD = 0b00001101;
; 0001 00D8             break;
; 0001 00D9         case thirdSevenSegOn:
; 0001 00DA             PORTD = 0b00001011;
; 0001 00DB             break;
; 0001 00DC         case fourthSevenSegOn:
; 0001 00DD             PORTD = 0b00000111;
; 0001 00DE             break;
; 0001 00DF         default:
; 0001 00E0             PORTD = 0x00;
; 0001 00E1             break;
; 0001 00E2     }
; 0001 00E3 
; 0001 00E4 
; 0001 00E5     if (direction == decrease){
; 0001 00E6         for (count = 9; count >= 0; count--){
; 0001 00E7          PORTC = sevenSeg[count];
; 0001 00E8          delay_ms(500);
; 0001 00E9         }
; 0001 00EA     }
; 0001 00EB     if (direction == increase){
; 0001 00EC         for (count = 0; count <= 9; count++){
; 0001 00ED          PORTC = sevenSeg[count];
; 0001 00EE          delay_ms(500);
; 0001 00EF         }
; 0001 00F0     }
; 0001 00F1 
; 0001 00F2 }
;
;
;
;void question_05(int amountOfReduction) {
; 0001 00F6 void question_05(int amountOfReduction) {
_question_05:
; .FSTART _question_05
; 0001 00F7      int temp;
; 0001 00F8      unsigned int firstSevenSeg;
; 0001 00F9      unsigned int secondSevenSeg;
; 0001 00FA      unsigned int thirdSevenSeg;
; 0001 00FB      unsigned int fourthSevenSeg;
; 0001 00FC 
; 0001 00FD      if (amountOfReduction != 1 && amountOfReduction != 2 && amountOfReduction != 5){ //error handling
	ST   -Y,R27
	ST   -Y,R26
	SBIW R28,4
	CALL __SAVELOCR6
;	amountOfReduction -> Y+10
;	temp -> R16,R17
;	firstSevenSeg -> R18,R19
;	secondSevenSeg -> R20,R21
;	thirdSevenSeg -> Y+8
;	fourthSevenSeg -> Y+6
	LDD  R26,Y+10
	LDD  R27,Y+10+1
	SBIW R26,1
	BREQ _0x20046
	LDD  R26,Y+10
	LDD  R27,Y+10+1
	SBIW R26,2
	BREQ _0x20046
	LDD  R26,Y+10
	LDD  R27,Y+10+1
	SBIW R26,5
	BRNE _0x20047
_0x20046:
	RJMP _0x20045
_0x20047:
; 0001 00FE         amountOfReduction = 5;
	LDI  R30,LOW(5)
	LDI  R31,HIGH(5)
	STD  Y+10,R30
	STD  Y+10+1,R31
; 0001 00FF      }
; 0001 0100 
; 0001 0101      DDRA = 0x00;
_0x20045:
	LDI  R30,LOW(0)
	OUT  0x1A,R30
; 0001 0102      DDRD = 0x0F;
	LDI  R30,LOW(15)
	OUT  0x11,R30
; 0001 0103      DDRC = 0xFF;
	LDI  R30,LOW(255)
	OUT  0x14,R30
; 0001 0104      count = 0;
	LDI  R30,LOW(0)
	STS  _count,R30
	STS  _count+1,R30
; 0001 0105      temp = 0;
	__GETWRN 16,17,0
; 0001 0106 
; 0001 0107      fourthSevenSeg = 0;
	STD  Y+6,R30
	STD  Y+6+1,R30
; 0001 0108      thirdSevenSeg = PINA%10;
	IN   R30,0x19
	LDI  R31,0
	MOVW R26,R30
	RCALL SUBOPT_0x0
	STD  Y+8,R30
	STD  Y+8+1,R31
; 0001 0109      temp = PINA/10;
	IN   R30,0x19
	LDI  R31,0
	MOVW R26,R30
	RCALL SUBOPT_0x1
; 0001 010A      secondSevenSeg = temp%10;
	MOVW R20,R30
; 0001 010B      temp = temp/10;
	MOVW R26,R16
	RCALL SUBOPT_0x1
; 0001 010C      firstSevenSeg = temp%10;
	MOVW R18,R30
; 0001 010D 
; 0001 010E      while(1) {
_0x20048:
; 0001 010F 
; 0001 0110          PORTC = sevenSeg[fourthSevenSeg];
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	RCALL SUBOPT_0x2
	RCALL SUBOPT_0x3
; 0001 0111          delay_ms(4);
; 0001 0112          PORTD = 0x08;
	LDI  R30,LOW(8)
	OUT  0x12,R30
; 0001 0113          PORTC = sevenSeg[thirdSevenSeg]+0x80 ;
	LDD  R30,Y+8
	LDD  R31,Y+8+1
	RCALL SUBOPT_0x2
	SUBI R30,-LOW(128)
	RCALL SUBOPT_0x3
; 0001 0114          delay_ms(4);
; 0001 0115          PORTD = 0x04;
	LDI  R30,LOW(4)
	OUT  0x12,R30
; 0001 0116          PORTC = sevenSeg[secondSevenSeg];
	MOVW R30,R20
	RCALL SUBOPT_0x2
	RCALL SUBOPT_0x3
; 0001 0117          delay_ms(4);
; 0001 0118          PORTD = 0x02;
	LDI  R30,LOW(2)
	OUT  0x12,R30
; 0001 0119          PORTC = sevenSeg[firstSevenSeg];
	MOVW R30,R18
	RCALL SUBOPT_0x2
	RCALL SUBOPT_0x3
; 0001 011A          delay_ms(4);
; 0001 011B          PORTD = 0x01;
	LDI  R30,LOW(1)
	OUT  0x12,R30
; 0001 011C 
; 0001 011D          count += 1;
	LDS  R30,_count
	LDS  R31,_count+1
	ADIW R30,1
	STS  _count,R30
	STS  _count+1,R31
; 0001 011E          if (count == 15) {
	LDS  R26,_count
	LDS  R27,_count+1
	SBIW R26,15
	BRNE _0x2004B
; 0001 011F             if (fourthSevenSeg == 0){
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	SBIW R30,0
	BRNE _0x2004C
; 0001 0120                  fourthSevenSeg = 10;
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	STD  Y+6,R30
	STD  Y+6+1,R31
; 0001 0121                  if (thirdSevenSeg == 0){
	LDD  R30,Y+8
	LDD  R31,Y+8+1
	SBIW R30,0
	BRNE _0x2004D
; 0001 0122                     thirdSevenSeg = 9;
	LDI  R30,LOW(9)
	LDI  R31,HIGH(9)
	STD  Y+8,R30
	STD  Y+8+1,R31
; 0001 0123                     if (secondSevenSeg == 0){
	MOV  R0,R20
	OR   R0,R21
	BRNE _0x2004E
; 0001 0124                         secondSevenSeg = 9;
	__GETWRN 20,21,9
; 0001 0125                         if (firstSevenSeg != 0) firstSevenSeg --;
	MOV  R0,R18
	OR   R0,R19
	BREQ _0x2004F
	__SUBWRN 18,19,1
; 0001 0126                     }
_0x2004F:
; 0001 0127                     else secondSevenSeg --;
	RJMP _0x20050
_0x2004E:
	__SUBWRN 20,21,1
; 0001 0128                  }
_0x20050:
; 0001 0129                  else thirdSevenSeg --;
	RJMP _0x20051
_0x2004D:
	LDD  R30,Y+8
	LDD  R31,Y+8+1
	SBIW R30,1
	STD  Y+8,R30
	STD  Y+8+1,R31
; 0001 012A             }
_0x20051:
; 0001 012B 
; 0001 012C             fourthSevenSeg -= amountOfReduction;
_0x2004C:
	LDD  R26,Y+10
	LDD  R27,Y+10+1
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	SUB  R30,R26
	SBC  R31,R27
	STD  Y+6,R30
	STD  Y+6+1,R31
; 0001 012D             count = 0;
	LDI  R30,LOW(0)
	STS  _count,R30
	STS  _count+1,R30
; 0001 012E          }
; 0001 012F 
; 0001 0130          if (fourthSevenSeg == 0 && thirdSevenSeg == 0 && secondSevenSeg == 0&& firstSevenSeg == 0) break;
_0x2004B:
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	SBIW R26,0
	BRNE _0x20053
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	SBIW R26,0
	BRNE _0x20053
	CLR  R0
	CP   R0,R20
	CPC  R0,R21
	BRNE _0x20053
	CLR  R0
	CP   R0,R18
	CPC  R0,R19
	BREQ _0x20054
_0x20053:
	RJMP _0x20052
_0x20054:
	RJMP _0x2004A
; 0001 0131      }
_0x20052:
	RJMP _0x20048
_0x2004A:
; 0001 0132 }
	CALL __LOADLOCR6
	ADIW R28,12
	RET
; .FEND

	.DSEG
_count:
	.BYTE 0x2
_sevenSeg:
	.BYTE 0x14

	.CSEG
;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x0:
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CALL __MODW21
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x1:
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CALL __DIVW21
	MOVW R16,R30
	MOVW R26,R16
	RJMP SUBOPT_0x0

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:12 WORDS
SUBOPT_0x2:
	LDI  R26,LOW(_sevenSeg)
	LDI  R27,HIGH(_sevenSeg)
	LSL  R30
	ROL  R31
	ADD  R26,R30
	ADC  R27,R31
	LD   R30,X
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x3:
	OUT  0x15,R30
	LDI  R26,LOW(4)
	LDI  R27,0
	JMP  _delay_ms


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

__SAVELOCR6:
	ST   -Y,R21
__SAVELOCR5:
	ST   -Y,R20
__SAVELOCR4:
	ST   -Y,R19
__SAVELOCR3:
	ST   -Y,R18
__SAVELOCR2:
	ST   -Y,R17
	ST   -Y,R16
	RET

__LOADLOCR6:
	LDD  R21,Y+5
__LOADLOCR5:
	LDD  R20,Y+4
__LOADLOCR4:
	LDD  R19,Y+3
__LOADLOCR3:
	LDD  R18,Y+2
__LOADLOCR2:
	LDD  R17,Y+1
	LD   R16,Y
	RET

;END OF CODE MARKER
__END_OF_CODE:
