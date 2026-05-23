/**
 * Definicion del circuito:
 * - Boton conectado a RB1
 * - Led conectado en RE0
 * - Sensor de presion conectado a RA5
 * - LCD en los puertos RC
 * 
 * Una vez se pulse el boton, se enciende el led conectado a RE0 durante 4 segundos.
 * Cuando se apague el led y tan pronto como sea posible se representa en el LCD la presión que
 * recibe del sensor.
 * Si se pulsa el boton antes de mostrar la presion en el LCD no debe tener ningun efecto.
 * 
 * v0 = 0.01 * P + 0.5
 * Fosc = 8MHz
 * FAD = 625 * 10^3 H
 */

unsigned int v0 = 0;

void interrupt(){

    // Pulsamos el boton
    if(INTCON3.INT1IF = 1){

        // Encendemos el led
        PORTE.B0 = 1;

        // Desactivar boton
        INTCON3.INT1IE = 0;

        // Activamos timer0 para contabilizar 4 segundos
        T0CON.TMR0ON = 1;
        TMR0H = (3036 >> 8);
        TMR0L = 3036;

        // Borrar flag de interrupcion
        INTCON3.INT1IF = 0;
    }

    // Terminan los 4 segundos
    if(INTCON.TMR0IF = 1){

        // Desactivar timer0
        T0CON.TMR0ON = 0;

        // Apagar el led
        PORTE.B0 = 0;

        // Iniciar medicion del sensor
        ADCON0.GO = 1;

        // Borrar flag de interrupcion
        INTCON.TMR0IF = 0;
    }

    // Se realiza medicion
    if(PIR1.ADIF = 1){





    }


}

void main(){

    // Configurar entradas
    TRISB.B1 = 1;
    TRISA.B4 = 1;

    // Configurar salida
    TRISE.B0 = 0;

    // Configurar timer0
    T0CON = 0x06;
    INTCON.TMR0IF = 0;
    INTCON.TMR0IE = 1;

    // Configurar AD
    ADCON0 = 0x61;
    ADCON1 = 0xC2;
    PIR1.ADIF = 0;
    PIE1.ADIE = 1;

    // Interrupcion boton (INT1)
    INTCON2.INTEDG1 = 1;
    INTCON3.INT1IF = 0;
    INTCON3.INT1IE = 1;

    // Habilitar interrupciones perifericas
    INTCON.PEIE = 1;

    // Habilitar interrupciones globales
    INTCON.GIE = 1;

    while(1){
        
    }
}