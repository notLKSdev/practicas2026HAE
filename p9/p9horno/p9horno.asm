
_goControllerAD:

;p9horno.c,16 :: 		void goControllerAD(){
;p9horno.c,17 :: 		ADCON0 = 0x44;
	MOVLW       68
	MOVWF       ADCON0+0 
;p9horno.c,18 :: 		ADCON1 = 0xC4;
	MOVLW       196
	MOVWF       ADCON1+0 
;p9horno.c,19 :: 		readController = true;
	MOVLW       1
	MOVWF       _readController+0 
;p9horno.c,20 :: 		ADCON0.GO = 1;
	BSF         ADCON0+0, 2 
;p9horno.c,21 :: 		}
L_end_goControllerAD:
	RETURN      0
; end of _goControllerAD

_goTermometherAD:

;p9horno.c,23 :: 		void goTermometherAD(){
;p9horno.c,24 :: 		ADCON0 = 0x41;
	MOVLW       65
	MOVWF       ADCON0+0 
;p9horno.c,25 :: 		ADCON1 = 0xCE;
	MOVLW       206
	MOVWF       ADCON1+0 
;p9horno.c,26 :: 		readController = false;
	CLRF        _readController+0 
;p9horno.c,27 :: 		ADCON0.GO = 1;
	BSF         ADCON0+0, 2 
;p9horno.c,28 :: 		}
L_end_goTermometherAD:
	RETURN      0
; end of _goTermometherAD

_interrupt:

;p9horno.c,30 :: 		void interrupt(){
;p9horno.c,32 :: 		if(PIR1.ADIF == 1){
	BTFSS       PIR1+0, 6 
	GOTO        L_interrupt0
;p9horno.c,34 :: 		if(readController == true){
	MOVF        _readController+0, 0 
	XORLW       1
	BTFSS       STATUS+0, 2 
	GOTO        L_interrupt1
;p9horno.c,35 :: 		tMax = (ADRESH << 8) + ADRESL;
	MOVF        ADRESH+0, 0 
	MOVWF       R1 
	CLRF        R0 
	MOVF        ADRESL+0, 0 
	ADDWF       R0, 1 
	MOVLW       0
	ADDWFC      R1, 1 
	MOVF        R0, 0 
	MOVWF       _tMax+0 
	MOVF        R1, 0 
	MOVWF       _tMax+1 
;p9horno.c,36 :: 		tMax *= 50;
	MOVLW       50
	MOVWF       R4 
	MOVLW       0
	MOVWF       R5 
	CALL        _Mul_16X16_U+0, 0
	MOVF        R0, 0 
	MOVWF       _tMax+0 
	MOVF        R1, 0 
	MOVWF       _tMax+1 
;p9horno.c,37 :: 		tMin = tMax - 2 * ALPHA_TEMP;
	CALL        _int2double+0, 0
	MOVLW       113
	MOVWF       R4 
	MOVLW       61
	MOVWF       R5 
	MOVLW       122
	MOVWF       R6 
	MOVLW       128
	MOVWF       R7 
	CALL        _Sub_32x32_FP+0, 0
	CALL        _double2int+0, 0
	MOVF        R0, 0 
	MOVWF       _tMin+0 
	MOVF        R1, 0 
	MOVWF       _tMin+1 
;p9horno.c,39 :: 		}else{
	GOTO        L_interrupt2
L_interrupt1:
;p9horno.c,40 :: 		t = (ADRESH << 8) + ADRESL;
	MOVF        ADRESH+0, 0 
	MOVWF       R1 
	CLRF        R0 
	MOVF        ADRESL+0, 0 
	ADDWF       R0, 1 
	MOVLW       0
	ADDWFC      R1, 1 
	MOVF        R0, 0 
	MOVWF       _t+0 
	MOVF        R1, 0 
	MOVWF       _t+1 
;p9horno.c,41 :: 		t *= 50;
	MOVLW       50
	MOVWF       R4 
	MOVLW       0
	MOVWF       R5 
	CALL        _Mul_16X16_U+0, 0
	MOVF        R0, 0 
	MOVWF       _t+0 
	MOVF        R1, 0 
	MOVWF       _t+1 
;p9horno.c,42 :: 		}
L_interrupt2:
;p9horno.c,44 :: 		PIR1.ADIF = 0;
	BCF         PIR1+0, 6 
;p9horno.c,45 :: 		}
L_interrupt0:
;p9horno.c,48 :: 		if(INTCON.TMR0IF == 1){
	BTFSS       INTCON+0, 2 
	GOTO        L_interrupt3
;p9horno.c,50 :: 		enable = PORTA.B4;
	MOVLW       0
	BTFSC       PORTA+0, 4 
	MOVLW       1
	MOVWF       _enable+0 
	CLRF        _enable+1 
;p9horno.c,53 :: 		goControllerAD();
	CALL        _goControllerAD+0, 0
;p9horno.c,56 :: 		goTermometherAD();
	CALL        _goTermometherAD+0, 0
;p9horno.c,58 :: 		if(Q == 0){ // Horno apagado
	MOVLW       0
	XORWF       _Q+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__interrupt24
	MOVLW       0
	XORWF       _Q+0, 0 
L__interrupt24:
	BTFSS       STATUS+0, 2 
	GOTO        L_interrupt4
;p9horno.c,59 :: 		heater = 0;
	CLRF        _heater+0 
	CLRF        _heater+1 
;p9horno.c,60 :: 		if(enable == 0){
	MOVLW       0
	XORWF       _enable+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__interrupt25
	MOVLW       0
	XORWF       _enable+0, 0 
L__interrupt25:
	BTFSS       STATUS+0, 2 
	GOTO        L_interrupt5
;p9horno.c,61 :: 		Q = 0;
	CLRF        _Q+0 
	CLRF        _Q+1 
;p9horno.c,62 :: 		}else{
	GOTO        L_interrupt6
L_interrupt5:
;p9horno.c,63 :: 		Q = 1;
	MOVLW       1
	MOVWF       _Q+0 
	MOVLW       0
	MOVWF       _Q+1 
;p9horno.c,64 :: 		}
L_interrupt6:
;p9horno.c,66 :: 		}else if(Q == 1){ // Temperatura menor a tMax
	GOTO        L_interrupt7
L_interrupt4:
	MOVLW       0
	XORWF       _Q+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__interrupt26
	MOVLW       1
	XORWF       _Q+0, 0 
L__interrupt26:
	BTFSS       STATUS+0, 2 
	GOTO        L_interrupt8
;p9horno.c,67 :: 		if(enable == 1){
	MOVLW       0
	XORWF       _enable+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__interrupt27
	MOVLW       1
	XORWF       _enable+0, 0 
L__interrupt27:
	BTFSS       STATUS+0, 2 
	GOTO        L_interrupt9
;p9horno.c,68 :: 		heater = 1;
	MOVLW       1
	MOVWF       _heater+0 
	MOVLW       0
	MOVWF       _heater+1 
;p9horno.c,69 :: 		if(t<tMax){
	MOVLW       128
	XORWF       _t+1, 0 
	MOVWF       R0 
	MOVLW       128
	XORWF       _tMax+1, 0 
	SUBWF       R0, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__interrupt28
	MOVF        _tMax+0, 0 
	SUBWF       _t+0, 0 
L__interrupt28:
	BTFSC       STATUS+0, 0 
	GOTO        L_interrupt10
;p9horno.c,70 :: 		Q = 1;
	MOVLW       1
	MOVWF       _Q+0 
	MOVLW       0
	MOVWF       _Q+1 
;p9horno.c,71 :: 		}else{
	GOTO        L_interrupt11
L_interrupt10:
;p9horno.c,72 :: 		Q = 2;
	MOVLW       2
	MOVWF       _Q+0 
	MOVLW       0
	MOVWF       _Q+1 
;p9horno.c,73 :: 		}
L_interrupt11:
;p9horno.c,74 :: 		}else{
	GOTO        L_interrupt12
L_interrupt9:
;p9horno.c,75 :: 		Q = 0;
	CLRF        _Q+0 
	CLRF        _Q+1 
;p9horno.c,76 :: 		}
L_interrupt12:
;p9horno.c,78 :: 		}else{ // Temperatura mayor a tMin
	GOTO        L_interrupt13
L_interrupt8:
;p9horno.c,79 :: 		if(enable == 1){
	MOVLW       0
	XORWF       _enable+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__interrupt29
	MOVLW       1
	XORWF       _enable+0, 0 
L__interrupt29:
	BTFSS       STATUS+0, 2 
	GOTO        L_interrupt14
;p9horno.c,80 :: 		heater = 0;
	CLRF        _heater+0 
	CLRF        _heater+1 
;p9horno.c,81 :: 		if(t > tMin){
	MOVLW       128
	XORWF       _tMin+1, 0 
	MOVWF       R0 
	MOVLW       128
	XORWF       _t+1, 0 
	SUBWF       R0, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__interrupt30
	MOVF        _t+0, 0 
	SUBWF       _tMin+0, 0 
L__interrupt30:
	BTFSC       STATUS+0, 0 
	GOTO        L_interrupt15
;p9horno.c,82 :: 		Q = 2;
	MOVLW       2
	MOVWF       _Q+0 
	MOVLW       0
	MOVWF       _Q+1 
;p9horno.c,83 :: 		}else{
	GOTO        L_interrupt16
L_interrupt15:
;p9horno.c,84 :: 		Q = 1;
	MOVLW       1
	MOVWF       _Q+0 
	MOVLW       0
	MOVWF       _Q+1 
;p9horno.c,85 :: 		}
L_interrupt16:
;p9horno.c,86 :: 		}else{
	GOTO        L_interrupt17
L_interrupt14:
;p9horno.c,87 :: 		Q = 0;
	CLRF        _Q+0 
	CLRF        _Q+1 
;p9horno.c,88 :: 		}
L_interrupt17:
;p9horno.c,90 :: 		}
L_interrupt13:
L_interrupt7:
;p9horno.c,93 :: 		INTCON.TMR0IF = 0;
	BCF         INTCON+0, 2 
;p9horno.c,94 :: 		}
L_interrupt3:
;p9horno.c,96 :: 		}
L_end_interrupt:
L__interrupt23:
	RETFIE      1
; end of _interrupt

_main:

;p9horno.c,98 :: 		void main(){
;p9horno.c,100 :: 		TRISA.B4 = 1; // Boton encendido
	BSF         TRISA+0, 4 
;p9horno.c,101 :: 		TRISA.B0 = 1; // Voltaje medio termometro
	BSF         TRISA+0, 0 
;p9horno.c,102 :: 		TRISA.B1 = 1; // Voltaje mando
	BSF         TRISA+0, 1 
;p9horno.c,103 :: 		TRISA.B2 = 0; // Calentador
	BCF         TRISA+0, 2 
;p9horno.c,106 :: 		ADCON0 = 0x44;
	MOVLW       68
	MOVWF       ADCON0+0 
;p9horno.c,107 :: 		ADCON1 = 0xC4;
	MOVLW       196
	MOVWF       ADCON1+0 
;p9horno.c,110 :: 		PIR1.ADIF = 0;
	BCF         PIR1+0, 6 
;p9horno.c,111 :: 		PIE1.ADIE = 1;
	BSF         PIE1+0, 6 
;p9horno.c,114 :: 		T0CON = 0x81;
	MOVLW       129
	MOVWF       T0CON+0 
;p9horno.c,117 :: 		TMR0L = ALPHA_TMR;
	MOVLW       132
	MOVWF       TMR0L+0 
;p9horno.c,118 :: 		TMR0H = (ALPHA_TMR >> 8);
	MOVLW       109
	MOVWF       TMR0H+0 
;p9horno.c,121 :: 		INTCON.TMR0IF = 0;
	BCF         INTCON+0, 2 
;p9horno.c,122 :: 		INTCON.TMR0IE = 1;
	BSF         INTCON+0, 5 
;p9horno.c,125 :: 		INTCON.GIE = 1;
	BSF         INTCON+0, 7 
;p9horno.c,127 :: 		while(1){
L_main18:
;p9horno.c,129 :: 		}
	GOTO        L_main18
;p9horno.c,130 :: 		}
L_end_main:
	GOTO        $+0
; end of _main
