unsigned short q = 0; // Estado
unsigned short t = 0; // Temporizacion de 4 segundos

void interrupt(){
    if(INTCON.TMR0IF == 1){
        switch(q){
            case 0:
                PORTB.B0 = 0; // i
                PORTA.B3 = 0; // d

                if(PORTA.B0 == 1){
                    q = 1;
                }
                break;
            case 1:
                PORTB.B0 = 1; // i
                PORTA.B3 = 0; // d

                if(PORTB.B6 == 1){
                    q = 2;
                    t = 0;
                }
                break;
            case 2:
                PORTB.B0 = 0; // i
                PORTA.B3 = 0; // d

                if(t < 40){
                    t++;
                }else{
                    t = 0;
                    q = 3;
                }
                break;
            case 3:
                PORTB.B0 = 0; // i
                PORTA.B3 = 1; // d

                if(PORTB.B4 == 1){
                    q = 0;
                }
                break;
        }

        INTCON.TMR0IF = 0;
    }

}

void main(){
    // Configuracion entrada
    TRISA.B0 = 1; // m
    TRISB.B4 = 1; // a
    TRISB.B6 = 1; // b

    // Configuracion salida
    TRISA.B3 = 0; // d
    TRISB.B0 = 0; // i

    // Configuracion de timer0
    T0CON = 0xC1;

    // Cargar alfa en timer0
    TMR0H = (15536 << 8);
    TMR0L = 15536;

    // Habilitacion de interrupciones del timer0
    INTCON.TMR0IF = 0;
    INTCON.TMR0IE = 1;

    // Habilitar interrupciones globales
    INTCON.GIE = 1;

    while(1){

    }
}