const int ALPHA_TMR = 28036;
const float LAMBDA_AD = 0.0048875;

int e = 0; // Enable
int c = 0; // Activar calentador
int t = 0; // Temperatura
int tMax = 0; // Temperatura maxima
int tMin = 0; // Temperatura minima

int Q = 0; // Variable de estado

void configController(){
    ADCON0 = 0x44;
    ADCON1 = 0xC4;
}

void configTermomether(){
    ADCON0 = 0x41;
    ADCON1 = 0xCE;
}

void interrupt(){


    if(PIR1.ADIF == 1){


        PIR1.ADIF = 0;
    }


    if(INTCON.TMR0IF == 1){
        if(Q == 0){
            c = 0;
            if(e == 0){
                Q = 0;
            }else{
                Q = 1;
            }

        }else if(Q == 1){


        }else{

        }

        INTCON.TMR0IF = 0;
    }

}

void main(){
    // Configurar boton de encendido como entrada
    TRISA.B4 = 1;
    
    // Configurar AD para comenzar midiendo el mando (El horno comienza apagado)
    configController();

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