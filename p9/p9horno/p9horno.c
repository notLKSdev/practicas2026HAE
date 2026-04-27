#include <stdbool.h>

const int ALPHA_TMR = 28036;
const float LAMBDA_AD = 0.0048875;

int enable = 0; // Enable
int heater = 0; // Activar calentador
int t = 0; // Temperatura
int tMax = 0; // Temperatura maxima
int tMin = 0; // Temperatura minima

int Q = 0; // Variable de estado
bool readController = 0; // Variable auxiliar lectura AD

int temperatureToVoltage(int voltage){
    return voltage * 50;
}

void goControllerAD(){
    ADCON0 = 0x44;
    ADCON1 = 0xC4;
    readController = true;
    ADCON0.GO = 1;
}

void goTermometherAD(){
    ADCON0 = 0x41;
    ADCON1 = 0xCE;
    readController = false;
    ADCON0.GO = 1;
}

void interrupt(){

    if(PIR1.ADIF == 1){

        if(readController == true){
            tMax = (ADRESH << 8) + ADRESL;
        }else{
            t = (ADRESH << 8) + ADRESL;
        }

        PIR1.ADIF = 0;
    }


    if(INTCON.TMR0IF == 1){
        // Comprobar encendido
        enable = PORTA.B4;

        // Leer termperatura
        goControllerAD();


        if(Q == 0){ // Horno apagado
            heater = 0;
            if(enable == 0){
                Q = 0;
            }else{
                Q = 1;
            }

        }else if(Q == 1){ // Temperatura menor o tMax
            heater = 1;
            if(t<tMax){

            }else{
                Q = 2;
            }

        }else{ // Temperatura mayor a tMin

        }

        INTCON.TMR0IF = 0;
    }

}

void main(){
    // Configurar entrada/salida
    TRISA.B4 = 1; // Boton encendido
    TRISA.B0 = 1; // Voltaje medio termometro
    TRISA.B1 = 1; // Voltaje mando

    // Configurar AD para comenzar midiendo el mando (El horno comienza apagado)
    ADCON0 = 0x44;
    ADCON1 = 0xC4;

    // Habilitar interrupciones AD
    PIR1.ADIF = 0;
    PIE1.ADIE = 1;

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