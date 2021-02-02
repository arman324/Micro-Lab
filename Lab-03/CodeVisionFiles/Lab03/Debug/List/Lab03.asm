
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
;Global 'const' stored in FLASH: Yes
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
	.DEF __lcd_x=R5
	.DEF __lcd_y=R4
	.DEF __lcd_maxx=R7

	.CSEG
	.ORG 0x00

;START OF CODE MARKER
__START_OF_CODE:

;INTERRUPT VECTORS
	JMP  __RESET
	JMP  0x00
	JMP  _myInterrupt
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
	.DB  0x30,0x31,0x32,0x33,0x34,0x35,0x36,0x37
	.DB  0x38,0x39,0x41,0x42,0x43,0x44,0x45,0x46
_0x0:
	.DB  0x51,0x75,0x65,0x73,0x74,0x69,0x6F,0x6E
	.DB  0x20,0x34,0x0
_0x20000:
	.DB  0x41,0x72,0x6D,0x61,0x6E,0x20,0x52,0x69
	.DB  0x61,0x73,0x69,0x0,0x39,0x36,0x33,0x38
	.DB  0x32,0x38,0x33,0x0,0x57,0x65,0x6C,0x63
	.DB  0x6F,0x6D,0x65,0x20,0x74,0x6F,0x20,0x74
	.DB  0x68,0x65,0x20,0x6F,0x6E,0x6C,0x69,0x6E
	.DB  0x65,0x20,0x6C,0x61,0x62,0x20,0x63,0x6C
	.DB  0x61,0x73,0x73,0x65,0x73,0x20,0x64,0x75
	.DB  0x65,0x20,0x74,0x6F,0x20,0x43,0x6F,0x72
	.DB  0x6F,0x6E,0x61,0x20,0x64,0x69,0x73,0x65
	.DB  0x61,0x73,0x65,0x2E,0x0,0x20,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x0,0x51,0x75
	.DB  0x65,0x73,0x74,0x69,0x6F,0x6E,0x20,0x33
	.DB  0x3A,0x0,0x45,0x6E,0x74,0x65,0x72,0x20
	.DB  0x6E,0x75,0x6D,0x62,0x65,0x72,0x20,0x66
	.DB  0x6F,0x72,0x53,0x50,0x45,0x45,0x44,0x28
	.DB  0x30,0x2D,0x35,0x30,0x29,0x3A,0x20,0x0
	.DB  0x53,0x50,0x45,0x45,0x44,0x20,0x45,0x45
	.DB  0x20,0x66,0x6F,0x72,0x20,0x0,0x53,0x65
	.DB  0x74,0x20,0x73,0x75,0x63,0x63,0x65,0x73
	.DB  0x73,0x66,0x75,0x6C,0x6C,0x79,0x0,0x45
	.DB  0x6E,0x74,0x65,0x72,0x20,0x6E,0x75,0x6D
	.DB  0x62,0x65,0x72,0x20,0x66,0x6F,0x72,0x54
	.DB  0x49,0x4D,0x45,0x28,0x30,0x2D,0x39,0x39
	.DB  0x73,0x29,0x3A,0x20,0x0,0x54,0x49,0x4D
	.DB  0x45,0x20,0x45,0x45,0x20,0x66,0x6F,0x72
	.DB  0x20,0x0,0x45,0x6E,0x74,0x65,0x72,0x20
	.DB  0x6E,0x75,0x6D,0x62,0x65,0x72,0x20,0x66
	.DB  0x6F,0x72,0x57,0x45,0x49,0x47,0x48,0x54
	.DB  0x28,0x30,0x2D,0x39,0x39,0x46,0x29,0x3A
	.DB  0x20,0x0,0x57,0x45,0x49,0x47,0x48,0x54
	.DB  0x20,0x45,0x45,0x20,0x66,0x6F,0x72,0x20
	.DB  0x0,0x45,0x6E,0x74,0x65,0x72,0x20,0x6E
	.DB  0x75,0x6D,0x62,0x65,0x72,0x20,0x66,0x6F
	.DB  0x72,0x54,0x45,0x4D,0x50,0x28,0x32,0x30
	.DB  0x2D,0x38,0x30,0x43,0x29,0x3A,0x20,0x0
	.DB  0x54,0x45,0x4D,0x50,0x20,0x45,0x45,0x20
	.DB  0x66,0x6F,0x72,0x20,0x0
_0x2000003:
	.DB  0x80,0xC0

__GLOBAL_INI_TBL:
	.DW  0x10
	.DW  _myKeyPad
	.DW  _0x3*2

	.DW  0x0B
	.DW  _0x4
	.DW  _0x0*2

	.DW  0x0C
	.DW  _0x20003
	.DW  _0x20000*2

	.DW  0x39
	.DW  _0x20004
	.DW  _0x20000*2+20

	.DW  0x01
	.DW  _0x20004+57
	.DW  _0x20000*2+11

	.DW  0x11
	.DW  _0x20004+58
	.DW  _0x20000*2+77

	.DW  0x0C
	.DW  _0x20027
	.DW  _0x20000*2+94

	.DW  0x1E
	.DW  _0x2002C
	.DW  _0x20000*2+106

	.DW  0x0E
	.DW  _0x2002C+30
	.DW  _0x20000*2+136

	.DW  0x11
	.DW  _0x2002C+44
	.DW  _0x20000*2+150

	.DW  0x1E
	.DW  _0x2002C+61
	.DW  _0x20000*2+167

	.DW  0x0D
	.DW  _0x2002C+91
	.DW  _0x20000*2+197

	.DW  0x11
	.DW  _0x2002C+104
	.DW  _0x20000*2+150

	.DW  0x20
	.DW  _0x2002C+121
	.DW  _0x20000*2+210

	.DW  0x0F
	.DW  _0x2002C+153
	.DW  _0x20000*2+242

	.DW  0x11
	.DW  _0x2002C+168
	.DW  _0x20000*2+150

	.DW  0x1F
	.DW  _0x2002C+185
	.DW  _0x20000*2+257

	.DW  0x0D
	.DW  _0x2002C+216
	.DW  _0x20000*2+288

	.DW  0x11
	.DW  _0x2002C+229
	.DW  _0x20000*2+150

	.DW  0x02
	.DW  __base_y_G100
	.DW  _0x2000003*2

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
;/*******************************************************
;This program was created by the
;CodeWizardAVR V3.12 Advanced
;Automatic Program Generator
;© Copyright 1998-2014 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com
;
;Project :
;Version :
;Date    : 10/8/2020
;Author  : Arman Riasi
;Company :
;Comments:
;
;
;Chip type               : ATmega16
;Program type            : Application
;AVR Core Clock frequency: 8.000000 MHz
;Memory model            : Small
;External RAM size       : 0
;Data Stack size         : 256
;*******************************************************/
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
;unsigned char tempForKeyPadEntry;
;unsigned char myKeyPad[4][4] = {
;'0','1','2','3',
;'4','5','6','7',
;'8','9','A','B',
;'C','D','E','F'
;};

	.DSEG
;
;// External Interrupt 1 service routine
;interrupt [EXT_INT1] void myInterrupt(void)
; 0000 0024 {

	.CSEG
_myInterrupt:
; .FSTART _myInterrupt
	ST   -Y,R0
	ST   -Y,R1
	ST   -Y,R15
	ST   -Y,R22
	ST   -Y,R23
	ST   -Y,R24
	ST   -Y,R25
	ST   -Y,R26
	ST   -Y,R27
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
; 0000 0025 
; 0000 0026         DDRC = 0x01;
	LDI  R30,LOW(1)
	OUT  0x14,R30
; 0000 0027         PORTC = 0x01;
	OUT  0x15,R30
; 0000 0028         DDRB = 0xF0;
	CALL SUBOPT_0x0
; 0000 0029         PORTB = 0xFF;
; 0000 002A         keyPad();
	RCALL _keyPad
; 0000 002B         DDRB = 0xF0;
	CALL SUBOPT_0x0
; 0000 002C         PORTB = 0xFF;
; 0000 002D         PORTC = 0x00;
	LDI  R30,LOW(0)
	OUT  0x15,R30
; 0000 002E 
; 0000 002F }
	LD   R30,Y+
	OUT  SREG,R30
	LD   R31,Y+
	LD   R30,Y+
	LD   R27,Y+
	LD   R26,Y+
	LD   R25,Y+
	LD   R24,Y+
	LD   R23,Y+
	LD   R22,Y+
	LD   R15,Y+
	LD   R1,Y+
	LD   R0,Y+
	RETI
; .FEND
;
;void main(void){
; 0000 0031 void main(void){
_main:
; .FSTART _main
; 0000 0032     ioInit();
	RCALL _ioInit
; 0000 0033     interruptInit();
	RCALL _interruptInit
; 0000 0034     lcd_init(16);  // Alphanumeric LCD initialization
	LDI  R26,LOW(16)
	CALL _lcd_init
; 0000 0035 
; 0000 0036 
; 0000 0037     //question_01();
; 0000 0038     //question_02();
; 0000 0039     //question_03();
; 0000 003A     //question_04();
; 0000 003B     //question_05();
; 0000 003C 
; 0000 003D 
; 0000 003E     //FOR Question 06:
; 0000 003F     question_01();
	RCALL _question_01
; 0000 0040     question_02();
	RCALL _question_02
; 0000 0041     question_03();
	RCALL _question_03
; 0000 0042     question_05();
	RCALL _question_05
; 0000 0043             lcd_clear();
	CALL SUBOPT_0x1
; 0000 0044             lcd_gotoxy(0,0);
; 0000 0045             lcd_puts("Question 4");
	__POINTW2MN _0x4,0
	CALL SUBOPT_0x2
; 0000 0046             delay_ms(500);
; 0000 0047             lcd_clear();
	CALL _lcd_clear
; 0000 0048     question_04();
	RCALL _question_04
; 0000 0049 
; 0000 004A }
_0x5:
	RJMP _0x5
; .FEND

	.DSEG
_0x4:
	.BYTE 0xB
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
;void question_01(){
; 0001 0003 void question_01(){

	.CSEG
_question_01:
; .FSTART _question_01
; 0001 0004     //lcd_init(16);  // Alphanumeric LCD initialization
; 0001 0005     lcd_clear();
	CALL SUBOPT_0x1
; 0001 0006     lcd_gotoxy(0,0);
; 0001 0007     lcd_puts("Arman Riasi");
	__POINTW2MN _0x20003,0
	CALL _lcd_puts
; 0001 0008     lcd_gotoxy(0,1);
	CALL SUBOPT_0x3
; 0001 0009     lcd_putsf("9638283");
	__POINTW2FN _0x20000,12
	CALL _lcd_putsf
; 0001 000A     delay_ms(2200);
	LDI  R26,LOW(2200)
	LDI  R27,HIGH(2200)
	CALL _delay_ms
; 0001 000B }
	RET
; .FEND

	.DSEG
_0x20003:
	.BYTE 0xC
;
;void question_02(){
; 0001 000D void question_02(){

	.CSEG
_question_02:
; .FSTART _question_02
; 0001 000E     char *myMsg = "Welcome to the online lab classes due to Corona disease.";
; 0001 000F     char *MsgOnTheLCD = "";
; 0001 0010     char *space = "                ";
; 0001 0011     int i = 0;
; 0001 0012     lcd_clear();
	SBIW R28,2
	LDI  R30,LOW(0)
	ST   Y,R30
	STD  Y+1,R30
	CALL __SAVELOCR6
;	*myMsg -> R16,R17
;	*MsgOnTheLCD -> R18,R19
;	*space -> R20,R21
;	i -> Y+6
	__POINTWRMN 16,17,_0x20004,0
	__POINTWRMN 18,19,_0x20004,57
	__POINTWRMN 20,21,_0x20004,58
	RCALL _lcd_clear
; 0001 0013 
; 0001 0014     lcd_gotoxy(0,1);
	CALL SUBOPT_0x3
; 0001 0015     lcd_puts(space);
	MOVW R26,R20
	CALL _lcd_puts
; 0001 0016 
; 0001 0017     lcd_clear();
	RCALL _lcd_clear
; 0001 0018         for (i = 0; i < strlen(myMsg); i++){
	LDI  R30,LOW(0)
	STD  Y+6,R30
	STD  Y+6+1,R30
_0x20006:
	MOVW R26,R16
	CALL _strlen
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	CP   R26,R30
	CPC  R27,R31
	BRSH _0x20007
; 0001 0019             lcd_clear();
	CALL SUBOPT_0x1
; 0001 001A             lcd_gotoxy(0,0);
; 0001 001B             strncpy(MsgOnTheLCD,myMsg+i,16);
	ST   -Y,R19
	ST   -Y,R18
	LDD  R30,Y+8
	LDD  R31,Y+8+1
	ADD  R30,R16
	ADC  R31,R17
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(16)
	CALL _strncpy
; 0001 001C             lcd_puts(MsgOnTheLCD);
	MOVW R26,R18
	RCALL _lcd_puts
; 0001 001D             if (i == 0) delay_ms(750);
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	SBIW R30,0
	BRNE _0x20008
	LDI  R26,LOW(750)
	LDI  R27,HIGH(750)
	CALL _delay_ms
; 0001 001E             delay_ms(140);
_0x20008:
	LDI  R26,LOW(140)
	LDI  R27,0
	CALL _delay_ms
; 0001 001F             lcd_gotoxy(0,1);
	CALL SUBOPT_0x3
; 0001 0020 
; 0001 0021             lcd_puts(space);
	MOVW R26,R20
	RCALL _lcd_puts
; 0001 0022         }
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	ADIW R30,1
	STD  Y+6,R30
	STD  Y+6+1,R31
	RJMP _0x20006
_0x20007:
; 0001 0023 
; 0001 0024 
; 0001 0025 }
	CALL __LOADLOCR6
	ADIW R28,8
	RET
; .FEND

	.DSEG
_0x20004:
	.BYTE 0x4B
;
;
;void keyPad(){
; 0001 0028 void keyPad(){

	.CSEG
_keyPad:
; .FSTART _keyPad
; 0001 0029     unsigned char row;
; 0001 002A     unsigned char column;
; 0001 002B     DDRB = 0xF0;
	ST   -Y,R17
	ST   -Y,R16
;	row -> R17
;	column -> R16
	CALL SUBOPT_0x0
; 0001 002C     PORTB = 0xFF;
; 0001 002D 
; 0001 002E 
; 0001 002F         while(1){
_0x20009:
; 0001 0030             PORTB = 0b11111111;
	CALL SUBOPT_0x4
; 0001 0031             column = (PINB & 0b00001111);
; 0001 0032             if (column != 0b00000000) break;
	BREQ _0x20009
; 0001 0033         }
; 0001 0034 
; 0001 0035          while(1){
_0x2000D:
; 0001 0036             PORTB = 0b11111111;
	CALL SUBOPT_0x4
; 0001 0037             column= (PINB & 0b00001111);
; 0001 0038             if (column == 0b00000000) break;
	BRNE _0x2000D
; 0001 0039         }
; 0001 003A 
; 0001 003B 
; 0001 003C         while(1){
_0x20011:
; 0001 003D             while (1) {
_0x20014:
; 0001 003E                 delay_ms(25);
	CALL SUBOPT_0x5
; 0001 003F                 column = (PINB & 0b00001111);
; 0001 0040                 if (column == 0b00000000) break;
	BRNE _0x20014
; 0001 0041             }
; 0001 0042 
; 0001 0043             delay_ms(25);
	CALL SUBOPT_0x5
; 0001 0044             column = (PINB & 0b00001111);
; 0001 0045             if(column != 0b00000000) break;
	BREQ _0x20011
; 0001 0046         }
; 0001 0047 
; 0001 0048         while (1){
_0x20019:
; 0001 0049             PORTB = 0b00011111;
	LDI  R30,LOW(31)
	CALL SUBOPT_0x6
; 0001 004A             column = (PINB & 0b00001111);
; 0001 004B 
; 0001 004C             if (column != 0b00000000)
	BREQ _0x2001C
; 0001 004D             {
; 0001 004E                 row = 0;
	LDI  R17,LOW(0)
; 0001 004F                 break;
	RJMP _0x2001B
; 0001 0050             }
; 0001 0051 
; 0001 0052             PORTB = 0b00101111;
_0x2001C:
	LDI  R30,LOW(47)
	CALL SUBOPT_0x6
; 0001 0053             column = (PINB & 0b00001111);
; 0001 0054 
; 0001 0055             if (column != 0b00000000)
	BREQ _0x2001D
; 0001 0056             {
; 0001 0057                 row = 1;
	LDI  R17,LOW(1)
; 0001 0058                 break;
	RJMP _0x2001B
; 0001 0059             }
; 0001 005A 
; 0001 005B             PORTB = 0b01001111;
_0x2001D:
	LDI  R30,LOW(79)
	CALL SUBOPT_0x6
; 0001 005C             column = (PINB & 0b00001111);
; 0001 005D 
; 0001 005E             if (column != 0b00000000)
	BREQ _0x2001E
; 0001 005F             {
; 0001 0060                 row = 2;
	LDI  R17,LOW(2)
; 0001 0061                 break;
	RJMP _0x2001B
; 0001 0062             }
; 0001 0063 
; 0001 0064             PORTB = 0b10001111;
_0x2001E:
	LDI  R30,LOW(143)
	CALL SUBOPT_0x6
; 0001 0065             column = (PINB & 0b00001111);
; 0001 0066 
; 0001 0067             if (column != 0b00000000)
	BREQ _0x2001F
; 0001 0068             {
; 0001 0069                 row = 3;
	LDI  R17,LOW(3)
; 0001 006A                 break;
	RJMP _0x2001B
; 0001 006B             }
; 0001 006C         }
_0x2001F:
	RJMP _0x20019
_0x2001B:
; 0001 006D 
; 0001 006E         switch (column) {
	MOV  R30,R16
	LDI  R31,0
; 0001 006F             case 0b00000001:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0x20023
; 0001 0070                 lcd_putchar(myKeyPad[row][0]);
	CALL SUBOPT_0x7
	LD   R26,X
	RCALL _lcd_putchar
; 0001 0071                 tempForKeyPadEntry = myKeyPad[row][0];
	CALL SUBOPT_0x7
	LD   R30,X
	RJMP _0x20041
; 0001 0072                 break;
; 0001 0073             case 0b00000010:
_0x20023:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x20024
; 0001 0074                 lcd_putchar(myKeyPad[row][1]);
	CALL SUBOPT_0x8
	LDD  R26,Z+1
	CALL SUBOPT_0x9
; 0001 0075                 tempForKeyPadEntry = myKeyPad[row][1];
	LDD  R30,Z+1
	RJMP _0x20041
; 0001 0076                 break;
; 0001 0077             case 0b00000100:
_0x20024:
	CPI  R30,LOW(0x4)
	LDI  R26,HIGH(0x4)
	CPC  R31,R26
	BRNE _0x20025
; 0001 0078                 lcd_putchar(myKeyPad[row][2]);
	CALL SUBOPT_0x8
	LDD  R26,Z+2
	CALL SUBOPT_0x9
; 0001 0079                 tempForKeyPadEntry = myKeyPad[row][2];
	LDD  R30,Z+2
	RJMP _0x20041
; 0001 007A                 break;
; 0001 007B             case 0b00001000:
_0x20025:
	CPI  R30,LOW(0x8)
	LDI  R26,HIGH(0x8)
	CPC  R31,R26
	BRNE _0x20022
; 0001 007C                 lcd_putchar(myKeyPad[row][3]);
	CALL SUBOPT_0x8
	LDD  R26,Z+3
	CALL SUBOPT_0x9
; 0001 007D                 tempForKeyPadEntry = myKeyPad[row][3];
	LDD  R30,Z+3
_0x20041:
	STS  _tempForKeyPadEntry,R30
; 0001 007E                 break;
; 0001 007F         }
_0x20022:
; 0001 0080 
; 0001 0081 
; 0001 0082 }
	RJMP _0x2040003
; .FEND
;
;
;void question_03(){
; 0001 0085 void question_03(){
_question_03:
; .FSTART _question_03
; 0001 0086         unsigned int counter = 0;
; 0001 0087         lcd_clear();
	ST   -Y,R17
	ST   -Y,R16
;	counter -> R16,R17
	__GETWRN 16,17,0
	CALL SUBOPT_0x1
; 0001 0088         lcd_gotoxy(0,0);
; 0001 0089         lcd_puts("Question 3:");
	__POINTW2MN _0x20027,0
	CALL SUBOPT_0x2
; 0001 008A         delay_ms(500);
; 0001 008B         lcd_clear();
	CALL SUBOPT_0x1
; 0001 008C         lcd_gotoxy(0,0);
; 0001 008D       while(1){
_0x20028:
; 0001 008E         if (counter == 3) break;
	LDI  R30,LOW(3)
	LDI  R31,HIGH(3)
	CP   R30,R16
	CPC  R31,R17
	BREQ _0x2002A
; 0001 008F         keyPad();
	RCALL _keyPad
; 0001 0090         counter++;
	__ADDWRN 16,17,1
; 0001 0091       }
	RJMP _0x20028
_0x2002A:
; 0001 0092 }
	RJMP _0x2040003
; .FEND

	.DSEG
_0x20027:
	.BYTE 0xC
;
;void question_04(){
; 0001 0094 void question_04(){

	.CSEG
_question_04:
; .FSTART _question_04
; 0001 0095             DDRB = 0xF0;
	CALL SUBOPT_0x0
; 0001 0096             PORTB = 0xFF;
; 0001 0097             #asm("sei")     // Global enable interrupts
	sei
; 0001 0098 
; 0001 0099 }
	RET
; .FEND
;
;void question_05(){
; 0001 009B void question_05(){
_question_05:
; .FSTART _question_05
; 0001 009C         unsigned char keyPadFirstEntry;
; 0001 009D         unsigned char keyPadSecondEntry;
; 0001 009E 
; 0001 009F         lcd_clear();
	ST   -Y,R17
	ST   -Y,R16
;	keyPadFirstEntry -> R17
;	keyPadSecondEntry -> R16
	CALL SUBOPT_0x1
; 0001 00A0         lcd_gotoxy(0,0);
; 0001 00A1         lcd_puts("Enter number forSPEED(0-50): ");
	__POINTW2MN _0x2002C,0
	CALL SUBOPT_0xA
; 0001 00A2         keyPad();
; 0001 00A3         keyPadFirstEntry = tempForKeyPadEntry;
; 0001 00A4         keyPad();
; 0001 00A5         keyPadSecondEntry = tempForKeyPadEntry;
; 0001 00A6         delay_ms(50);
; 0001 00A7         if(keyPadFirstEntry > '5' || keyPadSecondEntry > '9' || keyPadFirstEntry < '0' || (keyPadFirstEntry == '5' && ke ...
	CPI  R17,54
	BRSH _0x2002E
	CPI  R16,58
	BRSH _0x2002E
	CPI  R17,48
	BRLO _0x2002E
	CPI  R17,53
	BRNE _0x2002F
	CPI  R16,48
	BRNE _0x2002E
_0x2002F:
	RJMP _0x2002D
_0x2002E:
; 0001 00A8             lcd_clear();
	CALL SUBOPT_0x1
; 0001 00A9             lcd_gotoxy(0,0);
; 0001 00AA             lcd_puts("SPEED EE for ");
	__POINTW2MN _0x2002C,30
	RJMP _0x20042
; 0001 00AB             lcd_putchar(keyPadFirstEntry);
; 0001 00AC             lcd_putchar(keyPadSecondEntry);
; 0001 00AD         }
; 0001 00AE         else {
_0x2002D:
; 0001 00AF             lcd_clear();
	CALL SUBOPT_0x1
; 0001 00B0             lcd_gotoxy(0,0);
; 0001 00B1             lcd_puts("Set successfully");
	__POINTW2MN _0x2002C,44
_0x20042:
	RCALL _lcd_puts
; 0001 00B2             lcd_putchar(keyPadFirstEntry);
	CALL SUBOPT_0xB
; 0001 00B3             lcd_putchar(keyPadSecondEntry);
; 0001 00B4         }
; 0001 00B5 
; 0001 00B6         delay_ms(1400);
	CALL SUBOPT_0xC
; 0001 00B7 
; 0001 00B8         lcd_clear();
; 0001 00B9         lcd_gotoxy(0,0);
; 0001 00BA         lcd_puts("Enter number forTIME(0-99s): ");
	__POINTW2MN _0x2002C,61
	CALL SUBOPT_0xA
; 0001 00BB         keyPad();
; 0001 00BC         keyPadFirstEntry = tempForKeyPadEntry;
; 0001 00BD         keyPad();
; 0001 00BE         keyPadSecondEntry = tempForKeyPadEntry;
; 0001 00BF         delay_ms(50);
; 0001 00C0         if(keyPadFirstEntry > '9' || keyPadSecondEntry > '9'){
	CPI  R17,58
	BRSH _0x20034
	CPI  R16,58
	BRLO _0x20033
_0x20034:
; 0001 00C1             lcd_clear();
	CALL SUBOPT_0x1
; 0001 00C2             lcd_gotoxy(0,0);
; 0001 00C3             lcd_puts("TIME EE for ");
	__POINTW2MN _0x2002C,91
	RJMP _0x20043
; 0001 00C4             lcd_putchar(keyPadFirstEntry);
; 0001 00C5             lcd_putchar(keyPadSecondEntry);
; 0001 00C6         }
; 0001 00C7         else {
_0x20033:
; 0001 00C8             lcd_clear();
	CALL SUBOPT_0x1
; 0001 00C9             lcd_gotoxy(0,0);
; 0001 00CA             lcd_puts("Set successfully");
	__POINTW2MN _0x2002C,104
_0x20043:
	RCALL _lcd_puts
; 0001 00CB             lcd_putchar(keyPadFirstEntry);
	CALL SUBOPT_0xB
; 0001 00CC             lcd_putchar(keyPadSecondEntry);
; 0001 00CD         }
; 0001 00CE 
; 0001 00CF         delay_ms(1400);
	CALL SUBOPT_0xC
; 0001 00D0 
; 0001 00D1         lcd_clear();
; 0001 00D2         lcd_gotoxy(0,0);
; 0001 00D3         lcd_puts("Enter number forWEIGHT(0-99F): ");
	__POINTW2MN _0x2002C,121
	CALL SUBOPT_0xA
; 0001 00D4         keyPad();
; 0001 00D5         keyPadFirstEntry = tempForKeyPadEntry;
; 0001 00D6         keyPad();
; 0001 00D7         keyPadSecondEntry = tempForKeyPadEntry;
; 0001 00D8         delay_ms(50);
; 0001 00D9         if(keyPadFirstEntry > '9' || keyPadSecondEntry > '9'){
	CPI  R17,58
	BRSH _0x20038
	CPI  R16,58
	BRLO _0x20037
_0x20038:
; 0001 00DA             lcd_clear();
	CALL SUBOPT_0x1
; 0001 00DB             lcd_gotoxy(0,0);
; 0001 00DC             lcd_puts("WEIGHT EE for ");
	__POINTW2MN _0x2002C,153
	RJMP _0x20044
; 0001 00DD             lcd_putchar(keyPadFirstEntry);
; 0001 00DE             lcd_putchar(keyPadSecondEntry);
; 0001 00DF         }
; 0001 00E0         else {
_0x20037:
; 0001 00E1             lcd_clear();
	CALL SUBOPT_0x1
; 0001 00E2             lcd_gotoxy(0,0);
; 0001 00E3             lcd_puts("Set successfully");
	__POINTW2MN _0x2002C,168
_0x20044:
	RCALL _lcd_puts
; 0001 00E4             lcd_putchar(keyPadFirstEntry);
	CALL SUBOPT_0xB
; 0001 00E5             lcd_putchar(keyPadSecondEntry);
; 0001 00E6         }
; 0001 00E7 
; 0001 00E8         delay_ms(1400);
	CALL SUBOPT_0xC
; 0001 00E9 
; 0001 00EA         lcd_clear();
; 0001 00EB         lcd_gotoxy(0,0);
; 0001 00EC         lcd_puts("Enter number forTEMP(20-80C): ");
	__POINTW2MN _0x2002C,185
	CALL SUBOPT_0xA
; 0001 00ED         keyPad();
; 0001 00EE         keyPadFirstEntry = tempForKeyPadEntry;
; 0001 00EF         keyPad();
; 0001 00F0         keyPadSecondEntry = tempForKeyPadEntry;
; 0001 00F1         delay_ms(50);
; 0001 00F2         if(keyPadFirstEntry > '8' || keyPadSecondEntry > '9' || keyPadFirstEntry < '2' || (keyPadFirstEntry == '8' && ke ...
	CPI  R17,57
	BRSH _0x2003C
	CPI  R16,58
	BRSH _0x2003C
	CPI  R17,50
	BRLO _0x2003C
	CPI  R17,56
	BRNE _0x2003D
	CPI  R16,48
	BRNE _0x2003C
_0x2003D:
	RJMP _0x2003B
_0x2003C:
; 0001 00F3             lcd_clear();
	CALL SUBOPT_0x1
; 0001 00F4             lcd_gotoxy(0,0);
; 0001 00F5             lcd_puts("TEMP EE for ");
	__POINTW2MN _0x2002C,216
	RJMP _0x20045
; 0001 00F6             lcd_putchar(keyPadFirstEntry);
; 0001 00F7             lcd_putchar(keyPadSecondEntry);
; 0001 00F8         }
; 0001 00F9         else {
_0x2003B:
; 0001 00FA             lcd_clear();
	CALL SUBOPT_0x1
; 0001 00FB             lcd_gotoxy(0,0);
; 0001 00FC             lcd_puts("Set successfully");
	__POINTW2MN _0x2002C,229
_0x20045:
	RCALL _lcd_puts
; 0001 00FD             lcd_putchar(keyPadFirstEntry);
	CALL SUBOPT_0xB
; 0001 00FE             lcd_putchar(keyPadSecondEntry);
; 0001 00FF         }
; 0001 0100 
; 0001 0101         delay_ms(1400);
	LDI  R26,LOW(1400)
	LDI  R27,HIGH(1400)
	CALL _delay_ms
; 0001 0102 
; 0001 0103 }
_0x2040003:
	LD   R16,Y+
	LD   R17,Y+
	RET
; .FEND

	.DSEG
_0x2002C:
	.BYTE 0xF6
;
;
;void ioInit(){
; 0001 0106 void ioInit(){

	.CSEG
_ioInit:
; .FSTART _ioInit
; 0001 0107     // Input/Output Ports initialization
; 0001 0108     // Port A initialization
; 0001 0109     // Function: Bit7=Out Bit6=Out Bit5=Out Bit4=Out Bit3=Out Bit2=Out Bit1=Out Bit0=Out
; 0001 010A     DDRA=(1<<DDA7) | (1<<DDA6) | (1<<DDA5) | (1<<DDA4) | (1<<DDA3) | (1<<DDA2) | (1<<DDA1) | (1<<DDA0);
	LDI  R30,LOW(255)
	OUT  0x1A,R30
; 0001 010B     // State: Bit7=0 Bit6=0 Bit5=0 Bit4=0 Bit3=0 Bit2=0 Bit1=0 Bit0=0
; 0001 010C     PORTA=(0<<PORTA7) | (0<<PORTA6) | (0<<PORTA5) | (0<<PORTA4) | (0<<PORTA3) | (0<<PORTA2) | (0<<PORTA1) | (0<<PORTA0);
	LDI  R30,LOW(0)
	OUT  0x1B,R30
; 0001 010D 
; 0001 010E 
; 0001 010F 
; 0001 0110 
; 0001 0111 }
	RET
; .FEND
;
;void interruptInit(){
; 0001 0113 void interruptInit(){
_interruptInit:
; .FSTART _interruptInit
; 0001 0114 
; 0001 0115     // External Interrupt(s) initialization
; 0001 0116     // INT0: Off
; 0001 0117     // INT1: On
; 0001 0118     // INT1 Mode: Rising Edge
; 0001 0119     // INT2: Off
; 0001 011A 
; 0001 011B     GICR|=(1<<INT1) | (0<<INT0) | (0<<INT2);
	IN   R30,0x3B
	ORI  R30,0x80
	OUT  0x3B,R30
; 0001 011C     MCUCR=(1<<ISC11) | (1<<ISC10) | (0<<ISC01) | (0<<ISC00);
	LDI  R30,LOW(12)
	OUT  0x35,R30
; 0001 011D     MCUCSR=(0<<ISC2);
	LDI  R30,LOW(0)
	OUT  0x34,R30
; 0001 011E     GIFR=(1<<INTF1) | (0<<INTF0) | (0<<INTF2);
	LDI  R30,LOW(128)
	OUT  0x3A,R30
; 0001 011F 
; 0001 0120 
; 0001 0121 }
	RET
; .FEND
;
;
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

	.DSEG

	.CSEG
__lcd_write_nibble_G100:
; .FSTART __lcd_write_nibble_G100
	ST   -Y,R26
	IN   R30,0x1B
	ANDI R30,LOW(0xF)
	MOV  R26,R30
	LD   R30,Y
	ANDI R30,LOW(0xF0)
	OR   R30,R26
	OUT  0x1B,R30
	__DELAY_USB 13
	SBI  0x1B,2
	__DELAY_USB 13
	CBI  0x1B,2
	__DELAY_USB 13
	RJMP _0x2040001
; .FEND
__lcd_write_data:
; .FSTART __lcd_write_data
	ST   -Y,R26
	LD   R26,Y
	RCALL __lcd_write_nibble_G100
    ld    r30,y
    swap  r30
    st    y,r30
	LD   R26,Y
	RCALL __lcd_write_nibble_G100
	__DELAY_USB 133
	RJMP _0x2040001
; .FEND
_lcd_gotoxy:
; .FSTART _lcd_gotoxy
	ST   -Y,R26
	LD   R30,Y
	LDI  R31,0
	SUBI R30,LOW(-__base_y_G100)
	SBCI R31,HIGH(-__base_y_G100)
	LD   R30,Z
	LDD  R26,Y+1
	ADD  R26,R30
	RCALL __lcd_write_data
	LDD  R5,Y+1
	LDD  R4,Y+0
	ADIW R28,2
	RET
; .FEND
_lcd_clear:
; .FSTART _lcd_clear
	LDI  R26,LOW(2)
	CALL SUBOPT_0xD
	LDI  R26,LOW(12)
	RCALL __lcd_write_data
	LDI  R26,LOW(1)
	CALL SUBOPT_0xD
	LDI  R30,LOW(0)
	MOV  R4,R30
	MOV  R5,R30
	RET
; .FEND
_lcd_putchar:
; .FSTART _lcd_putchar
	ST   -Y,R26
	LD   R26,Y
	CPI  R26,LOW(0xA)
	BREQ _0x2000005
	CP   R5,R7
	BRLO _0x2000004
_0x2000005:
	LDI  R30,LOW(0)
	ST   -Y,R30
	INC  R4
	MOV  R26,R4
	RCALL _lcd_gotoxy
	LD   R26,Y
	CPI  R26,LOW(0xA)
	BRNE _0x2000007
	RJMP _0x2040001
_0x2000007:
_0x2000004:
	INC  R5
	SBI  0x1B,0
	LD   R26,Y
	RCALL __lcd_write_data
	CBI  0x1B,0
	RJMP _0x2040001
; .FEND
_lcd_puts:
; .FSTART _lcd_puts
	ST   -Y,R27
	ST   -Y,R26
	ST   -Y,R17
_0x2000008:
	LDD  R26,Y+1
	LDD  R27,Y+1+1
	LD   R30,X+
	STD  Y+1,R26
	STD  Y+1+1,R27
	MOV  R17,R30
	CPI  R30,0
	BREQ _0x200000A
	MOV  R26,R17
	RCALL _lcd_putchar
	RJMP _0x2000008
_0x200000A:
	RJMP _0x2040002
; .FEND
_lcd_putsf:
; .FSTART _lcd_putsf
	ST   -Y,R27
	ST   -Y,R26
	ST   -Y,R17
_0x200000B:
	LDD  R30,Y+1
	LDD  R31,Y+1+1
	ADIW R30,1
	STD  Y+1,R30
	STD  Y+1+1,R31
	SBIW R30,1
	LPM  R30,Z
	MOV  R17,R30
	CPI  R30,0
	BREQ _0x200000D
	MOV  R26,R17
	RCALL _lcd_putchar
	RJMP _0x200000B
_0x200000D:
_0x2040002:
	LDD  R17,Y+0
	ADIW R28,3
	RET
; .FEND
_lcd_init:
; .FSTART _lcd_init
	ST   -Y,R26
	IN   R30,0x1A
	ORI  R30,LOW(0xF0)
	OUT  0x1A,R30
	SBI  0x1A,2
	SBI  0x1A,0
	SBI  0x1A,1
	CBI  0x1B,2
	CBI  0x1B,0
	CBI  0x1B,1
	LDD  R7,Y+0
	LD   R30,Y
	SUBI R30,-LOW(128)
	__PUTB1MN __base_y_G100,2
	LD   R30,Y
	SUBI R30,-LOW(192)
	__PUTB1MN __base_y_G100,3
	LDI  R26,LOW(20)
	LDI  R27,0
	CALL _delay_ms
	CALL SUBOPT_0xE
	CALL SUBOPT_0xE
	CALL SUBOPT_0xE
	LDI  R26,LOW(32)
	RCALL __lcd_write_nibble_G100
	__DELAY_USW 200
	LDI  R26,LOW(40)
	RCALL __lcd_write_data
	LDI  R26,LOW(4)
	RCALL __lcd_write_data
	LDI  R26,LOW(133)
	RCALL __lcd_write_data
	LDI  R26,LOW(6)
	RCALL __lcd_write_data
	RCALL _lcd_clear
_0x2040001:
	ADIW R28,1
	RET
; .FEND

	.CSEG
_strlen:
; .FSTART _strlen
	ST   -Y,R27
	ST   -Y,R26
    ld   r26,y+
    ld   r27,y+
    clr  r30
    clr  r31
strlen0:
    ld   r22,x+
    tst  r22
    breq strlen1
    adiw r30,1
    rjmp strlen0
strlen1:
    ret
; .FEND
_strncpy:
; .FSTART _strncpy
	ST   -Y,R26
    ld   r23,y+
    ld   r30,y+
    ld   r31,y+
    ld   r26,y+
    ld   r27,y+
    movw r24,r26
strncpy0:
    tst  r23
    breq strncpy1
    dec  r23
    ld   r22,z+
    st   x+,r22
    tst  r22
    brne strncpy0
strncpy2:
    tst  r23
    breq strncpy1
    dec  r23
    st   x+,r22
    rjmp strncpy2
strncpy1:
    movw r30,r24
    ret
; .FEND

	.DSEG
_tempForKeyPadEntry:
	.BYTE 0x1
_myKeyPad:
	.BYTE 0x10
__base_y_G100:
	.BYTE 0x4

	.CSEG
;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x0:
	LDI  R30,LOW(240)
	OUT  0x17,R30
	LDI  R30,LOW(255)
	OUT  0x18,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 17 TIMES, CODE SIZE REDUCTION:77 WORDS
SUBOPT_0x1:
	CALL _lcd_clear
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R26,LOW(0)
	JMP  _lcd_gotoxy

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x2:
	CALL _lcd_puts
	LDI  R26,LOW(500)
	LDI  R27,HIGH(500)
	JMP  _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x3:
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R26,LOW(1)
	JMP  _lcd_gotoxy

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x4:
	LDI  R30,LOW(255)
	OUT  0x18,R30
	IN   R30,0x16
	ANDI R30,LOW(0xF)
	MOV  R16,R30
	CPI  R16,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x5:
	LDI  R26,LOW(25)
	LDI  R27,0
	CALL _delay_ms
	IN   R30,0x16
	ANDI R30,LOW(0xF)
	MOV  R16,R30
	CPI  R16,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x6:
	OUT  0x18,R30
	IN   R30,0x16
	ANDI R30,LOW(0xF)
	MOV  R16,R30
	CPI  R16,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x7:
	MOV  R30,R17
	LDI  R26,LOW(_myKeyPad)
	LDI  R27,HIGH(_myKeyPad)
	LDI  R31,0
	CALL __LSLW2
	ADD  R26,R30
	ADC  R27,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:27 WORDS
SUBOPT_0x8:
	MOV  R30,R17
	LDI  R26,LOW(_myKeyPad)
	LDI  R27,HIGH(_myKeyPad)
	LDI  R31,0
	CALL __LSLW2
	ADD  R30,R26
	ADC  R31,R27
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x9:
	CALL _lcd_putchar
	RJMP SUBOPT_0x8

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:33 WORDS
SUBOPT_0xA:
	CALL _lcd_puts
	CALL _keyPad
	LDS  R17,_tempForKeyPadEntry
	CALL _keyPad
	LDS  R16,_tempForKeyPadEntry
	LDI  R26,LOW(50)
	LDI  R27,0
	JMP  _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0xB:
	MOV  R26,R17
	CALL _lcd_putchar
	MOV  R26,R16
	JMP  _lcd_putchar

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0xC:
	LDI  R26,LOW(1400)
	LDI  R27,HIGH(1400)
	CALL _delay_ms
	RJMP SUBOPT_0x1

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xD:
	CALL __lcd_write_data
	LDI  R26,LOW(3)
	LDI  R27,0
	JMP  _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0xE:
	LDI  R26,LOW(48)
	CALL __lcd_write_nibble_G100
	__DELAY_USW 200
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

__LSLW2:
	LSL  R30
	ROL  R31
	LSL  R30
	ROL  R31
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
