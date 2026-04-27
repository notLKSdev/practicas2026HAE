
_temperatureToVoltage:

;p9horno.c,15 :: 		int temperatureToVoltage(int voltage){
;p9horno.c,16 :: 		return voltage * 50;
	MOVF        FARG_temperatureToVoltage_voltage+0, 0 
	MOVWF       R0 
	MOVF        FARG_temperatureToVoltage_voltage+1, 0 
	MOVWF       R1 
	MOVLW       50
	MOVWF       R4 
	MOVLW       0
	MOVWF       R5 
	CALL        _Mul_16X16_U+0, 0
;p9horno.c,17 :: 		}
L_end_temperatureToVoltage:
	RETURN      0
; end of _temperatureToVoltage

_goControllerAD:

;p9horno.c,19 :: 		void goControllerAD(){
;p9horno.c,20 :: 		ADCON0 = 0x44;
	MOVLW       68
	MOVWF       ADCON0+0 
;p9horno.c,21 :: 		ADCON1 = 0xC4;
	MOVLW       196
	MOVWF       ADCON1+0 
;p9horno.c,22 :: 		readController = true;
	MOVLW       1
	MOVWF       _readController+0 
;p9horno.c,23 :: 		ADCON0.GO = 1;
	BSF         ADCON0+0, 2 
;p9horno.c,24 :: 		}
L_end_goControllerAD:
	RETURN      0
; end of _goControllerAD

_goTermometherAD:

;p9horno.c,26 :: 		void goTermometherAD(){
;p9horno.c,27 :: 		ADCON0 = 0x41;
	MOVLW       65
	MOVWF       ADCON0+0 
;p9horno.c,28 :: 		ADCON1 = 0xCE;
	MOVLW       206
	MOVWF       ADCON1+0 
;p9horno.c,29 :: 		readController = false;
	CLRF        _readController+0 
;p9horno.c,30 :: 		ADCON0.GO = 1;
	BSF         ADCON0+0, 2 
;p9horno.c,31 :: 		}
L_end_goTermometherAD:
	RETURN      0
; end of _goTermometherAD

_interrupt:

;p9horno.c,33 :: 		void interrupt(){
;p9horno.c,35 :: 		if(PIR1.ADIF == 1){
	BTFSS       PIR1+0, 6 
	GOTO        L_interrupt0
;p9horno.c,37 :: 		if(readController == true){
	MOVF        _readController+0, 0 
	XORLW       1
	BTFSS       STATUS+0, 2 
	GOTO        L_interrupt1
;p9horno.c,38 :: 		tMax = (ADRESH << 8) + ADRESL;
	MOVF        ADRESH+0, 0 
	MOVWF       _tMax+1 
	CLRF        _tMax+0 
	MOVF        ADRESL+0, 0 
	ADDWF       _tMax+0, 1 
	MOVLW       0
	ADDWFC      _tMax+1, 1 
;p9horno.c,39 :: 		}else{
	GOTO        L_interrupt2
L_interrupt1:
;p9horno.c,40 :: 		t = (ADRESH << 8) + ADRESL;
	MOVF        ADRESH+0, 0 
	MOVWF       _t+1 
	CLRF        _t+0 
	MOVF        ADRESL+0, 0 
	ADDWF       _t+0, 1 
	MOVLW       0
	ADDWFC      _t+1, 1 
;p9horno.c,41 :: 		}
L_interrupt2:
;p9horno.c,43 :: 		PIR1.ADIF = 0;
	BCF         PIR1+0, 6 
;p9horno.c,44 :: 		}
L_interrupt0:
;p9horno.c,47 :: 		if(INTCON.TMR0IF == 1){
	BTFSS       INTCON+0, 2 
	GOTO        L_interrupt3
;p9horno.c,49 :: 		enable = PORTA.B4;
	MOVLW       0
	BTFSC       PORTA+0, 4 
	MOVLW       1
	MOVWF       _enable+0 
	CLRF        _enable+1 
;p9horno.c,52 :: 		goControllerAD();
	CALL        _goControllerAD+0, 0
;p9horno.c,55 :: 		if(Q == 0){ // Horno apagado
	MOVLW       0
	XORWF       _Q+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__interrupt19
	MOVLW       0
	XORWF       _Q+0, 0 
L__interrupt19:
	BTFSS       STATUS+0, 2 
	GOTO        L_interrupt4
;p9horno.c,56 :: 		heater = 0;
	CLRF        _heater+0 
	CLRF        _heater+1 
;p9horno.c,57 :: 		if(enable == 0){
	MOVLW       0
	XORWF       _enable+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__interrupt20
	MOVLW       0
	XORWF       _enable+0, 0 
L__interrupt20:
	BTFSS       STATUS+0, 2 
	GOTO        L_interrupt5
;p9horno.c,58 :: 		Q = 0;
	CLRF        _Q+0 
	CLRF        _Q+1 
;p9horno.c,59 :: 		}else{
	GOTO        L_interrupt6
L_interrupt5:
;p9horno.c,60 :: 		Q = 1;
	MOVLW       1
	MOVWF       _Q+0 
	MOVLW       0
	MOVWF       _Q+1 
;p9horno.c,61 :: 		}
L_interrupt6:
;p9horno.c,63 :: 		}else if(Q == 1){ // Temperatura menor o tMax
	GOTO        L_interrupt7
L_interrupt4:
	MOVLW       0
	XORWF       _Q+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__interrupt21
	MOVLW       1
	XORWF       _Q+0, 0 
L__interrupt21:
	BTFSS       STATUS+0, 2 
	GOTO        L_interrupt8
;p9horno.c,64 :: 		heater = 1;
	MOVLW       1
	MOVWF       _heater+0 
	MOVLW       0
	MOVWF       _heater+1 
;p9horno.c,65 :: 		if(t<tMax){
	MOVLW       128
	XORWF       _t+1, 0 
	MOVWF       R0 
	MOVLW       128
	XORWF       _tMax+1, 0 
	SUBWF       R0, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__interrupt22
	MOVF        _tMax+0, 0 
	SUBWF       _t+0, 0 
L__interrupt22:
	BTFSC       STATUS+0, 0 
	GOTO        L_interrupt9
;p9horno.c,67 :: 		}else{
	GOTO        L_interrupt10
L_interrupt9:
;p9horno.c,68 :: 		Q = 2;
	MOVLW       2
	MOVWF       _Q+0 
	MOVLW       0
	MOVWF       _Q+1 
;p9horno.c,69 :: 		}
L_interrupt10:
;p9horno.c,71 :: 		}else{ // Temperatura mayor a tMin
	GOTO        L_interrupt11
L_interrupt8:
;p9horno.c,73 :: 		}
L_interrupt11:
L_interrupt7:
;p9horno.c,75 :: 		INTCON.TMR0IF = 0;
	BCF         INTCON+0, 2 
;p9horno.c,76 :: 		}
L_interrupt3:
;p9horno.c,78 :: 		}
L_end_interrupt:
L__interrupt18:
	RETFIE      1
; end of _interrupt

_main:

;p9horno.c,80 :: 		void main(){
;p9horno.c,82 :: 		TRISA.B4 = 1; // Boton encendido
	BSF         TRISA+0, 4 
;p9horno.c,83 :: 		TRISA.B0 = 1; // Voltaje medio termometro
	BSF         TRISA+0, 0 
;p9horno.c,84 :: 		TRISA.B1 = 1; // Voltaje mando
	BSF         TRISA+0, 1 
;p9horno.c,87 :: 		ADCON0 = 0x44;
	MOVLW       68
	MOVWF       ADCON0+0 
;p9horno.c,88 :: 		ADCON1 = 0xC4;
	MOVLW       196
	MOVWF       ADCON1+0 
;p9horno.c,91 :: 		PIR1.ADIF = 0;
	BCF         PIR1+0, 6 
;p9horno.c,92 :: 		PIE1.ADIE = 1;
	BSF         PIE1+0, 6 
;p9horno.c,95 :: 		T0CON = 0x81;
	MOVLW       129
	MOVWF       T0CON+0 
;p9horno.c,98 :: 		TMR0L = ALPHA_TMR;
	MOVLW       132
	MOVWF       TMR0L+0 
;p9horno.c,99 :: 		TMR0H = (ALPHA_TMR >> 8);
	MOVLW       109
	MOVWF       TMR0H+0 
;p9horno.c,102 :: 		INTCON.TMR0IF = 0;
	BCF         INTCON+0, 2 
;p9horno.c,103 :: 		INTCON.TMR0IE = 1;
	BSF         INTCON+0, 5 
;p9horno.c,106 :: 		INTCON.GIE = 1;
	BSF         INTCON+0, 7 
;p9horno.c,108 :: 		while(1){
L_main12:
;p9horno.c,110 :: 		}
	GOTO        L_main12
;p9horno.c,111 :: 		}
L_end_main:
	GOTO        $+0
; end of _main
