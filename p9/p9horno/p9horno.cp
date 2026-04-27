#line 1 "C:/Users/Lookos/Desktop/Trabajos Uni/practicas2026HAE/p9/p9horno/p9horno.c"
#line 1 "c:/users/lookos/documents/mikroelektronika/mikroc pro for pic/include/stdbool.h"



 typedef char _Bool;
#line 3 "C:/Users/Lookos/Desktop/Trabajos Uni/practicas2026HAE/p9/p9horno/p9horno.c"
const int ALPHA_TMR = 28036;
const float LAMBDA_AD = 0.0048875;
const float ALPHA_TEMP = 1.955;

int enable = 0;
int heater = 0;
int t = 0;
int tMax = 0;
int tMin = 0;

int Q = 0;
 _Bool  readController = 0;

void goControllerAD(){
 ADCON0 = 0x44;
 ADCON1 = 0xC4;
 readController =  1 ;
 ADCON0.GO = 1;
}

void goTermometherAD(){
 ADCON0 = 0x41;
 ADCON1 = 0xCE;
 readController =  0 ;
 ADCON0.GO = 1;
}

void interrupt(){

 if(PIR1.ADIF == 1){

 if(readController ==  1 ){
 tMax = (ADRESH << 8) + ADRESL;
 tMax *= 50;
 tMin = tMax - 2 * ALPHA_TEMP;

 }else{
 t = (ADRESH << 8) + ADRESL;
 t *= 50;
 }

 PIR1.ADIF = 0;
 }


 if(INTCON.TMR0IF == 1){

 enable = PORTA.B4;


 goControllerAD();


 goTermometherAD();

 if(Q == 0){
 heater = 0;
 if(enable == 0){
 Q = 0;
 }else{
 Q = 1;
 }

 }else if(Q == 1){
 if(enable == 1){
 heater = 1;
 if(t<tMax){
 Q = 1;
 }else{
 Q = 2;
 }
 }else{
 Q = 0;
 }

 }else{
 if(enable == 1){
 heater = 0;
 if(t > tMin){
 Q = 2;
 }else{
 Q = 1;
 }
 }else{
 Q = 0;
 }

 }


 INTCON.TMR0IF = 0;
 }

}

void main(){

 TRISA.B4 = 1;
 TRISA.B0 = 1;
 TRISA.B1 = 1;
 TRISA.B2 = 0;


 ADCON0 = 0x44;
 ADCON1 = 0xC4;


 PIR1.ADIF = 0;
 PIE1.ADIE = 1;


 T0CON = 0x81;


 TMR0L = ALPHA_TMR;
 TMR0H = (ALPHA_TMR >> 8);


 INTCON.TMR0IF = 0;
 INTCON.TMR0IE = 1;


 INTCON.GIE = 1;

 while(1){

 }
}
