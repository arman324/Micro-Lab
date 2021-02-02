/*******************************************************
This program was created by the
CodeWizardAVR V3.12 Advanced
Automatic Program Generator
� Copyright 1998-2014 Pavel Haiduc, HP InfoTech s.r.l.
http://www.hpinfotech.com

Project :
Version :
Date    : 11/1/2020
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

int inputNumber = 0;
float dutyCycle = 0;
float ocrNumber = 0;
int CNT = 0;
int TempCNT = 0;
int LeftRight = 1; //Left = 0 & Right = 1


// Timer 0 overflow interrupt service routine
interrupt [TIM0_OVF] void timer0_ovf_isr(void)
{
// Place your code here
     inputNumber = PINA;

    dutyCycle = ((inputNumber * 90) / 255) + 5;
    ocrNumber = (2.55 * dutyCycle) + 0.5;

    OCR0 = floor(ocrNumber);

}


// Timer2 overflow interrupt service routine
interrupt [TIM2_OVF] void timer2_ovf_isr(void)
{

    TCNT2=0x0B; //31.36 ms

    runStepperMotor();
    calculateSpeed();

}

void main(void)
{
    ioInit();
    #asm("sei")
    lcd_init(16);

    //question_01();
    //question_03();
    //question_04();
    question_05();
}
