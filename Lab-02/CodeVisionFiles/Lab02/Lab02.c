/*
 * Lab02.c
 *
 * Created: 10/4/2020 3:23:32 PM
 * Author: Arman Riasi
 */


#include <define.h>
int count;
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
    //question_01(12,portB,250);
    //question_02(400, position2);
    //question_03(portB,pinA);
    //question_04(decrease, thirdSevenSegOn);
    question_05(5); //choose only number 1 or number 2 or number 5, another input numbers will alter to 5
}

