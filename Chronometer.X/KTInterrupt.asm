
;   Riccardo Cafagna 
;
;   Read an input using the keyboard
;   Start counting with * or #
;   Stop/resume with RB0/INT
;
    
; TODO INSERT INCLUDE CODE HERE
#include "p16f877a.inc"
    
; TODO INSERT CONFIG HERE
 __CONFIG _FOSC_EXTRC & _WDTE_OFF & _PWRTE_OFF & _BOREN_OFF & _LVP_OFF & _CPD_OFF & _WRT_OFF & _CP_OFF
 
; TODO PLACE VARIABLE DEFINITIONS GO HERE
GPR_VAR    UDATA
FT1MS		    RES	    1
STOPPED		    RES	    1
SETOU		    RES	    1
SEGUNDOS	    RES	    1
DEZENAS		    RES	    1
DISPLAY_01	    RES	    1
DISPLAY_02	    RES	    1
COUNT8		    RES	    1
	   
BANK0 MACRO
 BCF STATUS, RP1;RP1:RP0
 BCF STATUS, RP0
 ENDM

BANK1 MACRO
 BCF STATUS, RP1;RP1:RP0
 BSF STATUS, RP0
 ENDM

BANK2 MACRO
 BSF STATUS, RP1;RP1:RP0
 BCF STATUS, RP0
 ENDM

BANK3 MACRO
 BSF STATUS, RP1;RP1:RP0
 BSF STATUS, RP0
 ENDM
     
SETADISPLAY MACRO
    BANK1
    CLRF TRISA
    CLRF TRISD
    BANK0
    ENDM
    
SETATECLADO MACRO
    BANK1
    CLRF TRISB
    MOVLW B'00001111'
    MOVWF TRISD
    MOVLW B'00001111'
    MOVWF TRISA
    BANK0
    ENDM
    
VAL0 EQU B'00111111'
VAL1 EQU B'00000110'
VAL2 EQU B'01011011'
VAL3 EQU B'01001111'
VAL4 EQU B'01100110'
VAL5 EQU B'01101101'
VAL6 EQU B'01111100'
VAL7 EQU B'00000111'
VAL8 EQU B'01111111'
VAL9 EQU B'01100111'
TMRVALUE EQU D'24'
 
RES_VECT  CODE    0x0000            ; processor reset vector
    GOTO    START                   ; go to beginning of program

; TODO INSERT ISR HERE
ISR CODE 0X0004
 BTFSC INTCON, TMR0IF
 CALL DECREMENTA
 BTFSC INTCON, INTF
 CALL PAUSA
RETFIE
    
 ;     RB0 RB1 RB2
 ; RD3  1   2   3
 ; RD2  4   5   6
 ; RD1  7   8   9
 ; RD0  *   0   #
 
MAIN_PROG CODE                      ; let linker place main program

START
    BANK1
    CLRF TRISD
    CLRF TRISA
    BANK0
    CLRF DEZENAS
    
    SETADISPLAY
    
    CALL DIS_2
    
    MOVLW VAL0
    MOVWF DISPLAY_01
    MOVF DISPLAY_01, W
    MOVWF PORTD
    
    ; loop forever    
MAIN
    BTFSS STOPPED, 0
    
    CALL LER_TECLADO_MATRICIAL
POG
    SETADISPLAY
    
    CLRF PORTD
    MOVF DISPLAY_01, W
    MOVWF PORTD
    
    CALL DELAY_1MS
    CALL DELAY_1MS
    
    CALL MOSTRAR_DISPLAY
    
    CLRF PORTD
    MOVF DISPLAY_01, W
    MOVWF PORTD
    
    CALL DELAY_1MS
    CALL DELAY_1MS
    
    GOTO MAIN

MOSTRAR_DISPLAY
    
    SETADISPLAY
    
    MOVLW D'9'
    SUBWF SEGUNDOS, W
    MOVLW VAL9
    BTFSC STATUS, Z
    GOTO ACHOU
    
    MOVLW D'8'
    SUBWF SEGUNDOS, W
    MOVLW VAL8
    BTFSC STATUS, Z
    GOTO ACHOU
    
    MOVLW D'7'
    SUBWF SEGUNDOS, W
    MOVLW VAL7
    BTFSC STATUS, Z
    GOTO ACHOU
    
    MOVLW D'6'
    SUBWF SEGUNDOS, W
    MOVLW VAL6
    BTFSC STATUS, Z
    GOTO ACHOU
    
    MOVLW D'5'
    SUBWF SEGUNDOS, W
    MOVLW VAL5
    BTFSC STATUS, Z
    GOTO ACHOU
    
    MOVLW D'4'
    SUBWF SEGUNDOS, W
    MOVLW VAL4
    BTFSC STATUS, Z
    GOTO ACHOU
    
    MOVLW D'3'
    SUBWF SEGUNDOS, W
    MOVLW VAL3
    BTFSC STATUS, Z
    GOTO ACHOU
    
    MOVLW D'2'
    SUBWF SEGUNDOS, W
    MOVLW VAL2
    BTFSC STATUS, Z
    GOTO ACHOU
    
    MOVLW D'1'
    SUBWF SEGUNDOS, W
    MOVLW VAL1
    BTFSC STATUS, Z
    GOTO ACHOU
    
    MOVLW VAL0
    
ACHOU
    
    MOVWF DISPLAY_01
    
    RETURN
    
LER_TECLADO_MATRICIAL
    SETATECLADO
    
    BCF PORTB, RB0
    BTFSS TRISD, RD0
    CALL MAGIC_BUTTON
    CALL DELAY_1MS
    CALL DELAY_1MS
    MOVLW D'7'
    BTFSS TRISD, RD1
    CALL SETA
    CALL DELAY_1MS
    CALL DELAY_1MS
    MOVLW D'4'
    BTFSS TRISD, RD2
    CALL SETA
    CALL DELAY_1MS
    CALL DELAY_1MS
    MOVLW D'1'
    BTFSS TRISD, RD3
    CALL SETA
    BSF PORTB, RB0
    CALL DELAY_1MS
    CALL DELAY_1MS
    
    BCF PORTB, RB1
    MOVLW D'0'
    BTFSS TRISD, RD0
    CALL SETA
    CALL DELAY_1MS
    CALL DELAY_1MS
    MOVLW D'8'
    BTFSS TRISD, RD1
    CALL SETA
    CALL DELAY_1MS
    CALL DELAY_1MS
    MOVLW D'5'
    BTFSS TRISD, RD2
    CALL SETA
    CALL DELAY_1MS
    CALL DELAY_1MS
    MOVLW D'2'
    BTFSS TRISD, RD3
    CALL SETA
    BSF PORTB, RB1
    CALL DELAY_1MS
    CALL DELAY_1MS
    
    BCF PORTB, RB2
    MOVLW D'9'
    BTFSS TRISD, RD1
    CALL SETA
    CALL DELAY_1MS
    CALL DELAY_1MS
    MOVLW D'6'
    BTFSS TRISD, RD2
    CALL SETA
    CALL DELAY_1MS
    CALL DELAY_1MS
    MOVLW D'3'
    BTFSS TRISD, RD3
    CALL SETA
    BTFSS TRISD, RD0
    CALL MAGIC_BUTTON
    CALL DELAY_1MS
    CALL DELAY_1MS
    BSF PORTB, RB2
    CALL DELAY_1MS
    CALL DELAY_1MS
    
    RETURN

DECREMENTA
    BCF INTCON, TMR0IF
    
    DECFSZ COUNT8
    RETURN
    
    MOVLW TMRVALUE
    MOVWF COUNT8
    
    DECFSZ SEGUNDOS
    RETURN;
    
    BCF INTCON, TMR0IE
    CALL LIBERA_TECLADO
    RETURN
    
MAGIC_BUTTON
    CALL PAUSA_TECLADO
    CALL CONFIG_INTER
    GOTO POG
    
PAUSA_TECLADO
    BSF STOPPED, 0
    RETURN
    
LIBERA_TECLADO
    BCF STOPPED, 0
    RETURN
    
DELAY_1MS
    MOVLW D'165'        ; Var <-- N
    MOVWF FT1MS
DELAY_LOOP
    DECFSZ FT1MS, 1    ;1CM ; 0-> 2CM
    GOTO  DELAY_LOOP ;2CM ;(N-1)*(1CM+2CM) + 2CM = (N-1)*3CM +2CM = (3N-1)*CM
    ;--              ;CM = 2us; 1000us = 500CM; 500 = 3N-1 => N = 166
    RETURN
    
PAUSA
    BCF INTCON, INTF
    
    BTFSS INTCON, TMR0IE
    GOTO RETOMA
    BCF INTCON, TMR0IE
    RETURN
RETOMA
    BSF INTCON, TMR0IE
    RETURN
    
CONFIG_INTER
    BANK1
    CLRF TRISD
    BSF PORTB, RB0
    
    BCF OPTION_REG, PSA; HABILITA PSA PRO TIMER 0
    BSF OPTION_REG, PS2
    BSF OPTION_REG, PS1
    BCF OPTION_REG, PS0
    BANK0
    
    MOVLW D'12'
    MOVWF TMR0
    
    MOVLW TMRVALUE
    MOVWF COUNT8
 
    BCF INTCON, TMR0IF
    BSF INTCON, TMR0IE
    BCF INTCON, INTF
    BSF INTCON, INTE
    BSF INTCON, GIE
    RETURN
    
SETA
    MOVWF SEGUNDOS
    RETURN

SETA_SEG
    MOVWF DEZENAS
    RETURN
    
DIS_1
    MOVLW B'00010000'
    MOVWF  PORTA
    RETURN
    
DIS_2
    MOVLW B'00100000'
    MOVWF PORTA
    RETURN
    
    END