/*
 * Cuando se pulsa el boton RB0 se enciende el led conectado a RE1 durante 3 segundos.
 * Pulsar RB0 mientras el led esta encendido no debe hacer efecto.
 * 
 * Al pulsar el boton RB1 se toma una muestra de un sensor de humedad de RE0 y se
 * representa en el LCD.
 * Pulsar el botón antes de que se envie al LCD no debe hacer efecto.
 * 
 * Formula para calcular la humedad a partir del voltaje: v0 = 1 + HR/25
 * Frecuencia oscilacion del micro: Fosc = 16 MHz
 * Frecuencia del convertidor AD: FAD = 625 * 10^3 H
 */

// LCD pinout settings
sbit LCD_RS at RD2_bit;
sbit LCD_EN at PORTD.B3;
sbit LCD_D7 at RD7_bit;
sbit LCD_D6 at RD6_bit;
sbit LCD_D5 at RD5_bit;
sbit LCD_D4 at RD4_bit;

// Pin direction
sbit LCD_RS_Direction at TRISD2_bit;
sbit LCD_EN_Direction at TRISD.B3;
sbit LCD_D7_Direction at TRISD7_bit;
sbit LCD_D6_Direction at TRISD6_bit;
sbit LCD_D5_Direction at TRISD5_bit;
sbit LCD_D4_Direction at TRISD4_bit;

char txt[15];
unsigned int v0 = 0;
float aux = 0.0;

void interrupt(){

    // Si pulsamos el boton 0
    if(INTCON.INT0IF == 1){
        
        // Solo funciona si la temporizacion no esta activa
        if(INTCON.INT0IE == 1){
            
            // Deshabilitar boton
            INTCON.INT0IE = 0;
            
            // Encender LED y activar timer de 3 se
            PORTE.B1 = 1;
            T0CON.TMR0ON = 1;
            TMR0H = (18661 >> 8);
            TMR0L = 18661;
        }

        INTCON.INT0IF = 0;
    }

    // Una vez pasen los 3 segundos
    if(INTCON.TMR0IF == 1){
        PORTE.B1 = 0;

        T0CON.TMR0ON = 0;
        INTCON.INT0IE = 1;
        INTCON.TMR0IF = 0;
    }

    // Si pulsamos el boton 1
    if(INTCON3.INT1IF == 1){

        if(INTCON3.INT1IE == 1){
            INTCON3.INT1IE = 0;
            ADCON0.GO = 1;
        }

        INTCON3.INT1IF = 0;
    }

    // Se realiza la medicion del AD tras pulsar el boton 1
    if(PIR1.ADIF == 1){

        // Leer y calcular la humedad
        v0 = ADRESL + (ADRESH << 8);
        aux = 25 * ((v0 * 0.00488758) - 1);

        // Escribirla en el Lcd
        FloatToStr(aux,txt);
        Lcd_Cmd(_Lcd_Clear);
        Lcd_Out(1,1,txt);
        
        INTCON3.INT1IE = 1;
        PIR1.ADIF = 0;
    }


}

void main(){
    Lcd_init();

    // Configurar entradas
    TRISB.B0 = 1;
    TRISB.B1 = 1;

    // Configurar salida
    TRISE.B1 = 0;
    TRISE.B0 = 0;

    // Configurar timer0
    T0CON = 0x07;

    // Configurar AD
    ADCON0 = 0xA9;
    ADCON1 = 0x89;

    // Cargar valor alfa
    TMR0H = (18661 >> 8);
    TMR0L = 18661;

    // Habilitar interrupciones del AD
    PIR1.ADIF = 0;
    PIE1.ADIE = 1;

    // Habilitar interrupciones del timer0
    INTCON.TMR0IF = 0;
    INTCON.TMR0IE = 1;

    // Configuracion INT0 (boton LED)
    INTCON2.INTEDG0 = 1;
    INTCON.INT0IF = 0;
    INTCON.INT0IE = 1;

    // Configuracion INT1 (sensor humedad)
    INTCON2.INTEDG1 = 1;
    INTCON3.INT1IF = 0;
    INTCON3.INT1IE = 1;

    // Habilitar interrupciones globales
    INTCON.GIE = 1;

    while(1){

    }
}