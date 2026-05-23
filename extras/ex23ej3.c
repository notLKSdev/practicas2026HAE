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

void interrupt(){



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

    // Habilitar interrupciones globales
    INTCON.GIE = 1;

    while(1){
        
    }
}