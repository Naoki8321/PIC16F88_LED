    LIST  P=16F88
    #INCLUDE "p16f88.inc"
; CONFIG1
; __config 0xEF70
 __CONFIG _CONFIG1, _INTRC_IO & _WDT_OFF & _PWRTE_ON & _MCLRE_OFF & _BOREN_ON & _LVP_OFF & _CPD_OFF & _WRT_OFF & _CPD_OFF
; CONFIG2
; __config 0xFFFC
 __CONFIG _CONFIG2, _FCMEN_OFF & _IESO_OFF
 
CNT1    EQU         20H
CNT2    EQU         21H
CNT3    EQU         22H
 
        ORG         0
INIT
	;<< PICの初期化	>>
        BSF         STATUS,RP0  ; Bank1に切替え
        MOVLW       70H         ; 内蔵クロックの周波数を8MHzに設定
        MOVWF       OSCCON	; 内蔵クロック設定
        CLRF        TRISB       ; PORTBの入出力設定
	BCF         STATUS,RP0  ; Bank0に切替え
 
MAIN_LOOP
        MOVLW	    01H		; RB0設定
	MOVWF	    PORTB	; RB0を1にする
	
	CALL        TIMER3      ; 0.5s待ち
	CLRF	    PORTB	; PORT Bをクリア(RB0を0)
	
	CALL	    TIMER3	; 0.5s待ち
        GOTO        MAIN_LOOP   ; 無限ループ
 
TIMER3                          ; 0.5s 999023サイクル
        MOVLW       D'5'
        MOVWF       CNT3
LOOP3
        CALL        TIMER2
        DECFSZ      CNT3,F
        GOTO        LOOP3
        RETURN
 
TIMER2                          ; 100ms 199799サイクル
        MOVLW       D'199'
        MOVWF       CNT2
LOOP2
        CALL        TIMER1
        DECFSZ      CNT2,F
        GOTO        LOOP2
        RETURN
 
TIMER1                          ; 0.5ms 999サイクル
        MOVLW       D'249'
        MOVWF       CNT1
LOOP1
        NOP
        DECFSZ      CNT1,F
        GOTO        LOOP1
        RETURN
 
	END