/*******************************************************
This program was created by the
CodeWizardAVR V3.12 Advanced
Automatic Program Generator
© Copyright 1998-2014 Pavel Haiduc, HP InfoTech s.r.l.
http://www.hpinfotech.com

Project :
Version :
Date    : 10/22/2020
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

unsigned int START;
unsigned int STOP;
unsigned int CNT1 = 0;
unsigned int CNT2 = 0;
unsigned int CNT3 = 0;
unsigned int CNT4 = 0;
unsigned int CE = 0;
char* space = "                ";


// External Interrupt 0 service routine
interrupt [EXT_INT0] void ext_int0_isr(void)
{
    char *temp = " ";

    if (PINB.2 == 0){ //CAR_IN
        CE--;
        if (CE == 0){
            lcd_gotoxy(0,1);
            lcd_puts(space);
            lcd_gotoxy(0,1);
            lcd_puts("CE: FULL");
        }
        else{
            sprintf(temp,"%d",CE);
            lcd_gotoxy(0,1);
            lcd_puts(space);
            lcd_gotoxy(0,1);
            lcd_puts("CE: ");
            lcd_puts(temp);
        }
    }
    if (PINB.3 == 0){ //CAR_OUT
        if (CE == 1000){
            lcd_gotoxy(0,1);
            lcd_puts(space);
            lcd_gotoxy(0,1);
            lcd_puts("CE: 1000");
        }
        else {
            CE++;
            sprintf(temp,"%d",CE);
            lcd_gotoxy(0,1);
            lcd_puts(space);
            lcd_gotoxy(0,1);
            lcd_puts("CE: ");
            lcd_puts(temp);
            }
    }

}

// External Interrupt 1 service routine
interrupt [EXT_INT1] void ext_int1_isr(void)
{
    if (PINB.4 == 0){ //START is ON
        lcd_gotoxy(0,0);
        lcd_puts(space);
        lcd_gotoxy(0,0);
        timerInit();
        STOP = 1;
    }
    if (PINB.5 == 0 && STOP == 10){ //STOP is ON
        //TCCR0=(0<<WGM00) | (0<<COM01) | (0<<COM00) | (0<<WGM01) | (0<<CS02) | (0<<CS01) | (0<<CS00);
        lcd_gotoxy(0,0);
        lcd_puts(space);
        lcd_gotoxy(0,0);
        lcd_puts("00:00:00:00");
        lcd_gotoxy(0,0);
        lcd_puts(space);
        lcd_gotoxy(0,0);
        lcd_puts("00:00:00:00");
        STOP = 1;
        CNT1 = 0;
        CNT2 = 0;
        CNT3 = 0;
        CNT4 = 0;
    }
    else if (PINB.5 == 0){ //STOP is ON
        STOP = 10; //means stop is on
        TCCR0=(0<<WGM00) | (0<<COM01) | (0<<COM00) | (0<<WGM01) | (0<<CS02) | (0<<CS01) | (0<<CS00);

    }


}

// Timer 0 overflow interrupt service routine
interrupt [TIM0_OVF] void timer0_ovf_isr(void)
{
    // Reinitialize Timer 0 value
    TCNT0=0xB2;

    counter();

}

void main(void)
{
    ioInit();
    interruptInit();
    lcd_init(16);


    //question_01();
    //question_02();
    question_03();
}
