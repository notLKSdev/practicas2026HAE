/**
 * Este ejercicio corresponde al ejercicio 8 del boletin 3 (el que es de un sensor SRF04),
 * hay que usar la opción 2 para no tener que utilizar la técnica de polling.
 *
 * ATENCION: NO LO HE PROBADO, solo lo he pensado asi y ni siquiera estoy seguro de que este bien
 */

// LCD pinout settings
sbit LCD_RS at RD2_bit;
sbit LCD_EN at PORTD.B3;
sbit LCD_D7 at RD7_bit;
sbit LCD_D6 at RD6_bit;
sbit LCD_D5 at RD5_bit;
sbit LCD_D4 at RD4_bit;

// LCD directions
sbit LCD_RS_Direction at TRISD2_bit;
sbit LCD_EN_Direction at TRISD.B3;
sbit LCD_D7_Direction at TRISD7_bit;
sbit LCD_D6_Direction at TRISD6_bit;
sbit LCD_D5_Direction at TRISD5_bit;
sbit LCD_D4_Direction at TRISD4_bit;

volatile unsigned int tiempoEcho = 0;

float distancia = 0;

char aux[15];

void interrupt(){

    // Se pulsa el boton
    if(INTCON.INT0IF == 1){
        
        // Trigger ON
        PORTA.B3 = 1;

        // Activar timer0
        T0CON = 0xC8;
        TMR0H = (232 >> 8);
        TMR0L = 232;

        INTCON.INT0IF = 0;
    }

    // Terminan los 12 microsegundos del trigger
    if(INTCON.TMR0IF == 1){
        T0CON.TMR0ON = 0;

        // Trigger OFF
        PORTA.B3 = 0;

        // Timer0 en modo medicion de echo
        T0CON = 0x08;
        TMR0H = 0;
        TMR0L = 0;

        // Habilitar INT2 como flanco de subida
        INTCON.INTEDG2 = 1;
        INTCON3.INT2IF = 0;
        INTCON3.INT2IE = 1;

        INTCON.TMR0IF = 0;
    }

    // Medimos el tiempo de echo
    if(INTCON3.INT2IF == 1){

        // Flanco de subida arrancar el timer
        if(INTCON2.INTEDG2 == 1){
            T0CON.TMR0ON = 1;
            TMR0H = 0;
            TMR0L = 0;

            // Cambiar a flanco de bajada
            INTCON2.INTEDG2 == 0;
        
        // Flanco de bajada medir el timer
        }else{

            // Leer el timer0
            unsigned char low = TMR0L;
            unsigned char high = TMR0H;

            // Apagar el timer0
            T0CON.TMR0ON = 0;

            unsigned int alfaEcho = ((unsigned int) high << 8) | low;

            // Convertir medicion del timer a segundos
            tiempoEcho = (unsigned long)(65536UL - alfaEcho) * 128UL;

            // Calcular distancia mediante la formula
            distancia = (1000000 * tiempoEcho)/(0,000058);

            // Mostrarla por el LCD
            Lcd_Cmd(_Lcd_Clear);
            FloatToStr(distancia,txt);
            Lcd_Out(1,1,txt);
        }


        INTCON3.INT2IF = 0;
    }


}

void main(){

    // Configuracion inicial
    Lcd_Init();
    ADCON1 = 0x07;
    
    // Salidas
    TRISA.B3 = 0;

    // Entradas
    TRISB.B0 = 1;
    TRISB.B2 = 1;

    // Configuracion de boton
    INTCON2.INTEDG0 = 1;
    INTCON.INT0IF = 0;
    INTCON.INT0IE = 1;

    // Señal echo deshabilitada inicialmente
    INTCON2.INTEDG2 = 1;
    INTCON3.INT2IF  = 0;
    INTCON3.INT2IE  = 0;

    // Configuracion inicial timer0
    T0CON = 0x48;
    TMR0H = 0;
    TMR0L = 232;
    INTCON.TMR0IF = 0;
    INTCON.TMR0IE = 1;

    // Interrupciones globales y perifericas
    INTCON.GIE  = 1;
    INTCON.PEIE = 1;

    while(1){

    }
}
