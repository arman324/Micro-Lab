

#include <define.h>


void question_01(int number,char portSelect, int delayTime){
    count = 0;

    while(count < number){
        switch(portSelect){
         case portA:
            DDRA = 0xFF;
            PORTA = 0xFF;
            delay_ms(delayTime);
            PORTA = 0x00;
            delay_ms(delayTime);
            break;

         case portB:
            DDRB = 0xFF;
            PORTB = 0xFF;
            delay_ms(delayTime);
            PORTB = 0x00;
            delay_ms(delayTime);
            break;

         case portC:
            DDRC = 0xFF;
            PORTC = 0xFF;
            delay_ms(delayTime);
            PORTC = 0x00;
            delay_ms(delayTime);
            break;

         case portD:
            DDRD = 0xFF;
            PORTD = 0xFF;
            delay_ms(delayTime);
            PORTD = 0x00;
            delay_ms(delayTime);
            break;

         default:
            DDRD = 0xFF;
            PORTD = 0xFF;
            delay_ms(delayTime);
            PORTD = 0x00;
            delay_ms(delayTime);
            break;
     }
         count++;
    }

}

void question_02(int delayTime, int position){
    char currentPosition;
    DDRB = 0xFF;
    count = 0;
    currentPosition = position;
    while(1){

            if (currentPosition == 0) {
                PORTB = 0b00000001;
                delay_ms(delayTime);
                currentPosition ++;
                count++;
                if (count == 16) break;
            }

            if (currentPosition == 1) {
                PORTB = 0b00000010;
                delay_ms(delayTime);
                currentPosition ++;
                count++;
                if (count == 16) break;
            }

            if (currentPosition == 2) {
                PORTB = 0b00000100;
                delay_ms(delayTime);
                currentPosition ++;
                count++;
                if (count == 16) break;
            }

            if (currentPosition == 3) {
                PORTB = 0b00001000;
                delay_ms(delayTime);
                currentPosition ++;
                count++;
                if (count == 16) break;
            }

            if (currentPosition == 4) {
                PORTB = 0b00010000;
                delay_ms(delayTime);
                currentPosition ++;
                count++;
                if (count == 16) break;
            }

            if (currentPosition == 5) {
                PORTB = 0b00100000;
                delay_ms(delayTime);
                currentPosition ++;
                count++;
                if (count == 16) break;

            }

            if (currentPosition == 6) {
                PORTB = 0b01000000;
                delay_ms(delayTime);
                currentPosition ++;
                count++;
                if (count == 16) break;
            }

            if (currentPosition == 7) {
                PORTB = 0b10000000;
                delay_ms(delayTime);
                currentPosition = 0;
                count++;
                if (count == 16) break;
            }



    }

    PORTB = 0x00;
}


void question_03(char outputPortSelect, char inputPortSelect){
    unsigned int temp;
    count = 0;
    temp = 0;

    while(1){
        switch(inputPortSelect){
         case pinA:
            DDRA = 0x00;
            temp = PINA;
            break;

         case pinB:
            DDRB = 0x00;
            temp = PINB;
            break;

         case pinC:
            DDRC = 0x00;
            temp = PINC;
            break;

         case pinD:
            DDRD = 0x00;
            temp = PIND;
            break;

         default:
            DDRA = 0x00;
            temp = PINA;
            break;
     }


        switch(outputPortSelect){
         case portA:
            DDRA = 0xFF;
            PORTA = temp;
            break;

         case portB:
            DDRB = 0xFF;
            PORTB = temp;
            break;

         case portC:
            DDRC = 0xFF;
            PORTC = temp;
            break;

         case portD:
            DDRD = 0xFF;
            PORTD = temp;
            break;

         default:
            DDRB = 0xFF;
            PORTB = temp;
            break;
     }

   // count ++;
  //  if (count == 50) break;

    }
}

void question_04(int direction, int sevenSegOn){
    DDRD = 0x0F;
    DDRC = 0xFF;

    switch(sevenSegOn){
        case allSevenSegOn:
            PORTD = 0x00;
            break;
        case firstSevenSegOn:
            PORTD = 0b00001110;
            break;
        case secondSevenSegOn:
            PORTD = 0b00001101;
            break;
        case thirdSevenSegOn:
            PORTD = 0b00001011;
            break;
        case fourthSevenSegOn:
            PORTD = 0b00000111;
            break;
        default:
            PORTD = 0x00;
            break;
    }


    if (direction == decrease){
        for (count = 9; count >= 0; count--){
         PORTC = sevenSeg[count];
         delay_ms(500);
        }
    }
    if (direction == increase){
        for (count = 0; count <= 9; count++){
         PORTC = sevenSeg[count];
         delay_ms(500);
        }
    }

}



void question_05(int amountOfReduction) {
     int temp;
     unsigned int firstSevenSeg;
     unsigned int secondSevenSeg;
     unsigned int thirdSevenSeg;
     unsigned int fourthSevenSeg;

     if (amountOfReduction != 1 && amountOfReduction != 2 && amountOfReduction != 5){ //error handling
        amountOfReduction = 5;
     }

     DDRA = 0x00;
     DDRD = 0x0F;
     DDRC = 0xFF;
     count = 0;
     temp = 0;

     fourthSevenSeg = 0;
     thirdSevenSeg = PINA%10;
     temp = PINA/10;
     secondSevenSeg = temp%10;
     temp = temp/10;
     firstSevenSeg = temp%10;

     while(1) {

         PORTC = sevenSeg[fourthSevenSeg];
         delay_ms(4);
         PORTD = 0x08;
         PORTC = sevenSeg[thirdSevenSeg]+0x80 ;
         delay_ms(4);
         PORTD = 0x04;
         PORTC = sevenSeg[secondSevenSeg];
         delay_ms(4);
         PORTD = 0x02;
         PORTC = sevenSeg[firstSevenSeg];
         delay_ms(4);
         PORTD = 0x01;

         count += 1;
         if (count == 15) {
            if (fourthSevenSeg == 0){
                 fourthSevenSeg = 10;
                 if (thirdSevenSeg == 0){
                    thirdSevenSeg = 9;
                    if (secondSevenSeg == 0){
                        secondSevenSeg = 9;
                        if (firstSevenSeg != 0) firstSevenSeg --;
                    }
                    else secondSevenSeg --;
                 }
                 else thirdSevenSeg --;
            }

            fourthSevenSeg -= amountOfReduction;
            count = 0;
         }

         if (fourthSevenSeg == 0 && thirdSevenSeg == 0 && secondSevenSeg == 0&& firstSevenSeg == 0) break;
     }
}
