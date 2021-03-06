/*******************************************************
This program was created by the
CodeWizardAVR V3.12 Advanced
Automatic Program Generator
� Copyright 1998-2014 Pavel Haiduc, HP InfoTech s.r.l.
http://www.hpinfotech.com

Project :
Version :
Date    : 10/8/2020
Author  : Arman Riasi
Company :
Comments:


Chip type               : ATmega16
Program type            : Application
AVR Core Clock frequency: 8.000000 MHz
Memory model            : Small
External RAM size       : 0
Data Stack size         : 256
*******************************************************/
#include <define.h>


unsigned char tempForKeyPadEntry;
unsigned char myKeyPad[4][4] = {
'0','1','2','3',
'4','5','6','7',
'8','9','A','B',
'C','D','E','F'
};

// External Interrupt 1 service routine
interrupt [EXT_INT1] void myInterrupt(void)
{

        DDRC = 0x01;
        PORTC = 0x01;
        DDRB = 0xF0;
        PORTB = 0xFF;
        keyPad();
        DDRB = 0xF0;
        PORTB = 0xFF;
        PORTC = 0x00;

}

void main(void){
    ioInit();
    interruptInit();
    lcd_init(16);  // Alphanumeric LCD initialization


    //question_01();
    //question_02();
    //question_03();
    //question_04();
    //question_05();


    //FOR Question 06:
    question_01();
    question_02();
    question_03();
    question_05();
            lcd_clear();
            lcd_gotoxy(0,0);
            lcd_puts("Question 4");
            delay_ms(500);
            lcd_clear();
    question_04();

}
