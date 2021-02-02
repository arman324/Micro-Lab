#include <define.h>


void IO_Init(){
    // Input/Output Ports initialization
    // Port A initialization
    // Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In 
    DDRA=(0<<DDA7) | (0<<DDA6) | (0<<DDA5) | (0<<DDA4) | (0<<DDA3) | (0<<DDA2) | (0<<DDA1) | (0<<DDA0);
    // State: Bit7=T Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T 
    PORTA=(0<<PORTA7) | (0<<PORTA6) | (0<<PORTA5) | (0<<PORTA4) | (0<<PORTA3) | (0<<PORTA2) | (0<<PORTA1) | (0<<PORTA0);

    // Port B initialization
    // Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In 
    DDRB=(0<<DDB7) | (0<<DDB6) | (0<<DDB5) | (0<<DDB4) | (0<<DDB3) | (0<<DDB2) | (0<<DDB1) | (0<<DDB0);
    // State: Bit7=T Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T 
    PORTB=(0<<PORTB7) | (0<<PORTB6) | (0<<PORTB5) | (0<<PORTB4) | (0<<PORTB3) | (0<<PORTB2) | (0<<PORTB1) | (0<<PORTB0);

    // Port C initialization
    // Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In 
    DDRC=(0<<DDC7) | (0<<DDC6) | (0<<DDC5) | (0<<DDC4) | (0<<DDC3) | (0<<DDC2) | (0<<DDC1) | (0<<DDC0);
    // State: Bit7=T Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T 
    PORTC=(0<<PORTC7) | (0<<PORTC6) | (0<<PORTC5) | (0<<PORTC4) | (0<<PORTC3) | (0<<PORTC2) | (0<<PORTC1) | (0<<PORTC0);

    // Port D initialization
    // Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In 
    DDRD=(0<<DDD7) | (0<<DDD6) | (0<<DDD5) | (0<<DDD4) | (0<<DDD3) | (0<<DDD2) | (0<<DDD1) | (0<<DDD0);
    // State: Bit7=T Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T 
    PORTD=(0<<PORTD7) | (0<<PORTD6) | (0<<PORTD5) | (0<<PORTD4) | (0<<PORTD3) | (0<<PORTD2) | (0<<PORTD1) | (0<<PORTD0);

}

void Question_01(){

     i = 0;  
     j = 0;
     myMax = 8;
     myMin = 0;
     
     while(1){
         while (1){
            PORTD = 0x80;
            PORTB = ~AR16x8[i];
            PORTA = 1<<j;

            delay_ms(2);

            PORTD = 0x00;
            PORTB = ~AR16x8[i+8];
            PORTA = 1<<j;

            i++;
            if (i == myMax) i = myMin;
            j = (j+1)%8;
            delay_ms(2);
            count++;
            
            if (count == 200){
                count = 0;        
                break;
            }

         }
         
         
     switch(myMax){
        case 8:
            myMax = 24;
            myMin = 16;
            break;
        case 24:
            myMax = 40;
            myMin = 32;
            break;  
        case 40:
            myMax = 56;
            myMin = 48;
            break;
        case 56:
            myMax = 72;
            myMin = 64;
            break;
        case 72:
            myMax = 88;
            myMin = 80;
            break;
        case 88:
            myMax = 104;
            myMin = 96;
            break;
        case 104:
            myMax = 120;
            myMin = 112;
            break;
        case 120:
            myMax = 136;
            myMin = 128;
            break;    
        case 136:
            myMax = 152;
            myMin = 144;
            break;
        case 152:
            myMax = 168;
            myMin = 160;
            break; 
        case 168:
            myMax = 184;
            myMin = 176;
            break;    
        case 184:
            myMax = 200;
            myMin = 192;
            break;
        case 200:
            myMax = 216;
            myMin = 208;
            break;         
        case 216:
            myMax = 232;
            myMin = 224;
            break; 
        case 232:
            myMax = 248;
            myMin = 240;
            break;    
        case 248:
            myMax = 8;
            myMin = 0; 
            i = 0;
            j = 0;
            break;                 
 
     }        
         
   }
}

void Question_02(){
    glcd_putimagef(0,0,ds,GLCD_PUTCOPY);

}

void Question_03(){
    
        
        second++;
        if(second == 60)
        {
            minute++;
            second = 0;  
        }
        if(minute == 60)
        {
            hour++;
            minute = 0;
        }
        if(hour == 12){
            hour = 0;  
            
        }
        
        glcd_clear();
       
        glcd_circle(63, 31, 30);
        glcd_setlinestyle(3,4);
        glcd_circle(63, 31, 2);
        glcd_setlinestyle(1,GLCD_LINE_SOLID); 

        x = 25*cos(second*6);
        y = 25*sin(second*6);
      
        glcd_line(63,31,x+63,31-y); 
        
        x = 20*cos(minute*6);
        y = 20*sin(minute*6);
        
        glcd_line(63,31,x+63,31-y); 
        
        x = 15*cos(hour*6);
        y = 15*sin(hour*6);
        
        glcd_line(63,31,x+63,31-y); 
}


void TimerInit(){


    // Timer/Counter 1 initialization
    // Clock source: System Clock
    // Clock value: 31.250 kHz
    // Mode: Normal top=0xFFFF
    // OC1A output: Disconnected
    // OC1B output: Disconnected
    // Noise Canceler: Off
    // Input Capture on Falling Edge
    // Timer Period: 1 s
    // Timer1 Overflow Interrupt: On
    // Input Capture Interrupt: Off
    // Compare A Match Interrupt: Off
    // Compare B Match Interrupt: Off
    TCCR1A=(0<<COM1A1) | (0<<COM1A0) | (0<<COM1B1) | (0<<COM1B0) | (0<<WGM11) | (0<<WGM10);
    TCCR1B=(0<<ICNC1) | (0<<ICES1) | (0<<WGM13) | (0<<WGM12) | (1<<CS12) | (0<<CS11) | (0<<CS10);
    TCNT1H=0x85;
    TCNT1L=0xEE;
    ICR1H=0x00;
    ICR1L=0x00;
    OCR1AH=0x00;
    OCR1AL=0x00;
    OCR1BH=0x00;
    OCR1BL=0x00;

    // Timer(s)/Counter(s) Interrupt(s) initialization
    TIMSK=(0<<OCIE2) | (0<<TOIE2) | (0<<TICIE1) | (0<<OCIE1A) | (0<<OCIE1B) | (1<<TOIE1) | (0<<OCIE0) | (0<<TOIE0);


}