const int ALPHA_TMR = 28036;

void interrupt(){



    if(INTCON.TMR0IF == 1){


        INTCON.TMR0IF = 0;
    }

}

void main(){
    // Configurar timer
    T0CON = 0x81;

    // Cargar valor alfa del timer
    TMR0L = ALPHA_TMR;
    TMR0H = (ALPHA_TMR >> 8);

    // Habilitar interrupciones timer
    INTCON.TMR0IF = 0;
    INTCON.TMR0IE = 1;

    // Habilitar interrupciones en general
    INTCON.GIE = 1;

    while(1){

    }
}