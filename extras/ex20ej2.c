/**
 * Sensor de humedad conectado a RE1
 * Cada 1.6 segundos se debe medir la humedad
 * 
 * v0 = (H/28.5) + 0.5
 * Fosc = 8 MHz
 * FAD = 625 * 10^3 Hz
 */

unsigned int v0 = 0;

float humedad = 0.0;

char txt[16];

void interrupt(){

    // Cada vez que pasen 1.6 segundos saltara la interrupcion
    if(INTCON.TMR0IF == 1){

        // Parar el timer0
        T0CON.TMR0ON = 0;

        // Realizar medicion AD
        ADCON0.GO = 1;

        // Borrar flag de interrupcion
        INTCON.TMR0IF = 0;
    }

    if(PIR1.ADIF == 1){

        // Obtener medicion del AD
        v0 = (ADRESH << 8) + ADRESL;

        // Calcular humedad
        humedad = 28.5 * ((v0 * 0.00488758) - 0.5);

        // Convertir a texto
        FloatToStr(humedad,txt);

        // Mostrar en el LCD
        Lcd_Cmd(_Lcd_Clear);
        Lcd_Out(1,1,txt);

        // Reactivar el timer0
        T0CON.TMR0ON = 1;
        TMR0H = (15536 >> 8);
        TMR0L = 15536;

        // Borrar flag de interrupcion
        PIR1.ADIF = 0;
    }

}

void maint(){
    Lcd_Init();

    // Configurar entrada
    TRISE.B1 = 1;

    // Configurar AD
    ADCON0 = 0x71;
    ADCON1 = 0xC0;

    // Habilitar interrupciones AD
    PIR1.ADIF = 0;
    PIE1.ADIE = 1;
    INTCON.PEIE = 1;

    // Configurar timer0
    T0CON = 0x85;
    TMR0H = (15536 >> 8);
    TMR0L = 15536;

    // Habilitar interrupciones timer0
    INTCON.TMR0IF = 0;
    INTCON.TMR0IE = 1;

    // Habilitar interrupciones generales
    INTCON.GIE = 1;

    while(1){

    }

}