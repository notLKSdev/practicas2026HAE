#line 1 "C:/Users/looko/Desktop/trabajos uni/HAE/practicas2026HAE/p9/p9horno/p9horno.c"
const int ALPHA_TMR = 28036;

void interrupt(){



 if(INTCON.TMR0IF == 1){


 INTCON.TMR0IF = 0;
 }

}

void main(){

 T0CON = 0x81;


 TMR0L = ALPHA_TMR;
 TMR0H = (ALPHA_TMR >> 8);


 INTCON.TMR0IF = 0;
 INTCON.TMR0IE = 1;


 INTCON.GIE = 1;

 while(1){

 }
}
