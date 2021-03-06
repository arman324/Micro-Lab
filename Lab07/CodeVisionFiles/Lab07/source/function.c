#include <define.h>


void ioInit(){
    // Port C initialization
    // Function: Bit7=Out Bit6=Out Bit5=Out Bit4=Out Bit3=Out Bit2=Out Bit1=Out Bit0=Out
    DDRC=(1<<DDC7) | (1<<DDC6) | (1<<DDC5) | (1<<DDC4) | (1<<DDC3) | (1<<DDC2) | (1<<DDC1) | (1<<DDC0);
    // State: Bit7=0 Bit6=0 Bit5=0 Bit4=0 Bit3=0 Bit2=0 Bit1=0 Bit0=0
    PORTC=(0<<PORTC7) | (0<<PORTC6) | (0<<PORTC5) | (0<<PORTC4) | (0<<PORTC3) | (0<<PORTC2) | (0<<PORTC1) | (0<<PORTC0);

    // Port D initialization
    // Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=Out
    DDRD=(0<<DDD7) | (0<<DDD6) | (0<<DDD5) | (0<<DDD4) | (0<<DDD3) | (0<<DDD2) | (0<<DDD1) | (1<<DDD0);

}


void UART_INIT(char* RX_mode, char* TX_mode,long baudrate){   /////////////// QUESTION_01 ////////////////
    calculate_UBBR = ((8 * 1000000) / (16 * baudrate))-1;
    calculate_UBBR_int = (int)calculate_UBBR;

    if (strcmp(RX_mode, "OFF") == 0 && strcmp(TX_mode, "OFF") == 0){
        lcd_clear();
        lcd_gotoxy(0,0);
        lcd_puts("USART disabled");

        // USART disabled
        UCSRB=(0<<RXCIE) | (0<<TXCIE) | (0<<UDRIE) | (0<<RXEN) | (0<<TXEN) | (0<<UCSZ2) | (0<<RXB8) | (0<<TXB8);
    }
    else if (strcmp(RX_mode, "enable_nonInterrupt") == 0 && strcmp(TX_mode, "enable_nonInterrupt") == 0){
        lcd_clear();
        lcd_gotoxy(0,0);
        lcd_puts("enter 11 character");
        UCSRA=(0<<RXC) | (0<<TXC) | (0<<UDRE) | (0<<FE) | (0<<DOR) | (0<<UPE) | (0<<U2X) | (0<<MPCM);
        UCSRB=(0<<RXCIE) | (0<<TXCIE) | (0<<UDRIE) | (1<<RXEN) | (1<<TXEN) | (0<<UCSZ2) | (0<<RXB8) | (0<<TXB8);
        UCSRC=(1<<URSEL) | (0<<UMSEL) | (0<<UPM1) | (0<<UPM0) | (0<<USBS) | (1<<UCSZ1) | (1<<UCSZ0) | (0<<UCPOL);
        if (calculate_UBBR_int < 0xFF){
                UBRRL = calculate_UBBR_int;
        }
        else {
                UBRRL = calculate_UBBR_int % 0xFF;
                UBRRH = calculate_UBBR_int / 0xFF;
        }
    }
    else if (strcmp(RX_mode, "enable_interrupt") == 0 && strcmp(TX_mode, "enable_nonInterrupt") == 0){
        UCSRA=(0<<RXC) | (0<<TXC) | (0<<UDRE) | (0<<FE) | (0<<DOR) | (0<<UPE) | (0<<U2X) | (0<<MPCM);
        UCSRB=(1<<RXCIE) | (0<<TXCIE) | (0<<UDRIE) | (1<<RXEN) | (1<<TXEN) | (0<<UCSZ2) | (0<<RXB8) | (0<<TXB8);
        UCSRC=(1<<URSEL) | (0<<UMSEL) | (0<<UPM1) | (0<<UPM0) | (0<<USBS) | (1<<UCSZ1) | (1<<UCSZ0) | (0<<UCPOL);
        if (calculate_UBBR_int < 0xFF){
                UBRRL = calculate_UBBR_int;
        }
        else {
                UBRRL = calculate_UBBR_int % 0xFF;
                UBRRH = calculate_UBBR_int / 0xFF;
        }
            #asm("sei")
    }
    else if (strcmp(RX_mode, "enable_interrupt") == 0 && strcmp(TX_mode, "enable_interrupt") == 0){
        UCSRA=(0<<RXC) | (0<<TXC) | (0<<UDRE) | (0<<FE) | (0<<DOR) | (0<<UPE) | (0<<U2X) | (0<<MPCM);
        UCSRB=(1<<RXCIE) | (1<<TXCIE) | (0<<UDRIE) | (1<<RXEN) | (1<<TXEN) | (0<<UCSZ2) | (0<<RXB8) | (0<<TXB8);
        UCSRC=(1<<URSEL) | (0<<UMSEL) | (0<<UPM1) | (0<<UPM0) | (0<<USBS) | (1<<UCSZ1) | (1<<UCSZ0) | (0<<UCPOL);
         if (calculate_UBBR_int < 0xFF){
                UBRRL = calculate_UBBR_int;
        }
        else {
                UBRRL = calculate_UBBR_int % 0xFF;
                UBRRH = calculate_UBBR_int / 0xFF;
        }
            #asm("sei")
    }
    else {
        // RX_mode = enable_nonInterrupt
        // TX_mode = enable_nonInterrupt
        lcd_clear();
        lcd_gotoxy(0,0);
        lcd_puts("Wrong configuration");

    }

}



void question_02(){

    //first argument can be: OFF, enable_nonInterrupt, enable_interrupt
    //second argument can be: OFF, enable_nonInterrupt, enable_interrupt
    //third argument can be between 110 and 115200

    //UART_INIT("OFF", "OFF", 110);
    UART_INIT("enable_nonInterrupt", "enable_nonInterrupt", 9600);
    //UART_INIT("enable_interrupt", "enable_nonInterrupt", 9600);
    //UART_INIT("enable_interrupt", "enable_interrupt", 9600);

    puts("\r\nPart 2 is running\r\n");

    gets(myName,11);
    printf("\r\n");
    sprintf(myNameWithParenthesis,"(%s)",myName);
    puts(myNameWithParenthesis);

}

void question_03(){

    //first argument can be: OFF, enable_nonInterrupt, enable_interrupt
    //second argument can be: OFF, enable_nonInterrupt, enable_interrupt
    //third argument can be between 110 and 115200

    //UART_INIT("OFF", "OFF", 110);
    //UART_INIT("enable_nonInterrupt", "enable_nonInterrupt", 9600);
    UART_INIT("enable_interrupt", "enable_nonInterrupt", 9600);
    //UART_INIT("enable_interrupt", "enable_interrupt", 9600);

        puts("\r\nPart 3 is running\r\n");


    myData = getchar3();

    if (myData == '0'){
        lcd_clear();
        puts("\r\nData is an integer and 10 * data = 0\r\n");
    }
    else if (myData > '0' && myData<= '9'){
        lcd_clear();
        puts("\r\nData is an integer and 10 * data = ");
        putchar(myData);
        puts("0\r\n");
    }
    else if (myData == 'D'){
        puts("\r\n");
        lcd_clear();
        lcd_gotoxy(0,0);
        lcd_puts("lcd delete");
    }
    else if (myData == 'H'){
        lcd_clear();
        puts("\r\nHi, my name is Arman, welcome to Lab07\r\n");
    }
    else{
        lcd_clear();
        puts("\r\nNo function defined\r\n");
    }
}

void question_04(){

    //first argument can be: OFF, enable_nonInterrupt, enable_interrupt
    //second argument can be: OFF, enable_nonInterrupt, enable_interrupt
    //third argument can be between 110 and 115200

    //UART_INIT("OFF", "OFF", 110);
    //UART_INIT("enable_nonInterrupt", "enable_nonInterrupt", 9600);
    //UART_INIT("enable_interrupt", "enable_nonInterrupt", 9600);
    UART_INIT("enable_interrupt", "enable_interrupt", 9600);


        puts("\r\nPart 4 is running\r\n");


        counter = 0;
        for (i = 0; i < countNumber+1; i++)
            temp[i] = ' ';
        while (1){
            check = getchar3();
            temp[counter] = check;
            counter++;
            if (check == 127 || check == 8) {counter -= 2;};
            if (check == ')')
            {
                countNumber = counter;
                break;
            }
        }
          //sprintf(temp,"%d",countNumber);
            temp2 = strtok(temp," ");
            if (countNumber < 7){
                lcd_clear();
                puts("\r\nThe length of the frame is not correct.\r\n");
            }
            else if (strcmp(temp2,"(12345)") == 0)
            {
                puts("\r\nFrame is correct.\r\n");

                lcd_clear();
                lcd_gotoxy(0,0);
                lcd_puts("12345");
            }
            else {
                lcd_clear();
                puts("\r\nFrame must be 5 integers.\r\n");

            }

}