
_interrupt:

;p9horno.c,3 :: 		void interrupt(){
;p9horno.c,7 :: 		if(INTCON.TMR0IF == 1){
	BTFSS       INTCON+0, 2 
	GOTO        L_interrupt0
;p9horno.c,10 :: 		INTCON.TMR0IF = 0;
	BCF         INTCON+0, 2 
;p9horno.c,11 :: 		}
L_interrupt0:
;p9horno.c,13 :: 		}
L_end_interrupt:
L__interrupt4:
	RETFIE      1
; end of _interrupt

_main:

;p9horno.c,15 :: 		void main(){
;p9horno.c,17 :: 		T0CON = 0x81;
	MOVLW       129
	MOVWF       T0CON+0 
;p9horno.c,20 :: 		TMR0L = ALPHA_TMR;
	MOVLW       132
	MOVWF       TMR0L+0 
;p9horno.c,21 :: 		TMR0H = (ALPHA_TMR >> 8);
	MOVLW       109
	MOVWF       TMR0H+0 
;p9horno.c,24 :: 		INTCON.TMR0IF = 0;
	BCF         INTCON+0, 2 
;p9horno.c,25 :: 		INTCON.TMR0IE = 1;
	BSF         INTCON+0, 5 
;p9horno.c,28 :: 		INTCON.GIE = 1;
	BSF         INTCON+0, 7 
;p9horno.c,30 :: 		while(1){
L_main1:
;p9horno.c,32 :: 		}
	GOTO        L_main1
;p9horno.c,33 :: 		}
L_end_main:
	GOTO        $+0
; end of _main
