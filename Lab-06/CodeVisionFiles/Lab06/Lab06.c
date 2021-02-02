/*******************************************************
This program was created by the
CodeWizardAVR V3.12 Advanced
Automatic Program Generator
© Copyright 1998-2014 Pavel Haiduc, HP InfoTech s.r.l.
http://www.hpinfotech.com

Project :
Version :
Date    : 11/5/2020
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


unsigned int adc_data[LAST_ADC_INPUT-FIRST_ADC_INPUT+1];
unsigned int last_result[8] = {0};

char* space = "                ";
int i = 0;
char resultInString[18];
int result = 0;
int result2 = 0;

float temp1 = 0;
float temp2 = 0;

long int input = 0;
float dutyCycle = 0;
float ocrNumber = 0;


interrupt [ADC_INT] void adc_isr(void)
{
    float FivePercent01 = 0;
    float FivePercent02 = 0;
    result = 0;
    temp1 = 0;
    temp2 = 0;
    result2 = 0;

    static unsigned char input_index=0;
    // Read the AD conversion result
    adc_data[input_index]=ADCW;
    // Select next ADC input
    if (++input_index > (LAST_ADC_INPUT-FIRST_ADC_INPUT))
       input_index=0;
    ADMUX=(FIRST_ADC_INPUT | ADC_VREF_TYPE)+input_index;
    // Delay needed for the stabilization of the ADC input voltage
    delay_us(10);


    i++;

        result = adc_data[i];
        result2 = result;
        temp2 = result * 5;
        FivePercent01 = ((temp2)/100) + result;
        FivePercent02 = result -((temp2)/100);
        if (FivePercent01 < last_result[i] || FivePercent02 > last_result[i]){
            lcd_clear();
            lcd_gotoxy(0,0);
            lcd_puts("Q_2 -> 5% change");
            temp2 = result * 5;
            temp1 = temp2 / 1023;
            temp1 = temp1 * 1000;
            result = floor(temp1); //milliVolt
            sprintf(resultInString,"ADC %d: %d mV",i,result);
            lcd_gotoxy(0,1);
            lcd_puts(space);
            lcd_gotoxy(0,1);
            lcd_puts(resultInString);
            delay_ms(1000);
            last_result[i] = result2;
        }

    if (i == 7){
     i = -1;
     }





    // Start the AD conversion
    ADCSRA|=(1<<ADSC);
}

// Timer 0 overflow interrupt service routine
interrupt [TIM0_OVF] void timer0_ovf_isr(void)
{

    input = read_adc(0);
    dutyCycle = input*90;
    dutyCycle = (dutyCycle/1023) + 5;
    ocrNumber = (2.55 * dutyCycle) + 0.5;


    OCR0 = floor(ocrNumber);

}



void main(void)
{
    ioInit();
    lcd_init(16);


    //question_01();
    //question_02();
    //question_03();
    question_04();
}
