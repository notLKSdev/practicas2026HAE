
_interrupt:

;p9horno.c,1 :: 		void interrupt(){
;p9horno.c,5 :: 		}
L_end_interrupt:
L__interrupt3:
	RETFIE      1
; end of _interrupt

_main:

;p9horno.c,7 :: 		void main(){
;p9horno.c,10 :: 		while(1){
L_main0:
;p9horno.c,12 :: 		}
	GOTO        L_main0
;p9horno.c,13 :: 		}
L_end_main:
	GOTO        $+0
; end of _main
