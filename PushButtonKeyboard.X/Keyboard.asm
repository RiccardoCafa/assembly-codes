;   Riccardo Cafagna 
;
;   Read an input using the keyboard
;   Start counting with #
;   Doesn't use TMR0/INT
;

; TODO INSERT CONFIG HERE
#include "p16f877a.inc"
 __CONFIG _FOSC_EXTRC & _WDTE_OFF & _PWRTE_OFF & _BOREN_OFF & _LVP_OFF & _CPD_OFF & _WRT_OFF & _CP_OFF
    
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
    
 ;     RB0 RB1 RB2
 ; RD3  1   2   3
 ; RD2  4   5   6
 ; RD1  7   8   9
 ; RD0  *   0   #
 
SHOW9 MACRO VALUE, ADDRESS

    BTFSS VALUE, 0 ; 1001
    GOTO ADDRESS
    BTFSC VALUE, 1
    GOTO ADDRESS
    BTFSC VALUE, 2
    GOTO ADDRESS
    BTFSS VALUE, 3
    GOTO ADDRESS
    
    MOVLW VAL9
    MOVWF AUXDIS
    
    SHOWHANDLER
    ENDM
    
SHOW8 MACRO VALUE, ADDRESS
 
    BTFSC VALUE, 0 ; 1000
    GOTO ADDRESS
    BTFSC VALUE, 1
    GOTO ADDRESS
    BTFSC VALUE, 2
    GOTO ADDRESS
    BTFSS VALUE, 3
    GOTO ADDRESS
    
    MOVLW VAL8
    MOVWF AUXDIS
    
    SHOWHANDLER
    ENDM
    
SHOW7 MACRO VALUE, ADDRESS
 
    BTFSS VALUE, 0 ; 0111
    GOTO ADDRESS
    BTFSS VALUE, 1
    GOTO ADDRESS
    BTFSS VALUE, 2
    GOTO ADDRESS
    BTFSC VALUE, 3
    GOTO ADDRESS
    
    MOVLW VAL7
    MOVWF AUXDIS
    
    SHOWHANDLER
    ENDM
    
SHOW6 MACRO VALUE, ADDRESS
 
    BTFSC VALUE, 0 ; 0110
    GOTO ADDRESS
    BTFSS VALUE, 1
    GOTO ADDRESS
    BTFSS VALUE, 2
    GOTO ADDRESS
    BTFSC VALUE, 3
    GOTO ADDRESS
    
    MOVLW VAL6
    MOVWF AUXDIS
    
    SHOWHANDLER
    ENDM
    
SHOW5 MACRO VALUE, ADDRESS
 
    BTFSS VALUE, 0 ; 0101
    GOTO ADDRESS
    BTFSC VALUE, 1
    GOTO ADDRESS
    BTFSS VALUE, 2
    GOTO ADDRESS
    BTFSC VALUE, 3
    GOTO ADDRESS
    
    MOVLW VAL5
    MOVWF AUXDIS
    
    SHOWHANDLER
    ENDM
    
SHOW4 MACRO VALUE, ADDRESS
 
    BTFSC VALUE, 0 ; 0100
    GOTO ADDRESS
    BTFSC VALUE, 1
    GOTO ADDRESS
    BTFSS VALUE, 2
    GOTO ADDRESS
    BTFSC VALUE, 3
    GOTO ADDRESS
    
    MOVLW VAL4
    MOVWF AUXDIS
    
    SHOWHANDLER
    ENDM
        
SHOW3 MACRO VALUE, ADDRESS
 
    BTFSS VALUE, 0 ; 0011
    GOTO ADDRESS
    BTFSS VALUE, 1
    GOTO ADDRESS
    BTFSC VALUE, 2
    GOTO ADDRESS
    BTFSC VALUE, 3
    GOTO ADDRESS
    
    MOVLW VAL3
    MOVWF AUXDIS
    
    SHOWHANDLER
    ENDM
    
SHOW2 MACRO VALUE, ADDRESS
 
    BTFSC VALUE, 0 ; 0010
    GOTO ADDRESS
    BTFSS VALUE, 1
    GOTO ADDRESS
    BTFSC VALUE, 2
    GOTO ADDRESS
    BTFSC VALUE, 3
    GOTO ADDRESS
    
    MOVLW VAL2
    MOVWF AUXDIS
    
    SHOWHANDLER
    ENDM
      
SHOW1 MACRO VALUE, ADDRESS
 
    BTFSS VALUE, 0 ; 0001
    GOTO ADDRESS
    BTFSC VALUE, 1
    GOTO ADDRESS
    BTFSC VALUE, 2
    GOTO ADDRESS
    BTFSC VALUE, 3
    GOTO ADDRESS
    
    MOVLW VAL1
    MOVWF AUXDIS
    
    SHOWHANDLER
    ENDM
          
SHOW0 MACRO VALUE, ADDRESS
 
    BTFSC VALUE, 0 ; 0000
    GOTO ADDRESS
    BTFSC VALUE, 1
    GOTO ADDRESS
    BTFSC VALUE, 2
    GOTO ADDRESS
    BTFSC VALUE, 3
    GOTO ADDRESS
    
    MOVLW VAL0
    MOVWF AUXDIS
    
    SHOWHANDLER
    
    ENDM
    
SHOWHANDLER MACRO
    BTFSC POG, 0
    GOTO PRIMEIRO
    GOTO SEGUNDO
    ENDM
    
SETADISPLAY MACRO
    BANK1
    CLRF TRISD
    CLRF TRISA
    BANK0
    ENDM
    
SETATECLADO MACRO
    BANK1
    CLRF TRISB
    MOVLW B'00001111'
    MOVWF TRISD
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
 
; TODO PLACE VARIABLE DEFINITIONS GO HERE
GPR_VAR        UDATA
FT1MS		RES        1      ;
FT250MS		RES        1
FT1S		RES        1
CRNT		RES	   1	;
AUX		RES	   1   
REG		RES	   1
VALDIS1		RES	   1
VALDIS2		RES	   1
AUXDIS		RES	   1
POG		RES	   1
TEMPAO		RES	   1
SETOU		RES	   1
STOPPED		RES	   1

RES_VECT  CODE    0x0000            ; processor reset vector
    GOTO    START                   ; go to beginning of program

; TODO INSERT ISR HERE

MAIN_PROG CODE                      ; let linker place main program

START
    SETATECLADO
    ; TODO Step #5 - Insert Your Program Here

MAIN_LOOP
    
    BCF PORTB, RB0
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
    CALL DELAY_1MS
    CALL DELAY_1MS
    BTFSS TRISD, RD0
    CALL CONTA
    BSF PORTB, RB2
    CALL DELAY_1MS
    CALL DELAY_1MS
    
    SETADISPLAY
    MOVF CRNT, W
    MOVWF AUX
    MOVLW B'1'
    MOVWF POG
    
    SHOW9 AUX, S8
    SETATECLADO
    
    GOTO MAIN_LOOP                          ; loop forever
    
CONTA
    SETADISPLAY
    MOVLW D'1'
    MOVWF STOPPED
    
DIS_LOOP
    MOVF CRNT, W
    MOVWF AUX
    MOVLW B'1'
    MOVWF POG
    
    SHOW9 AUX, S8
    GOTO CONTA
    
SETA
    BTFSC SETOU, 0
    GOTO SETA_SEG
    
    MOVWF CRNT
    MOVLW D'1'
    MOVWF SETOU
    RETURN

SETA_SEG
    MOVWF REG
    RETURN
    
PRIMEIRO
    MOVF AUXDIS
    MOVWF VALDIS1
    
    MOVF REG, W
    MOVWF AUX
    MOVLW B'0'
    MOVWF POG
    SHOW9 AUX, S8
    
SEGUNDO
    MOVF AUXDIS
    MOVWF VALDIS2
    GOTO FINISH
    
S8
    SHOW8 AUX, S7
S7
    SHOW7 AUX, S6
S6
    SHOW6 AUX, S5
S5
    SHOW5 AUX, S4
S4
    SHOW4 AUX, S3
S3
    SHOW3 AUX, S2
S2
    SHOW2 AUX, S1
S1
    SHOW1 AUX, S0
S0
    SHOW0 AUX, FINISH
    
FINISH
    MOVLW D'250'
    MOVWF TEMPAO
    
    CALL UPDATE_DISPLAY
    
    BTFSS STOPPED, 0
    RETURN
    
    DECFSZ REG, 1
    GOTO DIS_LOOP                          ; loop forever
    GOTO MANAGER_COUNTER

MANAGER_COUNTER
    
    DECFSZ CRNT, 1
    MOVLW VAL0
    MOVWF VALDIS2
    MOVLW B'00001001'
    MOVWF REG

    CALL UPDATE_DISPLAY
    GOTO DIS_LOOP
   
UPDATE_DISPLAY
    CALL DIS_2
    MOVF VALDIS2, W
    MOVWF PORTD
    
    CALL DELAY_1MS
    CALL DELAY_1MS
    
    CALL DIS_1
    MOVF VALDIS1, W
    MOVWF PORTD
    
    CALL DELAY_1MS
    CALL DELAY_1MS
    
    BTFSS STOPPED, 0
    RETURN
    DECFSZ TEMPAO, 1
    GOTO UPDATE_DISPLAY
    RETURN

DIS_1
    MOVLW B'00010000'
    MOVWF  PORTA
    RETURN
    
DIS_2
    MOVLW B'00100000'
    MOVWF PORTA
    RETURN
    
DELAY_1MS
    MOVLW D'165'        ; Var <-- N
    MOVWF FT1MS
DELAY_LOOP
    DECFSZ FT1MS, 1    ;1CM ; 0-> 2CM
    GOTO  DELAY_LOOP ;2CM ;(N-1)*(1CM+2CM) + 2CM = (N-1)*3CM +2CM = (3N-1)*CM
    ;--              ;CM = 2us; 1000us = 500CM; 500 = 3N-1 => N = 166
    RETURN
    
    END