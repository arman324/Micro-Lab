#ifndef _define_INCLUDED_
#define _define_INCLUDED_

#include <mega16.h>
#include <stdio.h>
#include <delay.h>
#include <alcd.h>
#include <math.h>
#include <functions.h>

#define ADC_VREF_TYPE ((0<<REFS1) | (1<<REFS0) | (0<<ADLAR))
#define FIRST_ADC_INPUT 0
#define LAST_ADC_INPUT 7

extern unsigned int adc_data[LAST_ADC_INPUT-FIRST_ADC_INPUT+1];
extern unsigned int last_result[8];

extern char* space;
extern int i;
extern char resultInString[18];
extern int result;
extern int result2;

extern float temp1;
extern float temp2;

extern long int input;
extern float dutyCycle;
extern float ocrNumber;



#endif

