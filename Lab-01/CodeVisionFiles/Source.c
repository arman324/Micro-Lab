/*
 * Source.c
 *
 * Created: 9/30/2020 3:42:41 PM
 * Author: Arman Riasi
 */

#include <io.h>
#include <delay.h>

void question_01();
void question_02();
void question_03();
void question_04();
void question_05();
void question_06();


int count = 0;
int temp = 0;
unsigned int firstSevenSeg = 0;
unsigned int secondSevenSeg = 0;
unsigned int thirdSevenSeg = 0;
unsigned int fourthSevenSeg = 0;
unsigned int sevenSeg[] = {
    0b00111111, //showing number 0 on 7_seg
    0b00000110, //showing number 1 on 7_seg
    0b01011011, //showing number 2 on 7_seg
    0b01001111, //showing number 3 on 7_seg
    0b01100110, //showing number 4 on 7_seg
    0b01101101, //showing number 5 on 7_seg
    0b01111101, //showing number 6 on 7_seg
    0b00000111, //showing number 7 on 7_seg
    0b01111111, //showing number 8 on 7_seg
    0b01101111, //showing number 9 on 7_seg
};


void main(void)
{
    //question_01(); //calling question one
    //question_02(); //calling question two
    //question_03(); //calling question three
    //question_04(); //calling question four
    //question_05(); //calling question five
    //question_06(); //calling question six

    //////////question seven:
    question_01();
    question_02();
    question_04();
    while(1){
        question_03();
        question_05();
        question_06();
    }

}


void question_01(){
    DDRB = 0xFF;
    count = 0;
    while(count <4){
    PORTB = 0xFF;
    delay_ms(500); //calling 500ms delay == 0.5 second
    PORTB = 0x00;
    delay_ms(500); //calling 500ms delay == 0.5 second
    count++;
    }

}

void question_02(){
    DDRB = 0xFF;
    count = 0;
    while(count <2){    //Changing the point of light each 0.5 second, Then after 8 seconds it will stop
    PORTB.7 = 0;
    PORTB.0 = 1;
    delay_ms(500);
    PORTB.0 = 0;
    PORTB.1 = 1;
    delay_ms(500);
    PORTB.1 = 0;
    PORTB.2 = 1;
    delay_ms(500);
    PORTB.2 = 0;
    PORTB.3 = 1;
    delay_ms(500);
    PORTB.3 = 0;
    PORTB.4 = 1;
    delay_ms(500);
    PORTB.4 = 0;
    PORTB.5 = 1;
    delay_ms(500);
    PORTB.5 = 0;
    PORTB.6 = 1;
    delay_ms(500);
    PORTB.6 = 0;
    PORTB.7 = 1;
    delay_ms(500);
    count++;
    }

    PORTB.7 = 0;

}


void question_03(){

    count = 0;
    while(1){
     DDRA = 0x00;
     DDRB = 0xFF;

    PORTB.0 = PINA.0;
    PORTB.1 = PINA.1;
    PORTB.2 = PINA.2;
    PORTB.3 = PINA.3;
    PORTB.4 = PINA.4;
    PORTB.5 = PINA.5;
    PORTB.6 = PINA.6;
    PORTB.7 = PINA.7;

    count ++;

    if (count == 50) break;
    }

}

void question_04(){
    DDRD = 0x0F;
    DDRC = 0xFF;


    PORTD = 0x00;


    for (count = 9; count >= 0; count--){
     PORTC = sevenSeg[count];
     delay_ms(1000);
    }


}

void question_05() {
     DDRA = 0x00;
     temp = 0;
     DDRD = 0x0F;
     DDRC = 0xFF;
     count = 0;


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
         if (count == 10) {
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
            fourthSevenSeg -= 2;
            count = 0;
         }

         if (fourthSevenSeg == 0 && thirdSevenSeg == 0 && secondSevenSeg == 0&& firstSevenSeg == 0) break;
     }
}


void question_06() {
     DDRA = 0x00;
     temp = 0;
     DDRD = 0x0F;
     DDRC = 0xFF;
     count = 0;

     fourthSevenSeg = 0;
     thirdSevenSeg = PINA%10;
     temp = PINA/10;
     secondSevenSeg = temp%10;
     temp = temp/10;
     firstSevenSeg = temp%10;

     while(1) {

         if (PIND.4 == 0) {
             firstSevenSeg = 0;
         }
         if (PIND.5 == 0) {
             secondSevenSeg = 0;
         }
         if (PIND.6 == 0) {
             thirdSevenSeg = 0;
         }
         if (PIND.7 == 0) {
             fourthSevenSeg = 0;
         }


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
         if (count == 10) {
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
            fourthSevenSeg -= 2;
            count = 0;
         }

         if (fourthSevenSeg == 0 && thirdSevenSeg == 0 && secondSevenSeg == 0&& firstSevenSeg == 0) break;
     }
}
