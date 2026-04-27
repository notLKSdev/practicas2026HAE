
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
;p9horno.c,36 :: 		tMax = tMax * LAMBDA_AD * 50;
	CALL        _int2double+0, 0
	MOVLW       82
	MOVWF       R4 
	MOVLW       39
	MOVWF       R5 
	MOVLW       32
	MOVWF       R6 
	MOVLW       119
	MOVWF       R7 
	CALL        _Mul_32x32_FP+0, 0
	MOVLW       0
	MOVWF       R4 
	MOVLW       0
	MOVWF       R5 
	MOVLW       72
	MOVWF       R6 
	MOVLW       132
	MOVWF       R7 
	CALL        _Mul_32x32_FP+0, 0
	CALL        _double2int+0, 0
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
;p9horno.c,41 :: 		t = t * LAMBDA_AD * 50;
	CALL        _int2double+0, 0
	MOVLW       82
	MOVWF       R4 
	MOVLW       39
	MOVWF       R5 
	MOVLW       32
	MOVWF       R6 
	MOVLW       119
	MOVWF       R7 
	CALL        _Mul_32x32_FP+0, 0
	MOVLW       0
	MOVWF       R4 
	MOVLW       0
	MOVWF       R5 
	MOVLW       72
	MOVWF       R6 
	MOVLW       132
	MOVWF       R7 
	CALL        _Mul_32x32_FP+0, 0
	CALL        _double2int+0, 0
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
;p9horno.c,52 :: 		if(readController){
	MOVF        _readController+0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_interrupt4
;p9horno.c,53 :: 		goTermometherAD();
	CALL        _goTermometherAD+0, 0
;p9horno.c,54 :: 		}else{
	GOTO        L_interrupt5
L_interrupt4:
;p9horno.c,55 :: 		goControllerAD();
	CALL        _goControllerAD+0, 0
;p9horno.c,56 :: 		}
L_interrupt5:
;p9horno.c,58 :: 		if(Q == 0){ // Horno apagado
	MOVLW       0
	XORWF       _Q+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__interrupt26
	MOVLW       0
	XORWF       _Q+0, 0 
L__interrupt26:
	BTFSS       STATUS+0, 2 
	GOTO        L_interrupt6
;p9horno.c,59 :: 		heater = 0;
	CLRF        _heater+0 
	CLRF        _heater+1 
;p9horno.c,60 :: 		if(enable == 0){
	MOVLW       0
	XORWF       _enable+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__interrupt27
	MOVLW       0
	XORWF       _enable+0, 0 
L__interrupt27:
	BTFSS       STATUS+0, 2 
	GOTO        L_interrupt7
;p9horno.c,61 :: 		Q = 0;
	CLRF        _Q+0 
	CLRF        _Q+1 
;p9horno.c,62 :: 		}else{
	GOTO        L_interrupt8
L_interrupt7:
;p9horno.c,63 :: 		Q = 1;
	MOVLW       1
	MOVWF       _Q+0 
	MOVLW       0
	MOVWF       _Q+1 
;p9horno.c,64 :: 		}
L_interrupt8:
;p9horno.c,66 :: 		}else if(Q == 1){ // Temperatura menor a tMax
	GOTO        L_interrupt9
L_interrupt6:
	MOVLW       0
	XORWF       _Q+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__interrupt28
	MOVLW       1
	XORWF       _Q+0, 0 
L__interrupt28:
	BTFSS       STATUS+0, 2 
	GOTO        L_interrupt10
;p9horno.c,67 :: 		if(enable == 1){
	MOVLW       0
	XORWF       _enable+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__interrupt29
	MOVLW       1
	XORWF       _enable+0, 0 
L__interrupt29:
	BTFSS       STATUS+0, 2 
	GOTO        L_interrupt11
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
	GOTO        L__interrupt30
	MOVF        _tMax+0, 0 
	SUBWF       _t+0, 0 
L__interrupt30:
	BTFSC       STATUS+0, 0 
	GOTO        L_interrupt12
;p9horno.c,70 :: 		Q = 1;
	MOVLW       1
	MOVWF       _Q+0 
	MOVLW       0
	MOVWF       _Q+1 
;p9horno.c,71 :: 		}else{
	GOTO        L_interrupt13
L_interrupt12:
;p9horno.c,72 :: 		Q = 2;
	MOVLW       2
	MOVWF       _Q+0 
	MOVLW       0
	MOVWF       _Q+1 
;p9horno.c,73 :: 		}
L_interrupt13:
;p9horno.c,74 :: 		}else{
	GOTO        L_interrupt14
L_interrupt11:
;p9horno.c,75 :: 		Q = 0;
	CLRF        _Q+0 
	CLRF        _Q+1 
;p9horno.c,76 :: 		}
L_interrupt14:
;p9horno.c,78 :: 		}else{ // Temperatura mayor a tMin
	GOTO        L_interrupt15
L_interrupt10:
;p9horno.c,79 :: 		if(enable == 1){
	MOVLW       0
	XORWF       _enable+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__interrupt31
	MOVLW       1
	XORWF       _enable+0, 0 
L__interrupt31:
	BTFSS       STATUS+0, 2 
	GOTO        L_interrupt16
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
	GOTO        L__interrupt32
	MOVF        _t+0, 0 
	SUBWF       _tMin+0, 0 
L__interrupt32:
	BTFSC       STATUS+0, 0 
	GOTO        L_interrupt17
;p9horno.c,82 :: 		Q = 2;
	MOVLW       2
	MOVWF       _Q+0 
	MOVLW       0
	MOVWF       _Q+1 
;p9horno.c,83 :: 		}else{
	GOTO        L_interrupt18
L_interrupt17:
;p9horno.c,84 :: 		Q = 1;
	MOVLW       1
	MOVWF       _Q+0 
	MOVLW       0
	MOVWF       _Q+1 
;p9horno.c,85 :: 		}
L_interrupt18:
;p9horno.c,86 :: 		}else{
	GOTO        L_interrupt19
L_interrupt16:
;p9horno.c,87 :: 		Q = 0;
	CLRF        _Q+0 
	CLRF        _Q+1 
;p9horno.c,88 :: 		}
L_interrupt19:
;p9horno.c,90 :: 		}
L_interrupt15:
L_interrupt9:
;p9horno.c,92 :: 		PORTA.B2 = heater;
	BTFSC       _heater+0, 0 
	GOTO        L__interrupt33
	BCF         PORTA+0, 2 
	GOTO        L__interrupt34
L__interrupt33:
	BSF         PORTA+0, 2 
L__interrupt34:
;p9horno.c,94 :: 		TMR0L = ALPHA_TMR;
	MOVLW       132
	MOVWF       TMR0L+0 
;p9horno.c,95 :: 		TMR0H = (ALPHA_TMR >> 8);
	MOVLW       109
	MOVWF       TMR0H+0 
;p9horno.c,97 :: 		INTCON.TMR0IF = 0;
	BCF         INTCON+0, 2 
;p9horno.c,98 :: 		}
L_interrupt3:
;p9horno.c,100 :: 		}
L_end_interrupt:
L__interrupt25:
	RETFIE      1
; end of _interrupt

_main:

;p9horno.c,102 :: 		void main(){
;p9horno.c,104 :: 		TRISA.B4 = 1; // Boton encendido
	BSF         TRISA+0, 4 
;p9horno.c,105 :: 		TRISA.B0 = 1; // Voltaje medio termometro
	BSF         TRISA+0, 0 
;p9horno.c,106 :: 		TRISA.B1 = 1; // Voltaje mando
	BSF         TRISA+0, 1 
;p9horno.c,107 :: 		TRISA.B2 = 0; // Calentador
	BCF         TRISA+0, 2 
;p9horno.c,110 :: 		ADCON0 = 0x44;
	MOVLW       68
	MOVWF       ADCON0+0 
;p9horno.c,111 :: 		ADCON1 = 0xC4;
	MOVLW       196
	MOVWF       ADCON1+0 
;p9horno.c,114 :: 		PIR1.ADIF = 0;
	BCF         PIR1+0, 6 
;p9horno.c,115 :: 		PIE1.ADIE = 1;
	BSF         PIE1+0, 6 
;p9horno.c,118 :: 		T0CON = 0x81;
	MOVLW       129
	MOVWF       T0CON+0 
;p9horno.c,121 :: 		TMR0L = ALPHA_TMR;
	MOVLW       132
	MOVWF       TMR0L+0 
;p9horno.c,122 :: 		TMR0H = (ALPHA_TMR >> 8);
	MOVLW       109
	MOVWF       TMR0H+0 
;p9horno.c,125 :: 		INTCON.TMR0IF = 0;
	BCF         INTCON+0, 2 
;p9horno.c,126 :: 		INTCON.TMR0IE = 1;
	BSF         INTCON+0, 5 
;p9horno.c,129 :: 		INTCON.GIE = 1;
	BSF         INTCON+0, 7 
;p9horno.c,131 :: 		while(1){
L_main20:
;p9horno.c,133 :: 		}
	GOTO        L_main20
;p9horno.c,134 :: 		}
L_end_main:
	GOTO        $+0
; end of _main
